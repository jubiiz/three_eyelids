# three_eyelids
Ocaml implementation of a stop-and-wait Reliable Data Transfer (RDT) protocol.

Notice: large parts of the UDP helper code are inspired from:
https://medium.com/@aryangodara_19887/udp-client-and-server-in-ocaml-e203116a997c

## Build
```
dune build
```

## Run the tests
```
dune runtest
```

## Run the client
```
dune exec client
```

## Run the server
```
dune exec server
```
