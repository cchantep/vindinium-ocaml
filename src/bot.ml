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

(** Bot contract *)
module type Bot = sig
    (** Returns either a valid direction for next move, or error. *)
    val next_move : state -> (direction, string) Result.t
  end
