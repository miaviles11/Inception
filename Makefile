NAME		= inception

CYAN		= \033[0;96m
GREEN		= \033[0;32m
YELLOW		= \033[0;33m
RED			= \033[0;31m
RESET		= \033[0m

COMPOSE		= srcs/docker-compose.yml
DATA		= /home/$(USER)/data

all: up

up:
	@mkdir -p $(DATA)/wordpress $(DATA)/mariadb
	@echo "$(CYAN)Building and starting containers...$(RESET)"
	@docker-compose -f $(COMPOSE) up -d --build
	@echo "$(GREEN)✓ Inception is up!$(RESET)"

down:
	@echo "$(YELLOW)Stopping containers...$(RESET)"
	@docker-compose -f $(COMPOSE) down

start:
	@docker-compose -f $(COMPOSE) start

stop:
	@docker-compose -f $(COMPOSE) stop

restart: stop start

clean: down
	@docker-compose -f $(COMPOSE) down -v

fclean: clean
	@echo "$(RED)Full cleanup...$(RESET)"
	@docker system prune -af --volumes
	@sudo rm -rf $(DATA)/wordpress $(DATA)/mariadb
	@echo "$(GREEN)✓ Everything cleaned$(RESET)"

re: fclean all

logs:
	@docker-compose -f $(COMPOSE) logs -f

ps:
	@docker-compose -f $(COMPOSE) ps

status:
	@echo "$(CYAN)Container Status:$(RESET)"
	@docker-compose -f $(COMPOSE) ps
	@echo "\n$(CYAN)Volumes:$(RESET)"
	@docker volume ls | grep $(USER)

sh-nginx:
	@docker-compose -f $(COMPOSE) exec nginx sh

sh-wordpress:
	@docker-compose -f $(COMPOSE) exec wordpress sh

sh-mariadb:
	@docker-compose -f $(COMPOSE) exec mariadb sh

.PHONY: all up down start stop restart clean fclean re logs ps status \
		sh-nginx sh-wordpress sh-mariadb
