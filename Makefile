#based https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
#bades https://unix.stackexchange.com/questions/235223/makefile-include-env-file
include .env.dev
export $(shell sed 's/=.*//' .env.dev)

.PHONY: help

help: ## show this help
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

dcu: ## Run docker-compose up --build -d
	docker-compose up -d --build

dcd: ## Run docker-compose down -v
	docker-compose down -v

dcs: ## Run docker-compose stop
	docker-compose stop

dcl: ## Run docker-compose logs -f 
	docker-compose logs -f

dcsu: dcs dcu ## Run docker-compose stop && up

dcsul: dcs dcu dcl ## Run docker-compose stop && up && logs

backup-db: ## backup database in repo
	docker-compose exec -u root db chmod -R 777 /opt/backup
	docker-compose exec db /opt/scripts/backup.sh

restore-db: ## restore database from repo
	docker-compose exec db /opt/scripts/restore.sh

start-stack: dcsu restore-db dcl ## initialize stack running all necessary scripts

exec-db: ## run dodcker-compose exec db bash
	docker-compose exec db bash