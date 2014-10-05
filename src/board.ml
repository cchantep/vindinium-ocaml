open Core.Std
open Hero

(** Board tiles *)
type tile =
  AirTile | FreeMineTile | TavernTile | WoodTile 
  | HeroTile of hero_id
  | MineTile of hero_id

(** Tile companion *)
module Tile = struct
    (** Creates tile instance from given character list. *)
    let from_chars (cs: char list) : (tile, string) Result.t =
      let open Result.Monad_infix in
      match cs with
      | ' ' :: ' ' :: [] -> Ok AirTile
      | '$' :: '-' :: [] -> Ok FreeMineTile
      | '[' :: ']' :: [] -> Ok TavernTile
      | '#' :: '#' :: [] -> Ok WoodTile
      | '@' :: h   :: [] -> HeroId.from_char h >>| fun id -> HeroTile(id)
      | '$' :: h   :: [] -> HeroId.from_char h >>| fun id -> MineTile(id)
      | _ -> Error "Invalid tile string"

    (** Creates tile instance corresponding to string. *)
    let make (s:string) : (tile, string) Result.t = 
      Result.map_error 
        (from_chars (String.to_list s))
        ~f:(fun _ -> sprintf "Invalid tile string: %s" s)

    (** Returns string representation of given tile. *)
    let to_string (t:tile) : string = match t with
      | AirTile    -> "  " | FreeMineTile -> "$-" 
      | TavernTile -> "[]" | WoodTile     -> "##"
      | HeroTile(h) -> sprintf "@%i" (HeroId.to_int h)
      | MineTile(h) -> sprintf "$%i" (HeroId.to_int h)
  end

(** Board itself *)
type board = {
    size  : int;
    tiles : tile list(*y*) list(*x*); (* Tiles matrix *)
  }

(** Board companion *)
module Board = struct
    (**
     * Creates a board of 'n' (size) rows of 'n' columns, 
     * filled only with air. 
     *)
    let make (size:int) : board = 
      let airRow = Array.to_list (Array.create size AirTile) in
      let tiles = Array.to_list (Array.create size airRow) in
      { size; tiles }

    (** Returns specified tile, if coordinates are on the given board. *)
    let get (b:board) ~(col:int) ~(row:int) : tile option = 
      if (row < 0 || row >= b.size || col < 0 || col >= b.size) then None
      else match List.nth b.tiles col with
           | Some(c) -> List.nth c row
           | _ -> None

    (** Checks whether tile specified by column and row is on given board. *)
    let is_on (b:board) ~(col:int) ~(row:int) : bool = 
      if (row >= 0 && row < b.size && col >= 0 && col < b.size) 
      then true else false

    (** 
     * Returns new some new board with tile set if coordinates are valid,
     * or none if not (board considered unchanged).
     *)
    let set (b:board) ~(col:int) ~(row:int) (t:tile) : board option = 
      if (is_on b ~col:col ~row:row) then
        let (_, tiles) = 
          List.fold_left 
            b.tiles ~init:(0, [])
            ~f:(fun cst r -> 
                let (i, cs) = cst in
                let rcopy = 
                  if (phys_equal i col) then
                    let (_, rup) = 
                      List.fold_left 
                        r ~init:(0, [])
                        ~f:(fun rst tile ->
                            let (j, ts) = rst in
                               let tcopy = 
                                 if (phys_equal j row) then t else tile in
                               (j+1, tcopy :: ts)) in List.rev rup 
                  else r
                in (i+1, rcopy :: cs)) in
        let copy = { size = b.size; tiles = List.rev tiles } 
        in Some(copy)
      else None

  end

(** Convenient infix operator to get specified tile on given board. *)
let (@) (b:board) (coords: int * int) : tile option = 
  let (c, r) = coords in Board.get b ~col:c ~row:r

(** Convenient infox operator to check whether coordinates are on board. *)
let (^) (coords: int * int) (b:board) : bool = 
  let (c, r) = coords in Board.is_on b ~col:c ~row:r
