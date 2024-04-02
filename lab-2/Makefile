IMAGE = ddbs-postgres-14

image.txt: Dockerfile
	docker build -t $(IMAGE) - < ./Dockerfile
	touch image.txt

container: image.txt
	docker run -i -t $(IMAGE) bash
