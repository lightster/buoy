install:
	(docker network inspect pier-buoy || docker network create pier-buoy) 1>/dev/null 2>/dev/null
	docker-compose build
	docker-compose up -d
