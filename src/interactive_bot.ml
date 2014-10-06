open Core.Std
open Bot
open State

let instance (st: state) : (direction, string) Result.t = 
  (printf "Where do you want to go? _N_orth, _S_outh, _W_est, _E_ast\r\n");
  match String.to_list (String.lowercase (input_line stdin)) with
  | 'n' :: _ -> Ok North | 's' :: _ -> Ok South
  | 'w' :: _ -> Ok West  | 'e' :: _ -> Ok East
  | _ -> (printf "Unsupported direction, will stay\r\n"); Ok Stay
  
  
