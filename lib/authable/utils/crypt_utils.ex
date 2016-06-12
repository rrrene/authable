defmodule Authable.CryptUtils do
  @moduledoc """
  Crypt utilities
  """

  alias Comeonin.Bcrypt

  def match_password(password, crypted_password) do
    Bcrypt.checkpw(password, crypted_password)
  end

  def salt_password(password) do
    Bcrypt.hashpwsalt(password)
  end

  def generate_token do
    SecureRandom.urlsafe_base64
  end
end
