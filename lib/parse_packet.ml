type checksum = int;;

type packet = {
  seq_num: int;
  data: bytes;
  checksum: checksum;
  msg_length: int;
}

let get_msg_length (header : bytes) : int =
  int_of_string (Bytes.to_string header);;

let unpack (msg_bytes : bytes) : packet =
  let seq_num = int_of_string (Bytes.to_string (Bytes.sub msg_bytes 0 1)) in

  let msg_no_seq_num = Bytes.sub msg_bytes 1 ((Bytes.length msg_bytes) - 1) in

  let split = Bytes.split_on_char (Char.chr 0) msg_no_seq_num in

  let msg_length = get_msg_length (List.nth split 0) in

  let msg = Bytes.sub (List.nth split 1) 0 (msg_length) in

  let checksum = int_of_string (Bytes.to_string (Bytes.sub (List.nth split 1) (msg_length) ((Bytes.length (List.nth split 1)) - msg_length))) in

  {seq_num; data = msg; checksum; msg_length};;

  (*
let compare_checksums (packet : packet) (expected_checksum : checksum) : bool =
  packet.checksum = expected_checksum;;*)