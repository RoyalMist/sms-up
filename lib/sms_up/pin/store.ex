defmodule SmsUp.Pin.Store do
  import NaiveDateTime
  use GenServer
  require Logger
  alias SmsUp.Pin.Generator
  alias SmsUp.Pin.Db.Pin

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

  @seconds_to_minute 60

  @doc false
  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc false
  @spec init(any) :: {:ok, keyword()}
  def init(args) do
    Logger.info("Starting the One Time Password Store")
    send(self(), :cleanup)
    {:ok, args}
  end

  @doc false
  def handle_call({:store, id}, _from, state) do
    size = get_pin_size(state)
    {:ok, pin} = Generator.generate_pin(size)

    save_pin(id, pin, state)
    {:reply, pin, state}
  end

  @doc false
  def handle_call({:validate, {id, pin}}, _from, state) do
    query = [
      {:==, :id, id},
      {:==, :pin, pin}
    ]

    {:reply,
     Memento.transaction(fn ->
       case Memento.Query.select(Pin, query) do
         [h | _t] ->
          Memento.Query.delete_record(h)
           true

         _ ->
           false
       end
     end), state}
  end

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
      "123456"
  """
  @spec store(any) :: String.t()
  def store(id) do
    ensure_db_up()
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
  @spec validate(any, String.t()) :: true | false
  def validate(id, pin) do
    ensure_db_up()
    GenServer.call(__MODULE__, {:validate, {id, pin}})
  end

  defp save_pin(id, pin, state) do
    validity = utc_now() |> add(get_pin_validity(state))

    Memento.transaction(fn ->
      Memento.Query.write(%Pin{id: id, pin: pin, valid_until: validity})
    end)
  end

  defp ensure_db_up() do
    Memento.Table.create(SmsUp.Pin.Db.Pin)
  end

  defp get_pin_validity(state) do
    Keyword.get(state, :pin_validity, 30) * @seconds_to_minute
  end

  defp get_pin_size(state) do
    Keyword.get(state, :pin_size, 6)
  end
end
