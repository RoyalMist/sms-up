use Amnesia

defdatabase Database do
  deftable Pin, [:id, :pin, :valid_until], type: :set do
    @type t :: %Pin{id: String.t(), pin: String.t(), valid_until: NaiveDateTime.t()}
  end
end
