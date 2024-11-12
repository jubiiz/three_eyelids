type checksum = int;;

exception Invalid_packet_bytes;;

type packet = {
  seq_num: int;
  data_length: int;
  checksum: checksum;
  data: bytes;
}

let sum_bytes (bytes: bytes) = 
 Bytes.fold_left (fun acc byte -> acc + Char.code byte) 0 bytes 

let calculate_checksum_from_bytes (packet_bytes : bytes) : checksum =
  let total = sum_bytes packet_bytes in
  let minus_checksum = total - (Bytes.get_uint8 packet_bytes 2) in 
  minus_checksum mod 256
;;

let calculate_checksum_from_packet (packet: packet) : checksum = 
  (packet.seq_num + packet.data_length + sum_bytes packet.data) mod 256
;;

let create (seq_num : int) (msg : string): packet =
  let data = Bytes.of_string msg in
  let data_length = Bytes.length data in
  let packet_without_checksum =
    {seq_num = seq_num;
      data_length = data_length;
      checksum = 0; 
      data = data;
    } in
  let checksum = calculate_checksum_from_packet packet_without_checksum in
  {seq_num = seq_num;
    data_length = data_length;
    checksum = checksum;
    data = data;
  }
;;

let packet_of_bytes (packet_bytes: bytes) : packet =
  if Bytes.length packet_bytes < 3 then raise Invalid_packet_bytes else
    let seq_num = Bytes.get_uint8 packet_bytes 0 in
    let data_length = Bytes.get_uint8 packet_bytes 1 in
    let checksum = Bytes.get_uint8 packet_bytes 2 in
    print_endline("Data length: " ^ (string_of_int data_length));
    print_endline("Packet bytes length: " ^ (string_of_int (Bytes.length packet_bytes)));

    (* Check that data is parseable before parsing *)
    if data_length <= ((Bytes.length packet_bytes) - 3) then  
        let data = Bytes.sub packet_bytes 3 data_length in
        {seq_num; data_length; checksum; data}    
    else raise Invalid_packet_bytes
;;

let bytes_of_packet (packet : packet) =
    let total_length = 3 + Bytes.length packet.data in
    let result = Bytes.create total_length in
    Bytes.set_uint8 result 0 packet.seq_num;
    Bytes.set_uint8 result 1 packet.data_length;
    Bytes.set_uint8 result 2 packet.checksum;
    Bytes.blit packet.data 0 result 3 (Bytes.length packet.data);
    result
;;
