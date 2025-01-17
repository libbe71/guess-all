dev:
	@docker compose -f docker-compose.dev.yml up
dev-d:
	@docker compose -f docker-compose.dev.yml up -d
dev-stop:
	@docker compose -f docker-compose.dev.yml stop
dev-destroy:
	@docker compose -f docker-compose.dev.yml down -v
dev-logs: 
	@docker compose -f docker-compose.dev.yml logs web -f