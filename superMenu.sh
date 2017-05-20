#!/bin/sh

#------------------------------------------------------

# FUNCTIONES AUXILIARES

#------------------------------------------------------

imprimir_encabezado () {
    clear;

    echo `date`;

    echo "";

    echo "   ----------------------------";    

    echo "       $1 ";

    echo "   ----------------------------";

    echo "";

}

esperar () {

    echo "";

    echo "Presione enter para continuar";

    read ENTER ;

}

malaEleccion () {

    echo "Selecccón Inválida ..." ;

}

#------------------------------------------------------

# FUNCTIONES del MENU

#------------------------------------------------------

a_funcion () {

    imprimir_encabezado "ls personalizado";

    echo "Ingrese directorio a listar";

    read directorio;

    ls -l $directorio | sed '1d' | awk '{print $9"\t"$1}';

    ls -l $directorio | sed '1d' | awk '{print $9"\t"$1}' > Output.log;
}

b_funcion () {

    imprimir_encabezado "Find Personalizado";

    echo "Ingrese la direccion de un archivo de texto";

    read directorio;

    echo "Ingrese una cadena de caracteres";

    read cadena;

    echo "Ingrese otra cadena por la cual quiere cambiar la anterior";

    read reemplazo;

    echo "Cantidad de lineas del archivo";

    grep -cve '^\s*$' $directorio; # Este comando busca las lineas que (-v) coinciden con el patron (-e) '^\s*$' que es el inicio de una linea y seguida de 0
				   # o mas espacios en blanco hasta terminar la linea, y muestra un conteo de esas lineas (-c)

    echo "Cantidad de lineas con la cadena";

    grep -ce $cadena $directorio; # Cuenta las lineas que contengan la cadena guardada en $cadena

    sed -i s/$cadena/$reemplazo/g $directorio; # Comando para buscar s/cadena-a-reemplazar/reemplazo/g en $directorio

}

c_funcion () {

    imprimir_encabezado "Permisos";

    echo "Ingrese la direccion de un directorio"

    read directorio;

    rm rutasPermisos.txt

    ##guarda en rutas.txt el path de cada .mp3, y en rutasPermisos.txt el path y los permisos de los mp3
    find $directorio -name "*.mp3" > rutas.txt;
    for linea in $(cat rutas.txt);do
 
    	ls -l $linea | awk '{print $9"\t"$1}' >> rutasPermisos.txt;

    done

    #cambia los permisos, sin acceso
    for linea in $(cat rutas.txt);do
    	chmod 0 $linea;
    done 

    ##AGREGA LOS .JPG
    find $directorio -name "*.jpg" > rutas.txt;
    for linea in $(cat rutas.txt);do
 
    	ls -l $linea | awk '{print $9"\t"$1}' >> rutasPermisos.txt;

    done
    #cambia los permisos, sin acceso
    for linea in $(cat rutas.txt);do
   
    	chmod 0 $linea;

    done 

    ##AGREGA LOS .TXT
    find $directorio -name "*.txt" > rutas.txt;
    for linea in $(cat rutas.txt);do
 
    	ls -l $linea | awk '{print $9"\t"$1}' >> rutasPermisos.txt;

    done
    #cambia los permisos, sin acceso
    for linea in $(cat rutas.txt);do
   
    	chmod 0 $linea;

    done 
    chmod +rwx rutasPermisos.txt

    #PREGUNTA PARA DEVOLVERLOS A COMO ESTABAN
    echo 'Quiere devolver los permisos de los archivos a su estado original?'

    read respuesta;

    SI1="si"
    SI2="SI"
    SI3="Si"
    SI4="sI"
    SI5="S"
    SI6="s"

    if [ $SI1 = $respuesta ] || [ $SI2 = $respuesta ] || [ $SI3 = $respuesta ] || [ $SI4 = $respuesta ] || [ $SI5 = $respuesta ] || [ $SI6 = $respuesta ]; then

	while read linea; do 

              nombre=$( echo $linea | awk '{print $1}');

	      permiso=$( echo $linea | awk '{print $2}');

	      propietario=${permiso:1:3}
	      grupo=${permiso:4:3}
	      otros=${permiso:7:3}

	      chmod u=$propietario,g=$grupo,o=$otros $nombre

        done <rutasPermisos.txt

    fi

    chmod +rwx rutas.txt
    rm rutas.txt  

}

#------------------------------------------------------

# DISPLAY MENU

#------------------------------------------------------

imprimir_menu () {

    imprimir_encabezado "S U P E R - M E N U";

    echo "     Opciones:";

    echo "";

    echo "       a.  Ls personalizado";

    echo "       b.  Find personalizado";

    echo "       c.  Permisos";

    echo "       q.  Salir";

    echo "";

    echo "Escriba la opción y presione ENTER";

}

#------------------------------------------------------

# LOGICA PRINCIPAL

#------------------------------------------------------

while  true

do

    # 1. mostrar el menu

    imprimir_menu;

    # 2. leer la opcion del usuario

    read opcion;

    
    case $opcion in

            a|A) a_funcion;;

            b|B) b_funcion;;

            c|C) c_funcion;;

            q|Q) break;;

            *) malaEleccion;;

    esac

    esperar;

done
