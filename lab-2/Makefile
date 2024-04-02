IMAGE = ddbs-postgres-14
SRS   = config/pg_hba.conf config/postgres_su_password.txt \
				script/1-initialization.sh

image.txt: Dockerfile $(SRS)
	docker build -t $(IMAGE) - < ./Dockerfile
	touch image.txt

container: image.txt
	docker run -it \
		--name $(IMAGE) \
		-v ${PWD}/config:/psql/config \
		-v ${PWD}/script:/psql/script \
		-e HOME='/psql' \
		-d $(IMAGE) \
		bash

connection: image.txt
	docker exec -it $(IMAGE) bash
