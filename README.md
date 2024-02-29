# footballai-back

* Ruby version: 3.3.0

## Rails Server

|Development|Production|
|-----------|---------------------------------|-------------------------------------------|
| start|docker-compose -f docker-compose.dev.yml up -d|docker-compose -f docker-compose.prod.yml up -d|
| stop|docker-compose -f docker-compose.dev.yml down -v|docker-compose -f docker-compose.prod.yml down -v|
