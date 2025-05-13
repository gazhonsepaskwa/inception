COMPOSE_FILE=srcs/docker-compose.yml

up:
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down -v

clean: down
	@echo "Removing all Docker volumes..."
	@docker compose -f $(COMPOSE_FILE) down -v --rmi all
	@docker volume prune -f

nuke: clean
	@docker system prune -a
	sudo rm -rf ~/data/db/* 
	sudo rm -rf ~/data/wp/* 

re: nuke up

.PHONY: up down clean
