open Core.Std
open State
open Bot

module Random_bot : Bot = struct
    let next_move (st: state) : direction = Stay
  end
