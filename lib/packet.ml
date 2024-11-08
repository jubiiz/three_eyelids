type checksum = int;;

type packet = {
  seq_num: int;
  data: bytes;
  checksum: checksum;
  msg_length: int;
}

let get_checksum (msg_and_header : bytes) : checksum =
  Bytes.fold_left (fun acc byte -> acc + Char.code byte) 0 msg_and_header
;;

let add_seq_num_to_msg (msg : bytes) (seq_num : int) : bytes =
  Bytes.concat Bytes.empty [Bytes.of_string (string_of_int seq_num); msg]
;;

let form_packet (input : string) (seq_num : int) : packet =
  let msg = Bytes.of_string input in
  let msg_length = Bytes.length msg in
  let data_and_seq_num = add_seq_num_to_msg msg seq_num in
  let checksum = get_checksum data_and_seq_num in
  {seq_num ; data = msg ; checksum ; msg_length}
;;

let packet_as_bytes (packet : packet) =
  let seq_num = Bytes.of_string (string_of_int packet.seq_num) in
  let checksum = Bytes.of_string (string_of_int packet.checksum) in
  let msg_length = Bytes.of_string (string_of_int packet.msg_length) in
  let null_char = Bytes.make 1 (Char.chr 0) in
  Bytes.concat Bytes.empty [seq_num; msg_length; null_char; packet.data; checksum]
;;