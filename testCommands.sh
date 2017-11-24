
//Run docker containers

docker run -t --rm --name redis -v /var/lib/redis/data:/var/lib/redis/data -p 6379:6379 redis
docker run -t --rm --name postgres -v /var/lib/postgresql/data:/var/lib/postgresql/data -p 5432:5432 postgres
docker run -t --rm --name elasticsearch -v /var/lib/elasticsearch/data:/usr/share/elasticsearch/data -p 9200:9200 elasticsearch:1.7.5 
docker run -t --rm --name mailcatcher -p 1080:1080 -p 1025:1025 schickling/mailcatcher
docker run -t --rm --name entoro-api --link redis:redis --link postgres:postgres -p 3000:3000 -e REDIS_URL=redis://redis entoro-api
docker run -t --rm --name nginx --link entoro-api:entoro-api  -p 80:80 -p 443:443 nginx

docker run -t --rm --name entoro-api --link redis:redis --link postgres:postgres -v .:/myapp -p 3000:3000 entoro-api


//database
docker exec -it postgres createdb -U postgres "designbook_development"
docker exec -it postgres psql -U postgres -c "CREATE USER postgres WITH PASSWORD 'postgres'; GRANT ALL PRIVILEGES ON DATABASE postgres to postgres; "
scp ~/Downloads/dbventure/database.dump ubuntu@52.39.44.157:/tmp
cat /tmp/database.dump |  docker exec -i postgres pg_restore -v -U postgres -d designbook_development


//API
docker exec entoro-api bin/rake db:migrate RAILS_ENV=development
docker exec entoro-api cp config/database.yml.docker config/database.yml
docker exec entoro-api rails s -b0


//Create USER
docker exec -it entoro-api /bin/bash
//Initiate rails console
rails c
OauthToken.create(user: User.find_by(email: 'admin@example.com'))
OauthToken.create(user: User.find_by(email: 'brandon+draft@designbook.com'))

stage 2 server: f222ab47bad906c7a7958fd5cdb08b9b2814266d2975fa0921c07d868e3ad947




SELECT pid, pg_terminate_backend(pid)  FROM pg_stat_activity  WHERE datname = current_database() AND pid <> pg_backend_pid();


