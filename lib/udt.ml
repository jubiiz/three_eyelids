(* Unreliable Data Transfer (UDT) helper functions.

Relies on UDP protocol to send and receive data on a best effort basis.

Large parts of this code are based on the UDP server example from:
https://medium.com/@aryangodara_19887/udp-client-and-server-in-ocaml-e203116a997c
*)

type response = {
  len: int;  
  data: Bytes.t;
  sender_addr: Unix.sockaddr;
}
let server_port = 9000

let client_address = Unix.inet_addr_of_string @@ Sys.getenv "CLIENT_ADDRESS" 
let server_address = Unix.inet_addr_of_string @@ Sys.getenv "SERVER_ADDRESS" 

let get_server_socket (): Lwt_unix.file_descr Lwt.t = 
  let open Lwt_unix in
  let socket = socket PF_INET SOCK_DGRAM 0 in
  let%lwt _ = bind socket (ADDR_INET (server_address, server_port)) in
  Lwt.return socket

let get_client_socket () = 
  let open Lwt_unix in
  let socket = socket PF_INET SOCK_DGRAM 0 in
  Lwt.return socket


let recv (socket: Lwt_unix.file_descr) (timeout_seconds: float): response option = 
  (* Timeout of 0 means no timeout *)
  let buffer = Bytes.create 1024 in
  let recv' () = Lwt_unix.recvfrom socket buffer 0 1024 [] in
  let recv_promise = if timeout_seconds > 0.0 then Lwt_unix.with_timeout timeout_seconds recv' else recv'() in
  try 
    let (len, sender_addr) = Lwt_main.run recv_promise in
    Some {len=len; data=buffer; sender_addr=sender_addr}
  with Lwt_unix.Timeout -> None

let send (data: Bytes.t) (sending_socket: Lwt_unix.file_descr) (target_sockaddr: Unix.sockaddr): int = 
  Lwt_main.run @@
   Lwt_unix.sendto sending_socket data 0 (Bytes.length data) [] target_sockaddr 
