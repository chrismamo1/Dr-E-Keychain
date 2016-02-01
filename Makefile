all: keychain.native

keychain.native: keychain.ml keychain_shell.ml keychain_crypto.ml
	ocamlbuild -use-ocamlfind -pkgs lwt.react,lambda-term,cryptokit,netstring,calendar,sqlite3 $@
