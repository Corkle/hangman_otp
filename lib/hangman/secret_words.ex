defmodule Hangman.SecretWords do
  @words_path Application.get_env(:hangman, :words_path)
  def start_link,
    do: Agent.start_link(&import_words/0, name: __MODULE__)

  def get_random do
    Agent.get(__MODULE__, &random_word/1) 
  end

  defp import_words do
    File.stream!(@words_path)
    |> Enum.map(&(String.trim(&1)))
    |> Enum.to_list
  end

  defp random_word(list),
    do: Enum.random(list) 
end
