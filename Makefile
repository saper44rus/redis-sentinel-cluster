.PHONY: config
config:
	docker build --target redis --tag redis:cluster .
	docker build --target sentinel --tag redis:sentinel .
	docker network create redis-network --subnet 172.23.0.0/24 || true
	rm -rf redis01 redis02 redis03 
	mkdir -p redis01 redis02 redis03
	PRIORITY=100 SHARD=01 envsubst < redis.conf > redis01/redis.conf
	PRIORITY=200 SHARD=01 envsubst < redis.conf > redis02/redis.conf
	PRIORITY=200 SHARD=01 envsubst < redis.conf > redis03/redis.conf
	cp redis.conf sentinel.conf redis01/
	cp redis.conf sentinel.conf redis02/
	cp redis.conf sentinel.conf redis03/
	echo 'replicaof 172.23.0.11 6379' >> redis02/redis.conf
	echo 'replicaof 172.23.0.11 6379' >> redis03/redis.conf

.PHONY: up
up:
	docker-compose up -d

.PHONY: start
start:
	docker-compose start

.PHONY: down
down:
	docker-compose down

