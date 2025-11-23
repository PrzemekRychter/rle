defmodule Rle do
  @moduledoc """
  Documentation for `Rle`.
  """

  def encode(original) when is_binary(original) do
    String.graphemes(original)
    |> Rle.encode()
    |> then(&{:string, &1})
  end

  def decode({:string, encoded}) do
    decode(encoded)
    |> to_string()
  end

  def encode(original, encoded \\ [])
  def encode([value | original], [{amount, value} | encoded]), do: encode(original, [{amount + 1, value} | encoded])
  def encode([value | original], [value, value | encoded]), do: encode(original, [{3, value} | encoded])
  def encode([value | original], encoded), do: encode(original, [value | encoded])
  def encode([], acc), do: Enum.reverse(acc)

  def decode(encoded) when is_list(encoded) do
    Enum.reduce(encoded, [], fn
      {amount, elem}, acc ->
        decoded_value = for _ <- 1..amount, do: elem
        decoded_value ++ acc
      elem, acc ->
        [elem | acc]
    end)
    |> Enum.reverse()
  end
end
