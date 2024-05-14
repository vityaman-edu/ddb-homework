cluster-up:
	docker compose up --detach --build --force-recreate --remove-orphans

cluster-down:
	docker compose down

primary-sh:
	docker exec -it ddb-primary bash

standby-sh:
	docker exec -it ddb-standby bash
