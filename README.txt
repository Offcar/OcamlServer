-----CREDITOS-----
En respeto a los autores de los códigos no creados en esta implementación se tienen las siguientes direcciones url:
https://ocaml.github.io/ocamlunix/ocamlunix.html

Sitio web utilizado para las funciones complementarias para configurar el servidor
https://rosettacode.org/wiki/Read_entire_file#OCaml

-----COMPILACIÓN Y EJECUCIÓN DE SERVIDOR-----
Dentro de una terminal ubicada en el directorio, ejecutar:

$ ocamlopt -o server unix.cmxa ocamlserver.ml

Esto generará un conjunto de archivos junto a un ejecutable con el nombre "server" que se utilizará en la siguiente línea de comando:

$ ./server 7070

Setting port 7070 for server usage.

-----CONEXIÓN A SERVIDOR-----
Dentro de una nueva terminal, se ejecuta el siguiente comando:

$ echo "input" | nc 127.0.1.1 7070 > "output"

tambien se permite

$ echo "input" | nc localhost 7070 > "output"

-----Examples-----
$ echo "test_text.txt" | nc 127.0.1.1 7070 > new_text.txt
$ echo "README.txt" | nc localhost 7070 > new_readme.txt

