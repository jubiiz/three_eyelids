(* Takes the packet which we will send and then calculates the checksum
   Simple matter of just iterating over each byte then adding up its ASCII value*)
let get_checksum (packet : bytes) : Packet_type.checksum =
  Bytes.fold_left (fun acc byte -> acc + Char.code byte) 0 packet
;;

(* takes the message and sequence number and then creates the first iteration of a packet
   Checksum is initialized to -1 because we have not yet created the bytes which will be sent*)
let form_packet (input : string) (seq_num : int) : Packet_type.packet =
  let msg = Bytes.of_string input in
  let msg_length = Bytes.length msg in
  {seq_num ; data = msg ; checksum = -1 ; msg_length}
;;

(* Takes a packet and then converts each attribute into a Bytes. It then concatonates the seq_num, msg_length, NULL char, and the msg
into a Bytes. This is the Bytes that we will want to know the checksum. Once the checksum is calculated, just update the packet so that
its checksum is the right value and not -1. Then add the Bytes of the checksum to the Bytes containing the other information, so that
we have the Bytes we will send*)
let packet_as_bytes (packet : Packet_type.packet) =
  let seq_num = Bytes.of_string (string_of_int packet.seq_num) in
  let msg_length = Bytes.of_string (string_of_int packet.msg_length) in
  let null_char = Bytes.make 1 (Char.chr 0) in
  let bytes_without_checksum = Bytes.concat Bytes.empty [seq_num; msg_length; null_char; packet.data] in 
  let checksum = get_checksum bytes_without_checksum in
  packet.checksum <- checksum;
  Bytes.concat Bytes.empty [bytes_without_checksum; Bytes.of_string (string_of_int packet.checksum)]
;;