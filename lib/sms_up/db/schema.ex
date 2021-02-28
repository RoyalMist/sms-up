defmodule SmsUp.Db.Pin do
  use Memento.Table, attributes: [:id, :pin, :valid_until], type: :set
end

defmodule SmsUp.Db.Number do
  use Memento.Table, attributes: [:number, :blocked_until], type: :set
end
