open Core.Std
open Async.Std

open Io
open Json
open Bot
open Game
open State

(* How many times to retry to communicate with server in case of error. *)
let retry : int = 3

(* Base URL to default server. *)
let default_server = "http://vindinium.org/"

(* Set bot to be used. Replace [Random_bot.instance] by yours. *)
let automatic_bot : bot = 
  let open Random_bot in Random_bot.instance

let run ~(mode:string) ~(key:string) ~(limit:int) ~(server:string) ~(bot:bot) : unit Deferred.t =
  (* DEBUG: let _ = printf "\r\n  [CONFIGURED] mode = '%s', private key = '%s', limit = %i, server = '%s'\r\n\r\n" mode key limit server in *)
  let ini_params = ("key", key) :: [] in
  let mode_params = match mode with 
    | "training" -> ("turns", string_of_int limit) :: ini_params 
    | _ (* actually arena *) -> ini_params in
  let url = 
    let len = String.length server in
    let l = (String.sub server ~pos:(len-1) ~len:1) in
    let s = (match l with
             | "/" -> (* normalize without ending / *)
                String.sub server ~pos:0 ~len:(len-1)
             | _ -> server) in
    Uri.of_string (sprintf "%s/api/%s" s mode) in
  let open Formatter in
  let rec play : state -> unit Deferred.t = 
    (fun current ->
     (printf "%s" (string_of_state current));
     if (current.game.finished) then return (printf "Game is over\r\n")
     else 
       match (bot current) with
       | Error(msg) -> return (printf "Fails to get next direction: %s\r\n" msg)
       | Ok(dir) ->
          let play_params = ("dir", Direction.to_string dir) :: ini_params in
          let play_url = Uri.of_string current.play_url in
          Io.with_post play_url play_params 
          >>= (function 
                | Error(msg) -> return (printf "Fails to play: %s\n" msg)
                | Ok(json) -> 
                   match (parse_state json) with
                   | Error(msg) -> 
                      return (printf "Fails to parse state: %s\n" msg)
                   | Ok(state) -> play state)
    ) in
    Io.with_post url mode_params 
    >>= (function 
          | Error(msg) -> 
             return (printf "Fails to get initial state: %s\r\n" msg)
          | Ok(json) -> 
             match (parse_state json) with
             | Error(msg) -> 
                return (printf "Fails to parse initial state: %s\r\n" msg)
             | Ok(state) -> play state)
          
let () = 
  let _mode : string -> (string, string) Result.t = 
    (fun s ->
     match s 
     with "arena" -> Ok "arena" | "training" -> Ok "training"
          | _ -> Error (sprintf "Mode must be 'arena' or 'training': %s" s)) in
  let positive : int -> (int, string) Result.t = 
    (fun i ->
     if (i <= 0) then Error (sprintf "Not a positive integer (> 0): %i\n" i)
     else Ok i) in
  let _uri : string -> (Uri.t, string) Result.t =
    (fun u -> try (Ok (Uri.of_string u)) 
              with _ -> Error (sprintf "Invalid server URL: %s" u)) in
  let _err : string -> int -> unit -> unit Deferred.t = 
    (fun msg code -> 
     let _ = (printf "\r\n  [ERROR] %s\r\n\r\n" msg) in 
     let _ = (exit code) in (fun _ -> Deferred.never ())) in
  Command.async_basic
    ~summary:"Start Vindinium client"
    Command.Spec.(
      empty
      +> flag "-mode" (required string) 
              ~doc:" Game mode ('arena' or 'training')"
      +> flag "-key" (required string) ~doc: " Private key"
      +> flag "-limit" (optional_with_default 10 int) 
              ~doc:" Number of turn to play (only for training, default: 10)"
      +> flag "-server" (optional_with_default default_server string)
              ~doc:(sprintf " Base URL to server (default: %s)" default_server)
      +> flag "-bot" no_arg ~doc:" If present, will use automatic bot"
    )
    (fun m key l server auto ->
     let m' = _mode m in
     let l' = positive l in
     let s' = _uri server in
     match (m', l', s') with 
     | (Error(msg), _, _) -> _err msg 1
     | (_, Error(msg), _) -> _err msg 2
     | (_, _, Error(msg)) -> _err msg 3
     | (Ok(mode), Ok(limit), Ok(_)) -> 
        (fun _ -> run ~mode ~key ~limit ~server ~bot:automatic_bot)
    )
  |> Command.run
