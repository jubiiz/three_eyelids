open Shared;;

let the_sequence_number = Sequence_number.create_sequence_number ();;
let client_socket = Lwt_main.run @@ Udt.get_client_socket ();;
let server_sockaddr = Unix.ADDR_INET (Udt.server_address, Udt.server_port);;

let rdt_send (msg: string): unit =
    let seq_num = the_sequence_number.get () in
    let packet = Packet.create seq_num msg in
    let packet_bytes = Packet.bytes_of_packet packet in
    print_endline @@ "Sending message: " ^ msg ^ " with sequence number: " ^ (string_of_int seq_num);
    let _ = Udt.send packet_bytes client_socket server_sockaddr in
    the_sequence_number.increment ()
;;

let rec client () = 
  let input = read_line () in
  let _ = rdt_send input in
  client ()
;;

print_endline "Hello, World, this is client running!";;
let () = client();;
