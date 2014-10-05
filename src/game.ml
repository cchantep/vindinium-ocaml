open Core.Std
open Hero
open Board

type game = {
    id       : string;    (* Game ID *)
    turn     : int;       (* Count of passed turn *)
    max_turn : int;       (* Max value for `turn` *)
    finished : bool;      (* Is game finished? *)
    heroes   : hero list; (* Game heroes: players *)
    board    : board      (* Associated board *)
  }
    


