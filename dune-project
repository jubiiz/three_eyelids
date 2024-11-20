(lang dune 3.15)

(name three_eyelids)

(generate_opam_files true)

(source
 (github jubiiz/three_eyelids))

(authors "Julien Audet" "Sebastian Reinhardt")

(maintainers "Julien Audet" "Sebastian Reinhardt")

(license LICENSE)

(documentation "see the README.md file")

(package
 (name three_eyelids)
 (synopsis "An implementation of a Reliable Data Transfer (RDT) protocol.")
 (description "An implementation of a Reliable Data Transfer (RDT) protocol. Currently 
 an implementation of the Stop-and-Wait protocol, built on top of UDP.")
 (depends ocaml dune)
 (tags
  ("Reliable Data Transfer" RDT "Stop-and-Wait" UDP "Networking" "Computer Networks")))
