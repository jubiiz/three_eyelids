open Shared;;

let server_socket = Lwt_main.run @@ Udt.get_server_socket ()
let null_byte = Bytes.make 1 (Char.chr 0);;

let ack_packet (seq_num: int) (client_addr: Unix.sockaddr) = 
  let ack_packet = Packet.create seq_num "ACK" in
  let ack_packet_bytes = Packet.bytes_of_packet ack_packet in
  Udt.send ack_packet_bytes server_socket client_addr;;

let nack_packet (seq_num: int) (client_addr: Unix.sockaddr) = 
  let ack_packet = Packet.create seq_num "NACK" in
  let ack_packet_bytes = Packet.bytes_of_packet ack_packet in
  Udt.send ack_packet_bytes server_socket client_addr;;

print_endline "Hello, World, this is server running!";;

let expected_seq_num = 0;;

(*B: ok*)
let response_option = Udt.recv server_socket 0.0 in
match response_option with 
    | None -> assert false
    | Some response -> 
    let packet_bytes = response.data in
    let _ = print_endline ("Received packet with bytes: " ^ (Bytes.to_string packet_bytes)) in
    let packet = Packet.packet_of_bytes packet_bytes in
    let checksum = Packet.calculate_checksum_from_packet packet in
    if checksum != packet.checksum then
        let _ = print_endline "bad checksum" in
        nack_packet expected_seq_num response.sender_addr
    else if packet.seq_num != expected_seq_num then
        let _ = print_endline "bad seq num" in
        nack_packet expected_seq_num response.sender_addr
    else
        let _ = print_endline ("SEQ NUM: " ^ (string_of_int packet.seq_num)) in
        let _ = print_endline ("DATA LENGTH: " ^ (string_of_int packet.data_length)) in
        let _ = print_endline ("CHECKSUM: " ^ (string_of_int packet.checksum)) in
        let _ = print_endline ("DATA: " ^ (Bytes.to_string packet.data) ^ "\n") in
        let new_expected_seq_num = Sequence_number.increment expected_seq_num in
        let _ = ack_packet new_expected_seq_num response.sender_addr in
        if packet.data = null_byte then assert false
        else 0;; 



let expected_seq_num = 1;;

(*A: corrupted receive*)
let response_option = Udt.recv server_socket 0.0 in
match response_option with 
    | None -> assert false
    | Some response -> 
    let packet_bytes_ok = response.data in
    let packet_bytes = Bytes.copy packet_bytes_ok in
    let _ = Bytes.set packet_bytes 3 (Char.chr 0) in
    let _ = print_endline ("Received packet with bytes: " ^ (Bytes.to_string packet_bytes)) in
    let packet = Packet.packet_of_bytes packet_bytes in
    let checksum = Packet.calculate_checksum_from_packet packet in
    if checksum != packet.checksum then
        let _ = print_endline "bad checksum" in
        nack_packet expected_seq_num response.sender_addr
    else if packet.seq_num != expected_seq_num then
        let _ = print_endline "bad seq num" in
        nack_packet expected_seq_num response.sender_addr
    else
        let _ = print_endline ("SEQ NUM: " ^ (string_of_int packet.seq_num)) in
        let _ = print_endline ("DATA LENGTH: " ^ (string_of_int packet.data_length)) in
        let _ = print_endline ("CHECKSUM: " ^ (string_of_int packet.checksum)) in
        let _ = print_endline ("DATA: " ^ (Bytes.to_string packet.data) ^ "\n") in
        let new_expected_seq_num = Sequence_number.increment expected_seq_num in
        let _ = ack_packet new_expected_seq_num response.sender_addr in
        if packet.data = null_byte then assert false
        else assert false ;;

    
let expected_seq_num = 1;;
(*A: ok*)
let response_option = Udt.recv server_socket 0.0 in
match response_option with 
    | None -> assert false
    | Some response -> 
    let packet_bytes = response.data in
    let _ = print_endline ("Received packet with bytes: " ^ (Bytes.to_string packet_bytes)) in
    let packet = Packet.packet_of_bytes packet_bytes in
    let checksum = Packet.calculate_checksum_from_packet packet in
    if checksum != packet.checksum then
        let _ = print_endline "bad checksum" in
        nack_packet expected_seq_num response.sender_addr
    else if packet.seq_num != expected_seq_num then
        let _ = print_endline "bad seq num" in
        nack_packet expected_seq_num response.sender_addr
    else
        let _ = print_endline ("SEQ NUM: " ^ (string_of_int packet.seq_num)) in
        let _ = print_endline ("DATA LENGTH: " ^ (string_of_int packet.data_length)) in
        let _ = print_endline ("CHECKSUM: " ^ (string_of_int packet.checksum)) in
        let _ = print_endline ("DATA: " ^ (Bytes.to_string packet.data) ^ "\n") in
        let new_expected_seq_num = Sequence_number.increment expected_seq_num in
        let _ = ack_packet new_expected_seq_num response.sender_addr in
        if packet.data = null_byte then assert false
        else 0;; 

