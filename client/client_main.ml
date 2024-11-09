let the_sequence_number = Shared.Sequence_number.create_sequence_number ();;

(*
type checksum = int;;

type packet = {
  seq_num: int;
  data: string;
  checksum: int;
}

let get_checksum packet = 
  magic

let form_packet input = 
  let seq_num = the_sequence_number.get () in
  (seq_num, input)


let binary_of_packet = 
  something somethine

*)
open Shared


let rdt_send (msg: string): unit = 
    let seq_num = the_sequence_number.get () in
    (* let a_request_packet = form_packet input in*)
    (*  *)
    let _ = print_endline ("Sending message: " ^ msg ^ " with sequence number: " ^ string_of_int seq_num) in
    let target_sockaddr = (Unix.ADDR_INET (Udt.server_address, Udt.server_port)) in
    let _ = Udt.send (Bytes.of_string msg) (String.length msg) Udt.client_socket target_sockaddr in
    the_sequence_number.increment ()
    
	(* TODO IMPLEMENT *)
;;

let rec client () = 
  let input = read_line () in
  let _ = rdt_send input in
  client ()
;;


print_endline "Hello, World, this is client running!";;
let () = client();;
