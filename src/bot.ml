open Core.Std
open Async.Std
open State
open Board

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

(** Is given tile a 'free' one (air, free mine or tavern). *)
let is_free (t:tile) : bool = 
  match t with AirTile | FreeMineTile | TavernTile -> true | _ -> false

(** Checks whether there is some optional tile, and if this tile is a free one. *)
let is_some_free (t: tile option) : bool = Option.exists t (fun _ -> true)
