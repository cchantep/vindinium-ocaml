open Core.Std
open State

type direction = Stay | North | East | West

(** Direction companion *)
module Direction = struct
    (** Returns string representation of given direction. *)
    let to_string d : string = match d with
      | Stay -> "Stay" | North -> "North" 
      | East -> "East" | West  -> "West"
  end

(** Bot contract *)
module type Bot = sig
    (** Returns direction of next move. *)
    val next_move : state -> direction
  end
