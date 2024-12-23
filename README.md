# three_eyelids
Ocaml implementation of a stop-and-wait Reliable Data Transfer (RDT) protocol.

Notice: large parts of the UDP helper code are inspired from:
https://medium.com/@aryangodara_19887/udp-client-and-server-in-ocaml-e203116a997c

## Imports
```
opam install lwt
opam install logs
opam install lwt_ppx
```

## Build
```
dune build
```

## Run the tests
```
dune runtest
```

## Export your IP addresses
```
export CLIENT_ADDRESS='YOUR.IP.ADDR.ESS'
export SERVER_ADDRESS='YOUR.IP.ADDR.ESS'
```

## Run the client
```
dune exec client
```

## Run the server
```
dune exec server
```

You can then type messages in the client, followed by a newline, and they
will be sent to the server!
