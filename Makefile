init: docker-down docker-pull docker-build docker-up
up: docker-up
down: docker-down

docker-up:
	docker compose up -d

docker-down:
	docker compose down --remove-orphans

docker-pull:
	docker compose pull

docker-build:
	docker compose build --pull

show-initial-password:
	docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

deploy:
	@echo "Starting Jenkins deployment..."
	@set -e; \
	echo "Preparing remote environment..."; \
	ssh deploy@$(HOST) -p $(PORT) 'rm -rf jenkins && mkdir jenkins'; \
	echo "Transferring files..."; \
	scp -P $(PORT) compose-production.yml deploy@$(HOST):jenkins/compose.yml; \
	scp -P $(PORT) -r docker deploy@$(HOST):jenkins/docker; \
	echo "Configuring and deploying..."; \
	ssh deploy@$(HOST) -p $(PORT) 'cd jenkins && { \
		echo "COMPOSE_PROJECT_NAME=jenkins" > .env; \
		echo "Stopping existing services..."; \
		docker compose down --remove-orphans; \
		echo "Pulling latest images..."; \
		docker compose pull; \
		echo "Building images..."; \
		docker compose build --pull; \
		echo "Starting services..."; \
		docker compose up -d; \
		echo "Services started successfully"; \
	}'; \
	echo "Jenkins deployment completed successfully"
