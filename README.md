SmsUp
========
[![Hex.pm](https://img.shields.io/hexpm/v/sms_up.svg)](https://hex.pm/packages/sms_up)

Use to send sms and validate phone numbers.

[SmsUP](https://smsup.ch) is a Swiss platform for sending sms.
This package permits to send sms and generate some One Time Password stored in memory for a given time.

## Installation

The package can be installed by adding `sms_up` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sms_up, "~> x.x.x"}
  ]
end
```

## Local development setup:

* Install [`Homebrew`](https://brew.sh)
* Run `brew bundle`
* Run `mise i`
* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
