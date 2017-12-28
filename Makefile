install:
	(docker network inspect pier-buoy || docker network create pier-buoy) 1>/dev/null 2>/dev/null
	docker-compose build
	$(MAKE) data/ssl/certs/dev.crt
	docker-compose up -d

data/ssl/certs/dev.crt:
	docker-compose run --rm dev-ssl generate
