defmodule Authable.Utils.CryptTest do
  use ExUnit.Case
  import Authable.Utils.Crypt

  test "test match_password & salt_password" do
    password = "12345678"
    salted_password = salt_password(password)
    match_password(password, salted_password)
  end

  test "test generate_token, generates random str" do
    assert generate_token() != generate_token()
  end
end
