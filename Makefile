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
	@docker system prune
	sudo rm -rf ~/data/db/* 
	sudo rm -rf ~/data/wp/* 
	sudo rm -rf ~/data/redis/* 
	sudo rm -rf ~/data/adminer/* 

nukere: nuke up

re: down up

push:
	git add * && git commit -m "aa" && git push && git status

pull:
	git pull

.PHONY: up down clean
