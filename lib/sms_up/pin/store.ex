defmodule SmsUp.Pin.Store do
  use GenServer
  require Logger
  alias SmsUp.Pin.Generator

  @moduledoc """
  This module stores random pin associated with an id to be checked later.
  Default validity is 10 minutes and is configurable.
  '''
  config :sms_up, :pin, 15
  '''
  """

  @minutes_to_milliseconds 60 * 1000

  @doc false
  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link do
    Logger.info("Starting the PIN Store")
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc false
  @spec init(any) :: {:ok, %{}}
  def init(_args) do
    {:ok, %{}}
  end

  @doc false
  def handle_call({:store, id}, _from, state) do
    pin = get_pin_size() |> Generator.generate_pin()
    {:reply, pin, state |> Map.put(id, pin)}
  end

  @doc false
  def handle_call({:validate, {id, pin}}, _from, state) do
    reply =
      case state[id] do
        {:ok, fetch_pin} when fetch_pin === pin -> {:ok, true}
        _ -> {:ok, false}
      end

    {:reply, reply, state |> Map.delete(id)}
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

  defp get_pin_validity do
    Application.get_env(:sms_up, :pin_validity, 10) * @minutes_to_milliseconds
  end

  defp get_pin_size do
    Application.get_env(:sms_up, :pin_size, 6)
  end
end
