let () = Nocrypto_entropy_unix.initialize ()

let load_common_words () =
  let ic = open_in "common_words.txt" in
  let words = ref [] in
  let () =
    try
      while true do
        let w =
          input_line ic
          |> String.trim
          |> String.lowercase in
        if String.length w < 2 || String.length w > 7
        then ()
        else words := (String.trim w) :: !words
      done;
    with | exn -> ()
  in
  let words = !words in
  let () = Printf.printf "Loaded %d words.\n" (List.length words) in
  words

let rec generate_combo words n =
  let i = Nocrypto.Rng.Int.gen (List.length words) in
  match n with
  | 1 ->
      [List.nth words i]
  | n ->
      (List.nth words i) :: (generate_combo words (n - 1))
