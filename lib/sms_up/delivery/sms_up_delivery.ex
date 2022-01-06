defmodule SmsUp.Delivery.SmsUpDelivery do
  require Logger
  @behaviour SmsUp.Delivery
  @supported_params [:pushtype, :delay, :sender, :gsmsmsid]
  @error_status %{
    "-1" => {:error, "Authentication error"},
    "-2" => {:error, "XML error"},
    "-3" => {:error, "Not enough credits"},
    "-4" => {:error, "Incorrect date delay"},
    "-5" => {:error, "Contact list error"},
    "-6" => {:error, "JSON error"},
    "-7" => {:error, "Data error"},
    "-8" => {:error, "Your campaign is currently under moderation"},
    "-99" => {:error, "Unknown error"}
  }

  @moduledoc """
  Deliver the sms throught SMS Up plateform with your API key.
  """

  @doc """
  Deliver the SMS to the real API.
  Provide a valid international number, the body of the message and
  a optional list of options:
  * pushtype: The push type (alert or marketing)
  * delay: Sending date Y-m-d H:i:s
  * sender: Allows you to customize the sender
  * gsmsmsid: An id of your choice to link it to its delivery report

  Can return the following errors from SMS UP:
  * Authentication error
  * XML error
  * Not enough credits
  * Incorrect date delay
  * Contact list error
  * JSON error
  * Data error
  * Your campaign is currently under moderation
  * Unknown error

  Do not forget to indicate your API key in config:
  `
  config :sms_up, api_key: MY_KEY
  `

  ## Examples

      iex> SmsUp.Delivery.SmsUpDelivery.deliver("+41765556677", "Hello")
      {:ok, %{to: "+41765556677", body: "Hello", options: []}}

      iex> SmsUp.Delivery.SmsUpDelivery.deliver("+41765556677", "Hello", [sender: "Company"])
      {:ok, %{to: "+41765556677", body: "Hello", options: [sender: "Company"]}}
  """

  @impl true
  @spec deliver(String.t(), String.t(), Keyword.t()) ::
          {:ok, %{body: String.t(), to: String.t(), options: Keyword.t()}} | {:error, String.t()}
  def deliver(to, body, options) when is_binary(to) and is_binary(body) do
    case HTTPoison.get(
           make_uri(to, body, options),
           Authorization: "Bearer #{get_api_key()}",
           Accept: "Application/json; Charset=utf-8"
         ) do
      {:ok, res} ->
        ["{\"status\":" <> code | _] = String.split(res.body, ",")

        case code do
          "1" ->
            {:ok, %{to: to, body: body, options: options}}

          status ->
            Logger.error(res.body)
            @error_status[status]
        end

      error ->
        error
    end
  end

  @doc false
  @spec make_uri(String.t(), String.t(), Keyword.t()) :: binary
  def make_uri(to, body, options \\ []) do
    uri = "https://api.smsup.ch/send?text=#{body}&to=#{to}"

    options =
      for {k, v} <- options do
        if Enum.member?(@supported_params, k) do
          "&#{k}=#{v}"
        else
          ""
        end
      end
      |> Enum.reduce("", &(&2 <> &1))

    URI.encode(uri <> options)
  end

  defp get_api_key do
    Application.get_env(
      :sms_up,
      :api_key,
      "SET_ME"
    )
  end
end
