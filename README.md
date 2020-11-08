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

# pgAdmin4

```
$ docker run --rm -p 8080:80 -v pgadmin:/var/lib/pgadmin  -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com'     -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret'     -d dpage/pgadmin4
```
