# Practice PSQL with a Docker Container

```
$ docker-compose -f stack.yml up  
# docker exec -w /SQL/backups -it psql_db_1 ./restore.sh
```
# Manual Restore
```
psql -U postgres  
create database dvdrental;  
\q  
pg_restore -U postgres -d dvdrental Desktop/dvdrental.tar  

 
psql -U postgres  
CREATE DATABASE readychef;  
\q  
psql -U postgres readychef < readychef.sql  
```
