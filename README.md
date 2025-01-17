# guess-all

* Ruby version: 3.3.0

## Rails Server

| Environment | Start Command| Stop Command|Destroy container|
|-|-|-|-|
| Development | `make dev` `make dev-d`|`make dev-stop`|`make dev-destroy`|
| Production  | `docker-compose -f docker-compose.prod.yml up -d`  | `docker-compose -f docker-compose.prod.yml down -v` |


## For test in dev on other devices (like phones, tablet, ...) you can user your local machine ip. es: 192.168.1.XXX:3000
