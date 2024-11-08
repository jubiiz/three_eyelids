open Shared.Parse_packet;;

(* test getting the msg_length from a bytes *)
let five_as_bytes = Bytes.of_string "5";;
let msg_length = get_msg_length five_as_bytes;;

assert (msg_length = 5);;

(* test unpacking a packet *)
let expected_bytes_hello = Bytes.concat Bytes.empty [Bytes.of_string ("0"); Bytes.of_string("5"); Bytes.make 1 (Char.chr 0); Bytes.of_string("hello"); Bytes.of_string("580")];;

let unpacked_response = unpack expected_bytes_hello;;

assert (unpacked_response.seq_num = 0);;
assert (unpacked_response.msg_length = 5);;
assert (unpacked_response.checksum = 580);;
assert (Bytes.to_string unpacked_response.data = "hello");;