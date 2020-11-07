# Practice PSQL with a Docker Container

```
$ docker-compose -f stack.yml up  
$ docker exec -w /SQL/backups -it psql_db_1 ./restore.sh
```
# Backups
```
$ docker exec -it -w /SQL/backups psql_db_1 /bin/bash
$ pg_dump -U postgres <db> > <db>
## has to be done from host??
tar cfJ <db>.tar.xz <db>
rm <db>
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
