# Practice PSQL with a Docker Container

docker-compose -f stack.yml up  

docker exec -it <container_name> bash   
psql -U postgres  
create database dvdrental;  
\q  
pg_restore -U postgres -d dvdrental Desktop/dvdrental.tar  

 
psql -U postgres  
CREATE DATABASE readychef;  
\q  
psql -U postgres readychef < readychef.sql  

