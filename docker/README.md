# Containerized TXRonaParser, MariaDB backend, and Grafana frontend.

## Setup
1. Create the required envs:
- GF_SECURITY_ADMIN_PASSWORD (grafana admin passwordc)
- MYSQL_ROOT_USER (This must be 'root')
- MYSQL_ROOT_PASSWORD
- MYSQL_USER
- MYSQL_PASSWORD
- MYSQL_DB
- MYSQL_HOST

2. Run `docker-compose up -d`
3. If everything works, Grafana will be available on http://localhost:3000.

## Outstanding Items
- research .my.cnf alternatives
- dashboards, dashboards, dashboards!
- testing cron job to restart the 'txronaparser' service to grab updated data.
