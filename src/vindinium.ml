open Core.Std

open Hero

let usage = printf "\r\n  Usage: vindinium mode priv_key play_num server\r\n\r\n\tmode = 'arena' | 'training'\r\n\tpriv_key = Client private key\r\n\tplay_num = Number of turn to play\r\n\tserver = Server base address (host or IP, e.g. 'http://vindinium.org')\r\n\r\n"

let _positive (s:string) : (int, string) Result.t = 
  try (let i = int_of_string s in 
       if (i <= 0) then Error (sprintf "Not a positive integer (> 0): %i\n" i)
       else Ok i)
  with _ -> 
    Error (sprintf "Fails to parse argument as positive integer (> 0): %s\n" s)

let _mode (s:string) : (string, string) Result.t =
  match s with "arena" -> Ok "arena" | "training" -> Ok "training"
               | _ -> Error (sprintf "Mode must be 'arena' or 'training': %s" s)

(* How many times to retry to communicate with server in case of error: *)
let retry : int = 3

let () =  
  if (Array.length Sys.argv < 5) then usage 
  else 
    let m = _mode Sys.argv.(1) in (* "arena" or "training" *)
    let priv_key = Sys.argv.(2) in 
    let num_to_play = _positive Sys.argv.(3) in (* integer > 0 *)
    let server_adr = Sys.argv.(4) in 
    match (m, num_to_play) with 
    | (Error(msg), _) -> 
       printf "\r\n  [ERROR] Fails to parse mode argument: %s\r\n\r\n" msg
    | (_, Error(msg)) -> 
       printf "\r\n  [ERROR] Fails to parse play_num argument: %s\r\n\r\n" msg
    | (Ok(mode), Ok(to_play)) -> 
       let _ = printf "\r\n  [CONFIGURED] mode = '%s', private key = '%s', play_num = %i, server = '%s'\r\n\r\n" mode priv_key to_play server_adr in
       let ini_params = ("key", priv_key) :: [] in
       let url = sprintf "%s/api/%s" server_adr mode in
       printf "url = %s" url
