COMPOSE_FILE=srcs/docker-compose.yml

up:
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down --volumes

clean: down
	@echo "Removing all Docker volumes..."
	@docker volume prune -f

.PHONY: up down clean
