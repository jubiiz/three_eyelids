open Shared.Create_packet;;
open Shared.Parse_packet;;

let the_sequence_number = Shared.Sequence_number.create_sequence_number ();;

let rdt_send (msg: string): unit =
    let seq_num = the_sequence_number.get () in

    let packet_to_send = form_packet msg seq_num in
    let packet_as_bytes = packet_as_bytes packet_to_send in

    (* this line just to make sure packet is correct *)
    let _ = print_endline (Bytes.to_string packet_as_bytes) in
    let _ = print_endline (Bytes.to_string((Bytes.of_string "hello"))) in
let _ = print_endline (string_of_int (Bytes.length (Bytes.of_string "11"))) in
    let _ = print_endline ("Sending message: " ^ msg ^ " with sequence number: " ^ string_of_int seq_num) in

    let expected_bytes_hello = Bytes.concat Bytes.empty [Bytes.of_string ("0"); Bytes.of_string("5"); Bytes.make 1 (Char.chr 0); Bytes.of_string("hello"); Bytes.of_string("580")]in

    let split = (Bytes.split_on_char (Char.chr 0) expected_bytes_hello) in
    let _ = print_endline (Bytes.to_string (List.nth split 0)) in
    let _ = print_endline ("-------------Result----------------") in
    let unpacked_response = unpack packet_as_bytes in
    let _ = print_endline ("MSG: " ^ Bytes.to_string unpacked_response.data) in
    let _ = print_endline ("SEQ_NUM: " ^ string_of_int unpacked_response.seq_num) in
    let _ = print_endline ("CHECKSUM: " ^ string_of_int unpacked_response.checksum) in

    the_sequence_number.increment ()
;;

let rec client () = 
  let input = read_line () in
  let _ = rdt_send input in
  client ()
;;


print_endline "Hello, World, this is client running!";;
let () = client();;