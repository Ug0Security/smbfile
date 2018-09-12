if [ $# -ne 1 ]; then
    echo $0: usage: "smbfile.sh 0-1 (1 = write file; 0 = don't)"
    exit 1
fi


#python "../zoomeye/zoomeye-search/zoomeye.py" 'port:445 +app:"microsoft-ds" +country:"'$2'"' > iplist

cat "iplist" | while read line
do
   echo "Test $line En Cours .."
   smbclient -L //$line/ -N -c ls > test.txt
   grep "Disk" test.txt > sharetmp.txt
   grep -Eo '^[^ ]+' sharetmp.txt > sharetmp2.txt
   cat sharetmp2.txt | tr -d '[[:blank:]]'> sharetmp3.txt
   sed -e 's/$/,'$line'/' -i sharetmp3.txt 
   cat sharetmp3.txt >> share.txt
   rm sharetmp*
done


cat "share.txt" | while IFS=, read col1 col2
do 
    echo "//"$col2"/"$col1 >> resultats.txt
    if [ $1 -eq 1 ];
    then
       smbclient -N //$col2/$col1 -c 'put warning.txt' >> resultats.txt
    fi
    smbclient -N //$col2/$col1 -c ls >> resultats.txt
     
done

rm "./share.txt"
