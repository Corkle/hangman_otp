# Hangman

An OTP Application to play games of Hangman

## Setup 
*Note*: Make sure you have [Elixir 1.4](http://elixir-lang.org/install.html) or greater installed

```sh
  git clone https://github.com/Corkle/hangman_otp.git
  cd hangman_otp
  iex -S mix
```

## Usage

```elixir
iex> Hangman.connect("MY_ID")
{:ok,
 %{failures_remaining: 10, guessed: [], id: "MY_ID",
   puzzle: ["_", "_", "_", "_", " ", "_", "_", " ", "_", "_", " ", "_", "_",
    "_", "_", "_", "_", "!"], status: :new_game}}
iex> Hangman.guess("MY_ID", "e")
{:ok,
 {:correct,
  %{failures_remaining: 10, guessed: ["e"], id: "MY_ID",
    puzzle: ["_", "_", "_", "_", " ", "_", "_", " ", "_", "_", " ", "_", "e",
     "_", "_", "e", "_", "!"], status: :in_progress}}}
iex> Hangman.guess("MY_ID", "x")
{:ok,
 {:incorrect,
  %{failures_remaining: 9, guessed: ["x", "e"], id: "MY_ID",
    puzzle: ["_", "_", "_", "_", " ", "_", "_", " ", "_", "_", " ", "_", "e",
     "_", "_", "e", "_", "!"], status: :in_progress}}}
```


