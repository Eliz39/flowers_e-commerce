# flowers_e-commerce


Remove volume with database
```

    docker-compose stop
    docker-compose down

    docker volume ls ---print list of volumes

    docker volume rm <volume-name>

    example:

    docker volume rm flowers_e-commerce_postgres-db


    after that we need to run db

    docker-compose up

```



Create backup postgres --- edit according real credentials
```
docker run --rm -v $(pwd):/backups -e PGPASSWORD=mysecret postgres:12 pg_dump -h db.example.com -p 5432 -U dbuser -d mydb -F p -b -v -f /backups/backup.sql


```



Restore local postgres
```
    docker exec -i flowers_e-commerce_db_1 psql -U postgres postgres < backup.sql

```




