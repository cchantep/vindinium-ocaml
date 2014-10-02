open Core.Std
open Http_client.Convenience

let foo = http_post_message "http://localhost" (("name", "value") :: [])
