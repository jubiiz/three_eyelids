(* given a Bytes, which will be the Bytes that contains the message length, just transform it into an int
this will allow us to parse the Bytes easier back into a packet*)
let get_msg_length (header : bytes) : int =
  int_of_string (Bytes.to_string header);;

(* this function takes a Bytes message which is received from rdt_send and then unpacks it into a packet option.
The reason we do packet option is because should there be an error with the parsing that means something went wrong in the rdt_send
So in the case we get an error we return None to indicate that no proper Bytes was sent. If we can successfully parse the Bytes
then we return Some packet*)
let unpack (msg_bytes : bytes) : Packet_type.packet option =
  try (
    (* since we know the seq_num is only ever 0 or 1, we know it will always be the first byte and will have length 1,
     so we can easily extract the seq_num*)
  let seq_num = int_of_string (Bytes.to_string (Bytes.sub msg_bytes 0 1)) in 

    (* Now that we have extracted the seq_num, we only need to focus on the rest of the bits, so get the Bytes without index 0*)
  let msg_no_seq_num = Bytes.sub msg_bytes 1 ((Bytes.length msg_bytes) - 1) in

    (* Now there are two sections of the remaining Bytes, the msg_length and the msg+checksum
    we need to extract the msg_length so that we can parse the actual message. So we call split_on_char on the NULL char
    which was added to act as the delimiter between msg_length and msg. We then get a Bytes list where index 0 is the Bytes containing the msg_length
    and index 1 is then the msg and the checksum*)
  let split = Bytes.split_on_char (Char.chr 0) msg_no_seq_num in

    (* Then using index 0 of the Bytes list we got in the previous step get the int of the msg_length*)
  let msg_length = get_msg_length (List.nth split 0) in

  (* Now that we know how long the msg is, simply get the subsequence of the Bytes list index 1 starting at 0 for length msg. This will
  extract the msg*)
  let msg = Bytes.sub (List.nth split 1) 0 (msg_length) in

  (* Now get the checksum, which starts at index msg_length of the Bytes list index 1 and then goes to the end of the Bytes*)
  let checksum = int_of_string (Bytes.to_string (Bytes.sub (List.nth split 1) (msg_length) ((Bytes.length (List.nth split 1)) - msg_length))) in

  Some {seq_num; data = msg; checksum; msg_length})
  with 
  | _ -> None;;

(* this function takes the parsed packet and then reconstructs the Bytes with the information it parsed without the checksum.
It then calculates the Bytes checksum. It then compares it to the parsed checksum to make sure they are the same. If they are not, we know 
that there was an error during rdt_send and then we will have to discard this packet*)
let compare_checksums (packet : Packet_type.packet) : bool =
  let rebuilt = Bytes.concat Bytes.empty [Bytes.of_string (string_of_int packet.seq_num); Bytes.of_string (string_of_int packet.msg_length); Bytes.make 1 (Char.chr 0); packet.data] in
  let calculated_checksum = Create_packet.get_checksum rebuilt in
  calculated_checksum = packet.checksum;;