open Core.Std
open Async.Std

open Board
open Bot
open Game
open Hero
open State

let strategy : (board -> int -> int -> direction option) list = [
    (fun b c r -> (* Not on first row and cell up is free *)
     if (r > 0 && is_some_free (b @ (c, r-1))) then Some(North) else None);

    (fun b c r -> (* Not on last row and cell down is free *)
     let down = r + 1 in
     if (down < b.size && is_some_free (b @ (c, down))) 
     then Some(South) else None);

    (fun b c r -> (* Not on first column and left cell is free *)
     if (c > 0 && is_some_free (b @ (c-1, r))) then Some(West) else None);

    (fun b c r -> (* Not on last column and right cell is free *)
     let right = c + 1 in
     if (right < b.size && is_some_free (b @ (right, r))) 
     then Some(East) else None)
  ]

(** Bot with a dumb/random strategy to find next direction. *)
let instance (st: state) : (direction, string) Result.t = 
  let board = st.game.board in
  let _ = board @ (0, 0) in
  match Option.map ~f:(fun h -> h.position) (State.hero st) with
  | Some(pos) -> 
     (if (pos ^ board) then 
        (let (c, r) = pos in 
         let possible : direction list = 
           List.fold_left 
             strategy ~init:[] 
             ~f:(fun l f -> 
                 let d = f board c r in 
                 match d with Some(dir) -> dir :: l | _ -> l) in
         let randi = Random.int (List.length possible) in
         match List.nth possible randi with
         | Some(dir) -> Ok dir
         | _ -> Error "Fail to select a random direction"
        )
      else Error "Hero is off the board"
     )
  | _ -> Error "Fails to locate played hero"
