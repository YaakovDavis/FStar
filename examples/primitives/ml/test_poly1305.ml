open Poly
open Char
open SBuffer
open FStar_SBytes

let from_string s =
  let b = create 0 (String.length s) in
  for i = 0 to (String.length s - 1) do
    upd b i (code (String.get s i))
  done;
  b

let from_bytestring s =
  let b = create 0 ((String.length s) / 2) in
  for i = 0 to ((String.length s / 2) - 1) do
    upd b i (int_of_string ("0x" ^ (String.sub s (2*i) 2)))
  done;
  b
  
let key = from_bytestring "85d6be7857556d337f4452fe42d506a80103808afb0db2fd4abff6af4149f51b"
let msg = from_string "Cryptographic Forum Research Group"
let expected = "Tag: a8:06:1d:c1:30:51:36:c6:c2:2b:8b:af:0c:01:27:a9"

let _ =
  (* To store the hash *)
  let hash = create (0) 16 in
  (* Run hash computation *)
  poly1305_mac hash msg 34 key;
  (* Output result *)
  print_string ("Expected " ^ expected ^ "\n");
  print_string "Got hash:\n";
  print_bytes hash 