let expected_seq_num = 0;;
(*R: out of order receive*)
let response_option = Udt.recv server_socket 0.0 in
match response_option with 
    | None -> assert false
    | Some response -> 
    let packet_bytes_ok = response.data in
    let packet_bytes = Bytes.copy packet_bytes_ok in
    let _ = Bytes.set packet_bytes 0 (Char.chr 1) in
    let _ = print_endline ("Received packet with bytes: " ^ (Bytes.to_string packet_bytes)) in
    let packet = Packet.packet_of_bytes packet_bytes in
    if packet.seq_num != expected_seq_num then
        let _ = print_endline "bad seq num" in
        nack_packet expected_seq_num response.sender_addr
    else
        let _ = print_endline ("SEQ NUM: " ^ (string_of_int packet.seq_num)) in
        let _ = print_endline ("DATA LENGTH: " ^ (string_of_int packet.data_length)) in
        let _ = print_endline ("CHECKSUM: " ^ (string_of_int packet.checksum)) in
        let _ = print_endline ("DATA: " ^ (Bytes.to_string packet.data) ^ "\n") in
        let new_expected_seq_num = Sequence_number.increment expected_seq_num in
        let _ = ack_packet new_expected_seq_num response.sender_addr in
        if packet.data = null_byte then assert false
        else assert false ;;

let expected_seq_num = 0;;
(*R: ok*)
let response_option = Udt.recv server_socket 0.0 in
match response_option with 
    | None -> assert false
    | Some response -> 
    let packet_bytes = response.data in
    let _ = print_endline ("Received packet with bytes: " ^ (Bytes.to_string packet_bytes)) in
    let packet = Packet.packet_of_bytes packet_bytes in
    let checksum = Packet.calculate_checksum_from_packet packet in
    if checksum != packet.checksum then
        let _ = print_endline "bad checksum" in
        assert false
    else if packet.seq_num != expected_seq_num then
        let _ = print_endline "bad seq num" in
        assert false
    else
        let _ = print_endline ("SEQ NUM: " ^ (string_of_int packet.seq_num)) in
        let _ = print_endline ("DATA LENGTH: " ^ (string_of_int packet.data_length)) in
        let _ = print_endline ("CHECKSUM: " ^ (string_of_int packet.checksum)) in
        let _ = print_endline ("DATA: " ^ (Bytes.to_string packet.data) ^ "\n") in
        let new_expected_seq_num = Sequence_number.increment expected_seq_num in
        let _ = ack_packet new_expected_seq_num response.sender_addr in
        if packet.data = null_byte then assert false
        else 0;; 


let expected_seq_num = 1;;
(*termination: ok*)
let response_option = Udt.recv server_socket 0.0 in
match response_option with 
    | None -> assert false
    | Some response -> 
    let packet_bytes = response.data in
    let _ = print_endline ("Received packet with bytes: " ^ (Bytes.to_string packet_bytes)) in
    let packet = Packet.packet_of_bytes packet_bytes in
    let checksum = Packet.calculate_checksum_from_packet packet in
    if checksum != packet.checksum then
        let _ = print_endline "bad checksum" in
        nack_packet expected_seq_num response.sender_addr
    else if packet.seq_num != expected_seq_num then
        let _ = print_endline "bad seq num" in
        nack_packet expected_seq_num response.sender_addr
    else
        let _ = print_endline ("SEQ NUM: " ^ (string_of_int packet.seq_num)) in
        let _ = print_endline ("DATA LENGTH: " ^ (string_of_int packet.data_length)) in
        let _ = print_endline ("CHECKSUM: " ^ (string_of_int packet.checksum)) in
        let _ = print_endline ("DATA: " ^ (Bytes.to_string packet.data) ^ "\n") in
        let new_expected_seq_num = Sequence_number.increment expected_seq_num in
        let _ = ack_packet new_expected_seq_num response.sender_addr in
        if packet.data = null_byte then 0 
        else assert false;; 
