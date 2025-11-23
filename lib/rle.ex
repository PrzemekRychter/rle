defmodule Rle do
  @moduledoc """
  Documentation for `Rle`.
  """

  def encode(list, acc \\ [])
  def encode([], []), do: []
  def encode([h | t], []), do: encode(t, [h])
  def encode([h | t], [{x, h} | r]), do: encode(t, [{x + 1, h} | r])
  def encode([h | t], [h, h | r]), do: encode(t, [{3, h} | r])
  def encode([h | t], [h | r]), do: encode(t, [h, h | r])
  def encode([h | t], [_x | _r] = acc), do: encode(t, [h | acc])
  def encode([], acc), do: Enum.reverse(acc)

  def decode(list, acc \\ [])
  def decode([], []), do: []
  def decode([{0, _h} | t], acc), do: decode(t, acc)
  def decode([{x, h} | t], acc), do: decode([{x - 1, h} | t], [h | acc])
  def decode([h | t], acc), do: decode(t, [h | acc])
  def decode([], acc), do: Enum.reverse(acc)

end
