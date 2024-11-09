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

let sender_address = Unix.inet_addr_of_string ""
let receiver_address = Unix.inet_addr_of_string ""
let server_port = 9000

let get_receiver_socket (): Lwt_unix.file_descr Lwt.t = 
  let open Lwt_unix in
  let socket = socket PF_INET SOCK_DGRAM 0 in
  let%lwt _ = bind socket (ADDR_INET (sender_address, server_port)) in
  Lwt.return socket
let server_socket = Lwt_main.run @@ get_receiver_socket ()

let get_sender_socket () = 
  let open Lwt_unix in
  let socket = socket PF_INET SOCK_DGRAM 0 in
  Lwt.return socket

let client_socket = Lwt_main.run @@ get_sender_socket ()

let recv (socket: Lwt_unix.file_descr): response = 
  let buffer = Bytes.create 1024 in
  let (len, sender_addr) = Lwt_main.run @@ Lwt_unix.recvfrom socket buffer 0 1024 [] in
  {len=len; data=buffer; sender_addr=sender_addr}

let send (data: Bytes.t) (len: int) (socket: Lwt_unix.file_descr): int = 
  Lwt_main.run @@
   Lwt_unix.sendto socket data 0 len [] (Unix.ADDR_INET (receiver_address, server_port))
  


