#!bin/bash

make
exec="as"
repertoire="../Tests"
resultat=$repertoire"/resultat"
echo $(rm -f $resultat)
for i in $(ls $repertoire)
do
	echo $i
    ./$exec < $repertoire/$i
	# renvoie le résultat dans le fichier 'resultat' sous la
	# forme 'nom de fichier' 'résultat de l'analyse du fichier (0 ou 1)'
    echo $i $? >> $resultat
done
make mrproper
