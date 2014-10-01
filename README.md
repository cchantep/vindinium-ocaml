# Vinidium OCaml

OCaml starter pack for [Vinidium](http://vindinium.org/) challenge (inspired from the [Java starter pack](https://bitbucket.org/cchantep/vindinium-starter-java)).

## Build

*Prerequisites:*

- Frontend `ocamlfind`
- Compiler `ocamlopt` (tested with 4.02.x)
- Modules `core`, `yojson` and `ounit` (for testing)

A minimal build script is provided with `make.sh`:

```
vindinium-ocaml# ./make.sh
vindinium-ocaml# ./target/vinidium

vindinium-ocaml# ./make.sh test

vindinium-ocaml# ./make.sh clean
```

## Usage

**Tile:**

A tile is the place used by some game element (hero, tavern, ...) on the board at some coordinate (column, row).

Constants instances defined in `Board` module are `AirTile`, `FreeMineTile`, `TavernTile` and `WallTile`.

Tiles for heroes mines and heroes themselves can be created using constructors `HeroTile(hero_id)` and `MineTile(hero_id)`.

```ocaml
open Hero
open Board

let hero1Tile = HeroTile(FirstHero)
```

**Board:**

Board is a matrice of tiles, with number of column being same as number of row, aka `size` property of the `board` type.

```ocaml
open Board

(* Create initial board of size 4 with only air. *)
let init_board board = Board.make 4 in
let init_tile = Board.get init_board ~col:0 ~row:0 in (* tile 0,0: now air *)
let updated_board: board option = Board.set board ~col:0 ~row:0 TavernTile
```
