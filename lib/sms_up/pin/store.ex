defmodule SmsUp.Pin.Store do
  import NaiveDateTime
  use GenServer
  require Logger
  alias SmsUp.Pin.Generator
  alias SmsUp.Db.Pin

  @moduledoc """
  This module stores random pin associated with an id to be checked later.
  Default validity is 10 minutes and is configurable:
  `
  config :sms_up, pin_validity: 15
  `

  Default token size is 6 and can be modified also:
  `
  config :sms_up, :pin_size, 4
  `
  """

  @doc false
  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args)
  end

  @doc false
  @spec init(any) :: {:ok, keyword()}
  def init(args) do
    Logger.info("Starting the One Time Password Store")
    send(self(), :cleanup)
    {:ok, args}
  end

  @doc false
  def handle_info(:cleanup, state) do
    Memento.transaction(fn ->
      for pin <- Memento.Query.all(Pin) do
        if compare(pin.valid_until, utc_now()) === :lt do
          Memento.Query.delete_record(pin)
        end
      end
    end)

    Process.send_after(self(), :cleanup, 60_000)
    {:noreply, state}
  end

  @doc """
  Generate a pin code for the given id and store it in a mnesia database.
  Returns the generated pin code.

  ## Examples

      iex> SmsUp.Pin.Store.store("user@email.ch")
      {:ok, "123456"}
  """
  @spec store(any) :: {:error, String.t()} | {:ok, String.t()}
  def store(id) do
    ensure_db_up()

    case Generator.generate_pin(get_pin_size()) do
      {:ok, pin} ->
        validity = utc_now() |> add(get_pin_validity())

        Memento.transaction(fn ->
          Memento.Query.write(%Pin{id: id, pin: pin, valid_until: validity})
        end)

        {:ok, pin}

      _ ->
        {:error, "Impossible to generate a pin"}
    end
  end

  @doc """
  Validate a pin code along with the user id and tells if the provided pin is correct or not.
  Returns a tupple containing true or false regarding the result.

  ## Examples
      iex> SmsUp.Pin.Store.validate("user@email.ch", "Good Pin")
      {:ok, true}

      iex> SmsUp.Pin.Store.validate("user@email.ch", "Wrong Pin")
      {:ok, false}
  """
  @spec validate(any, String.t()) :: {:ok, true} | {:ok, false}
  def validate(id, pin) do
    ensure_db_up()

    query = [
      {:==, :id, id},
      {:==, :pin, pin}
    ]

    Memento.transaction(fn ->
      case Memento.Query.select(Pin, query) do
        [h | _t] ->
          Memento.Query.delete_record(h)
          true

        _ ->
          false
      end
    end)
  end

  defp ensure_db_up() do
    Memento.Table.create(SmsUp.Db.Pin)
  end

  defp get_pin_validity do
    Application.get_env(:sms_up, :pin_validity, 30) * 60
  end

  defp get_pin_size do
    Application.get_env(:sms_up, :pin_size, 6)
  end
end
