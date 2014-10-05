open Core.Std
open Async.Std

open Io

(* How many times to retry to communicate with server in case of error. *)
let retry : int = 3

(* Base URL to default server. *)
let default_server = "http://vindinium.org/api/"

let run ~(mode:string) ~(key:string) ~(limit:int) ~(server:string) =
  let _ = printf "\r\n  [CONFIGURED] mode = '%s', private key = '%s', limit = %i, server = '%s'\r\n\r\n" mode key limit server in
  let ini_params = ("key", key) :: [] in
  let url = Uri.of_string (sprintf "%s/api/%s" server mode) in
  let _ = printf "uri = %s\n" (sprintf "%s/api/%s" server mode) in
  let x = 
    Io.with_post 
      url ini_params 
      ~f:(function (resp, body) -> return (Ok (resp, body))) in
  let _ = 
    Deferred.map 
      x ~f:(function 
               Ok((_, _)) -> (printf "Ok\n"); (exit 0)
             | Error(msg) -> (printf "Fails to play: %s\r\n" msg); (exit 4)) in
              
  Deferred.never ()

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
              ~doc:" Number of turn to play (default: 10)"
      +> flag "-server" (optional_with_default default_server string)
              ~doc:(sprintf " Base URL to server (default: %s)" default_server)
    )
    (fun m key l server ->
     let m' = _mode m in
     let l' = positive l in
     let s' = _uri server in
     match (m', l', s') with 
     | (Error(msg), _, _) -> _err msg 1
     | (_, Error(msg), _) -> _err msg 2
     | (_, _, Error(msg)) -> _err msg 3
     | (Ok(mode), Ok(limit), Ok(_)) -> 
        (fun _ -> run ~mode ~key ~limit ~server)
    )
  |> Command.run
