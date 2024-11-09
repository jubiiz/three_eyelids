open Shared;;

let the_sequence_number = Sequence_number.create_sequence_number ();;

let packet = Packet.create (the_sequence_number.get()) "hello";;

(* Assert packet correctly created *) 
assert (packet.seq_num = 0);;
assert (packet.data_length = 5);;
(* (seq_num (0) + data_length (5) + sum_of_bytes_in_hello (532)) % 256 = 25*)
assert (packet.checksum = 25);; 

let packet_bytes = Packet.bytes_of_packet packet;;

let expected_bytes = 
  let data = Bytes.of_string "hello" in
  let total_length = 3 + Bytes.length data in
  let expected_bytes = Bytes.create total_length in
  Bytes.set_uint8 expected_bytes 0 0;
  Bytes.set_uint8 expected_bytes 1 5;
  Bytes.set_uint8 expected_bytes 2 25;
  Bytes.blit data 0 expected_bytes 3 (Bytes.length data); 
  expected_bytes;;

(* Assert packet correctly converted to bytes *)
assert (expected_bytes = packet_bytes);; 

let unpacked_packet = Packet.packet_of_bytes expected_bytes;;
let expected_packet = {
  Packet.seq_num = 0;
  Packet.data_length = 5;
  Packet.checksum = 25;
  Packet.data = Bytes.of_string "hello"
};;
(* Assert packet correctly unpacked *)
assert (unpacked_packet = expected_packet);;

(* Assert checksum functions work *)
let checksum_from_bytes = Packet.calculate_checksum_from_bytes expected_bytes;;
let checksum_from_packet = Packet.calculate_checksum_from_packet expected_packet;;
assert (checksum_from_bytes = 25);;
assert (checksum_from_packet = 25);;