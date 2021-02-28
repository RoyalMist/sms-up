defmodule SmsUp.Db.Pin do
  use Memento.Table, attributes: [:id, :pin, :valid_until], type: :set
end
