#!/bin/bash
#Création fichier .c et .h
echo "Compilation de l'analyseur"
make
echo -e "\n\n"

#Initialisation des variables de chemins
exec="as"
repertoire="../Tests"
positif=$repertoire"/positifs"
negatif=$repertoire"/negatifs"
resultat=$repertoire"/resultat.log"
rm -f $resultat #Suppression anciens résultats

#Tests des positifs
for i in $(ls $positif)
do
	echo "./as < "$i
    ./$exec < $positif/$i
	# renvoie le résultat dans le fichier 'resultat' sous la
	# forme 'nom de fichier' 'résultat de l'analyse du fichier (0 ou 1)'
    echo "Résultat attendus pour "$i": 0, résultat obtenu: "$? >> $resultat
done

#Tests des négatifs
for i in $(ls $negatif)
do
	echo "./as < "$i
    ./$exec < $negatif/$i
	# renvoie le résultat dans le fichier 'resultat' sous la
	# forme 'nom de fichier' 'résultat de l'analyse du fichier (0 ou 1)'
    echo "Résultat attendus pour "$i": 1, résultat obtenu: "$? >> $resultat
done

#Suppression des fichiers .c et .h
echo -e "\n\n"
echo "Suppression des fichiers .c et .h"
make mrproper
