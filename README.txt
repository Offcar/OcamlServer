-----CREDITOS-----
En respeto a los autores de los códigos no creados en esta implementación se tienen las siguientes direcciones url:

https://ocaml.github.io/ocamlunix/ocamlunix.html
Sitio web utilizado para las funciones complementarias para configurar el servidor

https://rosettacode.org/wiki/Read_entire_file#OCaml
Sitio web utilizado para obtener la función de lectura de archivo

----------INSTRUCCIONES DE COMPILACIÓN Y USO----------

-----COMPILACIÓN Y EJECUCIÓN DE SERVIDOR-----
Dentro de una terminal ubicada en el directorio, ejecutar:

$ ocamlopt -o server unix.cmxa suficiencia.ml

Esto generará un conjunto de archivos junto a un ejecutable con el nombre "server" que se utilizará en la siguiente línea de comando:

$ ./server 7070

Ejecutado este comando, la terminal ejecuta el servidor que queda en escucha para luego establecer conexión en el siguiente paso.
NOTA: El puerto a utilizar en este trabajo es el 70. Dicho esto, por motivos de sistema operativo no es posible utilizar el puerto 70.
      Para tener similitud al enunciado inicial usaremos el puerto 7070.

-----CONEXIÓN A SERVIDOR-----
Dentro de una nueva terminal, se ejecuta el siguiente comando:

$ echo "input" | nc 127.0.1.1 7070 > "output"

tambien se permite

$ echo "input" | nc localhost 7070 > "output"

Una vez ejecutada esta línea de comando,se generará el archivo "output" en la ubicación en que se encuentre la terminal.
Cabe destacar que respetar la extensión entre "input" y "output" otorga los mejores resultados.

Si la ruta ingresada en input no lleva a un archivo real, se reportará el error en el archivo de salida con una descripción en texto simple.
ej:
  echo "/Escritorio" | nc 127.0.1.1 7070 > error.txt
  donde error.txt contiene "No pudo efectuarse el envio de archivos, el archivo descrito no existe o la ruta es invalida."

El input funciona tanto con una ruta que lleve a algun archivo o con el nombre completo de un archivo en la carpeta que se ejecute el programa.
ej:  echo "README.txt" | nc localhost 7070 > new_readme.txt 
     genera el mismo archivo que 
     echo "../Suficiencia/README.txt" | nc localhost 7070 > new_readme.txt


-----Ejemplos probados-----
$ echo "test_image.png" | nc 127.0.1.1 7070 > new_image.png
$ echo "test_text.txt" | nc 127.0.1.1 7070 > new_text.txt
$ echo "README.txt" | nc localhost 7070 > new_readme.txt

