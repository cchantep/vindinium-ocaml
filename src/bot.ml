open Core.Std
open State

type direction = Stay | North | South | East | West

(** Direction companion *)
module Direction = struct
    (** Returns string representation of given direction. *)
    let to_string d : string = match d with
      | Stay -> "Stay" | North -> "North" | South -> "South" 
      | East -> "East" | West  -> "West"
  end

(** Bot: returns either a valid direction for next move, or error. *)
type bot = state -> (direction, string) Result.t
