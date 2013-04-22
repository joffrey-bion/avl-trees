#!/bin/bash

for i in $(seq 1 38); do

    let num=$i*1000
    echo $num

    # Ici zero.txt est utilisé uniquement pour effectuer le choix 0 dans codespostaux
    # Nous aurions pu tout autant créer un nouveau programme de test qui n'aurait fait 
    #   que des insertions, sans utiliser codes postaux.
    time ./codespostaux "codes-$num.txt" < "zero.txt" > /dev/null
    
    echo -e "\n"

done    
