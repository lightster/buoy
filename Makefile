install:
	(docker network inspect buoy || docker network create buoy) &>/dev/null
	docker-compose build
	$(MAKE) data/ssl/certs/dev.crt
	docker-compose up --detach --force-recreate

reinstall:
	rm data/ssl/certs/dev.crt
	$(MAKE) install

data/ssl/certs/dev.crt:
	docker-compose run --rm dev-ssl generate
