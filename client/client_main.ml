open Shared;;

let the_sequence_number = Sequence_number.create_sequence_number ();;

let rdt_send (msg: string): unit =
    let seq_num = the_sequence_number.get () in
    let packet = Packet.create seq_num msg in
    let packet_bytes = Packet.bytes_of_packet packet in
    print_endline @@ "Sending message: " ^ (Bytes.to_string packet_bytes) ^ " with sequence number: " ^ (string_of_int seq_num);
    the_sequence_number.increment ()
;;

let rec client () = 
  let input = read_line () in
  let _ = rdt_send input in
  client ()
;;

print_endline "Hello, World, this is client running!";;
let () = client();;
