install:
	(docker network inspect buoy || docker network create buoy) &>/dev/null
	docker-compose build
	$(MAKE) data/ssl/certs/dev.crt
	docker-compose up --detach --force-recreate

reinstall:
	rm -f data/ssl/certs/dev.crt
	$(MAKE) install

data/ssl/certs/dev.crt:
	docker-compose run --rm dev-ssl
	sudo security add-trusted-cert -d -r trustRoot \
		-k /Library/Keychains/System.keychain \
		data/ssl/certs/dev.crt
