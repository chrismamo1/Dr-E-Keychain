SRC = keychain.ml keychain_shell.ml keychain_crypto.ml keychain_make_passwords.ml

PKGS = lwt.react,lambda-term,cryptokit,netstring,calendar,sqlite3,nocrypto,nocrypto.unix

all: keychain.native

keychain.native: $(SRC)
	ocamlbuild -use-ocamlfind -pkgs $(PKGS) $@
