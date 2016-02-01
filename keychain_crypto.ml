open Cryptokit

let to_hex s = transform_string (Hexa.encode ()) s

let of_hex s = transform_string (Hexa.decode ()) s

let aes_enc plain key =
  let res = Bytes.create 16 in
  let cipher = new Block.aes_encrypt (to_hex key) in
  let plain = to_hex plain in
  let _ = cipher#transform plain 0 res 0 in
  res
