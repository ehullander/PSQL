#!/bin/sh
for i in $(ls *.tar.xz); 
	do tar -xf $i ; 
	echo $i; 
	psql -U postgres -c "create database ${i%.tar.xz}"; 
	psql -U postgres -d ${i%.tar.xz} -f ${i%.tar.xz}; 
	rm ${i%.tar.xz};
done

