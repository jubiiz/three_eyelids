open Shared;;

let server_socket = Lwt_main.run @@ Udt.get_server_socket ()
let null_byte = Bytes.make 1 (Char.chr 0);;

let ack_packet (seq_num: int) (client_addr: Unix.sockaddr) = 
  let ack_packet = Packet.create seq_num "ACK" in
  let ack_packet_bytes = Packet.bytes_of_packet ack_packet in
  Udt.send ack_packet_bytes server_socket client_addr

let nack_packet (seq_num: int) (client_addr: Unix.sockaddr) = 
  let ack_packet = Packet.create seq_num "NACK" in
  let ack_packet_bytes = Packet.bytes_of_packet ack_packet in
  Udt.send ack_packet_bytes server_socket client_addr

let rdt_recv (): string= 
    let rec rdt_recv_part (parts: string list) (expected_seq_num: int): string = 
        let response = Udt.recv server_socket in
        let packet_bytes = response.data in
        let _ = print_endline ("Received packet with bytes: " ^ (Bytes.to_string packet_bytes)) in
        let packet = Packet.packet_of_bytes packet_bytes in
        let checksum = Packet.calculate_checksum_from_packet packet in
        if checksum != packet.checksum then
            let _ = print_endline "bad checksum" in
            let _ = nack_packet expected_seq_num response.sender_addr in
            rdt_recv_part parts expected_seq_num
        else if packet.seq_num != expected_seq_num then
            let _ = print_endline "bad seq num" in
            let _ = nack_packet expected_seq_num response.sender_addr in
            rdt_recv_part parts expected_seq_num
        else
            let _ = print_endline ("SEQ NUM: " ^ (string_of_int packet.seq_num)) in
            let _ = print_endline ("DATA LENGTH: " ^ (string_of_int packet.data_length)) in
            let _ = print_endline ("CHECKSUM: " ^ (string_of_int packet.checksum)) in
            let _ = print_endline ("DATA: " ^ (Bytes.to_string packet.data) ^ "\n") in
            let new_expected_seq_num = Sequence_number.increment expected_seq_num in
            let _ = ack_packet new_expected_seq_num response.sender_addr in
            if packet.data = null_byte then String.concat "" (List.rev parts)
            else rdt_recv_part ((Bytes.to_string packet.data)::parts) new_expected_seq_num  in
  rdt_recv_part [] 0
;;

let rec server () = 
  let response = rdt_recv () in
  print_endline ("Received message: " ^ response);
  server ()
;;


print_endline "Hello, World, this is server running!";;
let () = server();;
