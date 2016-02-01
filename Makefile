SRC = keychain.ml keychain_shell.ml keychain_crypto.ml keychain_make_passwords.ml,nocrypto,nocrypto.unix

PKGS = lwt.react,lambda-term,cryptokit,netstring,calendar,sqlite3

all: keychain.native

keychain.native: $(SRC)
	ocamlbuild -use-ocamlfind -pkgs $(PKGS) $@
