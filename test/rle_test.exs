defmodule RleTest do
  use ExUnit.Case
  doctest Rle
  import Rle

  test "encode and decode returns lists" do
    assert is_list(encode([?a, ?b, ?c, ?c ,?c]))
    assert is_list(decode([{101, ?d}, {269, ?c}]))
  end

  test "decoded data is the same after encoding" do
    data = [?a,?b, ?c, ?c, ?c, ?c, ?f, ?d, ?d, ?d]
    assert (encode(data) |> decode()) == data
  end

  test "encoded data is no longer then data" do
    data = [?a, ?b, ?c, ?d ,?f, ?a, ?a, ?b, ?b]
    assert length(encode(data)) <= length(data)
  end

  test "encode/decode raises FunctionClauseError for non-valid input" do
    assert_raise(FunctionClauseError,  fn -> encode(%{valid?: :invalid_input}) end)
    assert_raise(FunctionClauseError, fn -> decode(150.00) end)
  end
  test "encoded packable data is shorter then data" do
    data = [?a, ?a, ?a, ?b, ?c, ?b, ?b]
    assert length(encode(data)) < length(data)
  end

  # Equivalence Class Testing
  @_equivalence_class_testing """
  Encode/decode
    no packable
    packable
    empty list
    non_list
    1 item serie inside data
    2 same items serie inside data
    3 and more same items inside data
  """
  test "encode packable" do
    assert Rle.encode([?a, ?b, ?b, ?b, ?b, ?b, ?b, ?c, ?c, ?a, ?a, ?a, ?b]) == [?a, {6, ?b}, ?c, ?c, {3, ?a}, ?b]
  end

  test "endoded without packable" do
    data = [?a, %{hi: :pul}, "equivalence class testing", ?a, ?b, ?a, ?c, 1022, 10.3]
    encoded = encode(data)
    assert encoded == data
    assert length(encoded) == length(data)
  end

  test "encode works for empty list" do
    assert encode([]) == []
  end

  test "encode raise FunctionClause for non list argument" do
    assert_raise(FunctionClauseError, fn -> encode("invalid argument") end)
  end

  # same as encode
  test "decode" do
    assert Rle.decode([?b,{5, ?f}, ?c, ?d, ?d, {3, ?c}]) == [?b, ?f, ?f, ?f, ?f, ?f, ?c, ?d, ?d, ?c, ?c, ?c]
  end
end
