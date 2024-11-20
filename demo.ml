(* 



let%lwt _ = bind socket (ADDR_INET (server_address, server_port)) in
Lwt.return socket

is shorthand for

bind socket (ADDR_INET (server_address, server_port)) >>= fun () ->
Lwt.return socket


'a t -> ('a -> 'b t) -> 'b t



*)