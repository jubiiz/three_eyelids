open Shared.Parse_packet;;

(* test getting the msg_length from a bytes *)
let five_as_bytes = Bytes.of_string "5";;
let msg_length = get_msg_length five_as_bytes;;

assert (msg_length = 5);;

(* test unpacking a packet *)
(* create the mock Bytes that was received*)
let expected_bytes_hello = Bytes.concat Bytes.empty [Bytes.of_string ("0"); Bytes.of_string("5"); Bytes.make 1 (Char.chr 0); Bytes.of_string("hello"); Bytes.of_string("633")];;

(* call the unpack function*)
let unpacked_response = unpack expected_bytes_hello;;

(* since unpack returns a packet option, need to get the value from the option*)
let bytes_value = Option.get unpacked_response;;

(* assert the parsed values are what is expected*)
assert (bytes_value.seq_num = 0);;
assert (bytes_value.msg_length = 5);;
assert (bytes_value.checksum = 633);;
assert (Bytes.to_string bytes_value.data = "hello");;

(* test comparing checksums *)
let checked = compare_checksums bytes_value;;

assert (checked);;