# localdb

Run various databases and admin UIs using Docker with the provided
compose file:

- CloudBeaver
- Dynamo DB (local)
- ElasticSearch (todo)
- MySQL
- Postgres
- PgAdmin
- Solr (todo)

The idea is to centralize database access for multiple projects
rather than using per project compose files and having multiple
instances of the same databases running.

## Usage

Running containers:

```bash
# foreground
docker compose up # run everything in the foreground
docker compose up pg # postgres only
docker compose up pgadmin # pgadmin + postgres

# background
docker compose up -d # run everything in the background
docker compose logs -f # follow logs for containers in the background

docker compose up -d pg # postgres only in the background
docker compose up -d pgadmin # pgadmin + postgres in the background
```

Stopping & removing containers:

```bash
docker compose down # stop and remove everything

docker compose down pg # pg only
docker compose down pgadmin # pgadmin only
```

## Config

- See the `.env` file for the default values
- Create `.env.local` to supply custom configuration

## Data

These volumes are used to store data:

- cb-data
- ddb-data
- es-data (todo)
- mysql-data
- pg-data
- pgadmin-data
- solr-data (todo)

This way stopping and removing containers is not destructive. Running
the containers again will resume with data persisted. Take down the
containers and blow away the volumes to start over.

```bash
docker compose down
docker volume rm \
    cb-data \
    ddb-data \
    mysql-data \
    pg-data \
    pgadmin-data
```

## Backup and restore volumes

```bash
./backup.sh
```

This:

- Stops all containers
- Snapshots all volumes
- Stores backups under `./backups/<timestamp>/`

```bash
./restore $DATE
```

This:

- Stops all containers
- Recreates volumes
- Restores volume contents

__Containers are NOT automatically restarted after backup or restore.__
