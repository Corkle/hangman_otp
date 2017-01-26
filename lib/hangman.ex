defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """

  @doc """
  Spawns a new GameSession and returns `{:ok, state}` where
  `state` is the initial GameSession state.
  If a GameSession is already spawned under the given
  `id`, the current state of that GameSession is returned.
  """
  def connect(id) do
    with {:ok, _pid} <- Hangman.GameSupervisor.spawn_session(id),
         {:ok, state} <- get(id) do
           {:ok, state}
    else
      {:error, :failed_start} ->
        {:error, "Failed to start GameSession"}
      _ ->
        {:error, "Could not connect GameSession"}
    end
  end
  
  @doc """
  Returns current state of the GameSession of assoicated
  `id`.
  """
  def get(id),
    do: try_call(id, :get_session)

  @doc """
  Checks if the given `letter` is found anywhere in the
  `secret` GameSession associated with `id`. `letter` is
  expected to be an alpha character.

  Returns `{:error, message}` if an invalid character is
  provided as a guess.
  Returns `{:ok, reply}` if a valid guess is made.

  `reply` will be one of three outcomes:
  * `{:correct, state}` - The guess was correct and
  progress has been made on solving the puzzle.
  * `{:incorrect, state}` - The guess was incorrect and
  the `failures_remaining` count has been decremented.
  * `{:game_over, state}` - The guess result has caused
  either the win or lose condition to be met. The
  GameSession process has terminated and `state` is the
  final game state including the hidden `secret`.
  `state.status` will either be `:won` or `:lost`
  respective to the outcome of the game.
  """
  def guess(id, letter) when is_binary(letter) and byte_size(letter) == 1 do
    guess = String.downcase(letter)
    make_guess(id, guess, guess =~ ~r/[a-z]/)
  end

  defp make_guess(id, letter, true),
    do: try_call(id, {:make_guess, letter})
  defp make_guess(_, _, _),
    do: {:error, :invalid_character}

  defp try_call(id, msg),
    do: call_pid(GenServer.whereis({:global, {:session, id}}), msg)

  defp call_pid(nil, _),
    do: {:error, :not_spawned}
  defp call_pid(pid, msg),
    do: GenServer.call(pid, msg)
end
