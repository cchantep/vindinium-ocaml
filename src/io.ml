open Core.Std
open Async.Std
open Cohttp_async
open Cohttp_async.Response

(** Successful response to HTTP POST *)
type post_success = Response.t * string

(** HTTP success or error resulting from POST request *)
type post_result = (post_success, string) Result.t 

(** HTTP I/O related result *)
type 'a result = ('a, string) Result.t Deferred.t

(** Do an HTTP POST request to given [uri] with given parameters, and applies function [f] with HTTP result. *)
let with_post ?(retry:int=2) (uri:Uri.t) (params: (string * string) list) ~(f: post_success -> 'a result): 'a result =
  (* prepares request headers and body *)
  let headers = 
    Cohttp.Header. (* Prepare headers *)
    add_opt None "content-type" "application/x-www-form-urlencoded" in
  let params' = List.map ~f:(fun (k, v) -> (k, [v])) params in
  let rawbody = Uri.encoded_of_query params' in 
  let do_post : unit -> post_result Deferred.t = 
    (fun _ -> 
     Client.post uri ~headers ~body:(Body.of_string rawbody)
     >>= (fun (resp, body) -> 
          match resp.status with 
          | `OK -> Deferred.map 
                     (Body.to_string body) ~f:(fun bstr -> Ok((resp, bstr)))
          | e -> return (Error(Cohttp.Code.string_of_status e)))) in
  let rec run_post : (post_result * int) -> 'a result = 
    (* try until get HTTP success, or retry limit reached *)
    (function (* current HTTP result, remaining try *)
      | (Ok(res), _) -> f res (* HTTP success *)
      | (Error(msg), 0) -> return (Error msg) (* Error & can't try anymore *)
      | (_, remaini) -> (* otherwise try again *)
         (do_post ()) >>= (fun res -> run_post (res, (remaini-1)))) 
  in run_post (Error (sprintf "Fails to perform POST: %s" 
                              (Uri.to_string uri)), retry)
