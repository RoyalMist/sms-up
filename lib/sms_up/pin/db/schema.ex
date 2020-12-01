use Amnesia

defdatabase Database do
  @moduledoc false
  deftable Pin, [:id, :pin, :valid_until], type: :set do
    @moduledoc false
    @type t :: %Pin{id: String.t(), pin: String.t(), valid_until: NaiveDateTime.t()}
  end
end
