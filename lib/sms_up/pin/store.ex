defmodule SmsUp.Pin.Store do
  import NaiveDateTime
  use GenServer
  require Logger
  require Amnesia
  require Amnesia.Helper
  require Exquisite
  require Database.Pin
  alias SmsUp.Pin.Generator
  alias Database.Pin

  @moduledoc """
  This module stores random pin associated with an id to be checked later.
  Default validity is 10 minutes and is configurable:
  `
  config :sms_up, :pin_validity, 15
  `

  Default token size is 6 and can be modified also:
  `
  config :sms_up, :pin_size, 4
  `
  """

  @seconds_to_minute 60

  @doc false
  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args \\ []) do
    Logger.info("Starting the PIN Store")
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc false
  @spec init(any) :: {:ok, keyword()}
  def init(args) do
    {:ok, args}
  end

  @doc false
  def handle_call({:store, id}, _from, state) do
    ensure_db_up()
    size = get_pin_size(state)
    {:ok, pin} = Generator.generate_pin(size)

    save_pin(id, pin, state)
    {:reply, pin, state}
  end

  @doc false
  def handle_call({:validate, {id, pin}}, _from, state) do
    ensure_db_up()
    reply =
      Amnesia.transaction do
        case Pin.read(id) do
          %Pin{} = res ->
            if res.pin === pin and compare(res.valid_until, utc_now()) === :gt do
              Pin.delete(res)
              {:ok, true}
            else
              {:ok, false}
            end

          _ ->
            {:ok, false}
        end
      end

    {:reply, reply, state}
  end

  @doc """
  Generate a pin code for the given id and store it in a mnesia database.
  Returns the generated pin code.

  ## Examples

      iex> SmsUp.Pin.Store.store("user@email.ch")
      {:ok, "123456"}
  """
  @spec store(any) :: {:ok, String.t()} | {:error, String.t()}
  def store(id) do
    GenServer.call(__MODULE__, {:store, id})
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
    GenServer.call(__MODULE__, {:validate, {id, pin}})
  end

  defp save_pin(id, pin, state) do
    validity = utc_now() |> add(get_pin_validity(state))

    Amnesia.transaction do
      %Pin{id: id, pin: pin, valid_until: validity}
      |> Pin.write()
    end
  end

  defp get_pin_validity(state) do
    Keyword.get(state, :pin_validity, 10) * @seconds_to_minute
  end

  defp get_pin_size(state) do
    Keyword.get(state, :pin_size, 6)
  end

  defp ensure_db_up do
    unless Amnesia.Table.exists?(Pin) do
      Database.create()
    end
  end
end
