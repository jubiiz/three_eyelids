open Shared.Packet;;
open Shared.Sequence_number;;

let the_sequence_number = create_sequence_number ();;

(* create the packet with message "hello" *)
let hello_packet = form_packet "hello" (the_sequence_number.get());;

(* check that the sequence number is correct, that the message length is 5, that the checksum value is 580*)
assert (hello_packet.seq_num = 0);;
assert (hello_packet.msg_length = 5);;
assert (hello_packet.checksum = 580);;

(* convert packet to bytes *)
let hello_packet_as_bytes = packet_as_bytes hello_packet;;

(* make sure that the bytes packet contains all the expected data *)
assert (Bytes.length hello_packet_as_bytes = 11);;

(* create the expected byte array *)
let expected_bytes_hello = Bytes.concat Bytes.empty [Bytes.of_string ("0"); Bytes.of_string("5"); Bytes.make 1 (Char.chr 0); Bytes.of_string("hello"); Bytes.of_string("580")];;

(* check that the bytes packet is the same as the expected bytes packet *)
assert (hello_packet_as_bytes = expected_bytes_hello);;

(* create bytes array that will be used to get the checksum value*)
let msg_and_header = add_seq_num_to_msg (Bytes.of_string "hello") 0;;

(* check that the sequence number was added appropriately to the front *)
assert (msg_and_header = Bytes.of_string "0hello");;

(* get the checksum of message=hello with sequence number 0*)
let checksum = get_checksum msg_and_header;;

(* check that the checksum value is correct *)
assert (checksum = 580);;