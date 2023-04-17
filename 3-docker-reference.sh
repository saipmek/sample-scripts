docker ps -a
curl -kv https://localhost:8443/api/v1/metrics
curl -kv https://localhost:8443/api/v1/auth-providers
docker logs -f ocelot
docker exec -it ocelot sh
node -v


See last 100 lines of Ocelot logs 
docker logs --tail=100 ocelot 

See details of ocelot container 
docker inspect ocelot 

See size of log files for containers on the box 
ls -al /var/lib/docker/containers/*/*-json.log 

Truncate logs if they get too big 
truncate -s 0 {log location from previous command} 

Remove docker containers 
docker rm {container-id (additional-container-id)} 

Docker daemon not found: 
systemctl start docker  
