open Core.Std
open Async.Std
open Cohttp_async
open Cohttp_async.Response

(** Body of successful response to HTTP POST *)
type post_success = string

(** HTTP success or error resulting from POST request *)
type post_result = (post_success, string) Result.t 

(** Do a deferred HTTP POST request to given [uri] with given parameters. *)
let with_post ?(retry:int=2) (uri:Uri.t) (params: (string * string) list): post_result Deferred.t =
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
          | `OK -> (Body.to_string body) >>| (fun bstr -> Ok bstr)
          | e -> 
             Body.to_string body >>| (
              fun bstr -> 
              let status = Cohttp.Code.string_of_status e in
              Error(sprintf "%s:\r\n\r\n%s" status bstr)))) in
  let rec run_post : (post_result * int) -> post_result Deferred.t = 
    (* try until get HTTP success, or retry limit reached *)
    (function (* current HTTP result, remaining try *)
      | (Ok(res), _) -> return (Ok res) (* HTTP success *)
      | (Error(msg), 0) -> return (Error msg) (* Error & can't try anymore *)
      | (_, remaini) -> (* otherwise try again *)
         (do_post ()) >>= (fun res -> run_post (res, (remaini-1)))) 
  in run_post (Error (sprintf "Fails to perform POST: %s" 
                              (Uri.to_string uri)), retry)
