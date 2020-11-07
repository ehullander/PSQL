# Practice PSQL with a Docker Container

```
docker-compose -f stack.yml up  

docker exec -it <container_name> bash   
cd SQL/backups; for i in $(ls *.tar.xz); do tar -xf ${i%.tar.xz} ; echo $i; psql -U postgres -c "create database ${i%.tar.xz}"; psql -U postgres -d ${i%.tar.xz} -f ${i%.tar.xz}; done


psql -U postgres  
create database dvdrental;  
\q  
pg_restore -U postgres -d dvdrental Desktop/dvdrental.tar  

 
psql -U postgres  
CREATE DATABASE readychef;  
\q  
psql -U postgres readychef < readychef.sql  
```
