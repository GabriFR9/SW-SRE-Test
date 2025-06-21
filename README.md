# Rails App with Dockerized Monitoring Stack

This project contains a Ruby on Rails application working with PostgreSQL and Redis databases and all of them containerized with Docker and extended with a complete monitoring stack using Prometheus, Grafana as well as Redis Exporter, PostgreSQL Exporter, and Alertmanager.

---

## Infrastructure Overview

The infrastructure is fully containerized using **Docker Compose**, allowing seamless orchestration of multiple services:

- **Rails App** – The core web application.
- **PostgreSQL** – Primary relational database.
- **Redis** – In-memory data store.
- **Prometheus** – Metrics collection and storage.
- **Grafana** – Visualization of metrics and alert statuses.
- **Alertmanager** – Routing and notification of alerts.
- **Exporters** – Specialized exporters for Redis, PostgreSQL, and Rails metrics.

All services communicate through a shared Docker network and are defined in a single `docker-compose.yml` file to ensure consistency and portability.

---

## Tech Stack

* Ruby 3.2

* Rails 8

* PostgreSQL 14

* Redis 7

* Prometheus

* Grafana

* Alertmanager

* Docker + Docker Compose

---

## Starting the Application

1. **Install Docker**:

   Official website: https://docs.docker.com/get-started/get-docker/

2. **Clone the repository**:

   ```bash
   git clone https://github.com/GabriFR9/SW-SRE-Test
   cd SW-SRE-Test
   ```

3. **Create files secrets.env and postgres_pass.txt in local**:

   ```bash
   touch secrets.env
   touch postgres_pass.txt
   ```
   Fill them with the following content:

    _secrets.env_
   ```
    DATABASE_USERNAME=<DB_user>
    DATABASE_PASSWORD=<DB_user_password>
    DATABASE_HOST=<DB_host>
    REDIS_URL=redis://redis:6379/0
    ```

     _postgres_pass.txt_
   ```
    <DB_user_password>
    ```
    **NOTE**: MUST be the same as DATABASE_PASSWORD in secrets.env

4. **Start all services with Docker Compose**:

   ```bash
   docker-compose up --build
   ```

5. **Access services**:

* Rails App: http://localhost:3000

* Prometheus: http://localhost:9090

* Grafana: http://localhost:3001

6. **Prometheus and Grafana config**:

- Check that every service is UP in Prometheus console --> Status --> Target health.
- Inside Grafana console, go to Data sources and add Prometheus as data source:
    - In the data source URL indicate: ```http://prometheus:9090``` so that the Grafana container connect to the Prometheus container.
- Add Dashboards to check the Rails, PostgreSQL and Redis services:
    - Import them as JSON files using the Grafana console, go to Dashboards, create a new one and import it as JSON file from the repository path: ```./grafana/provisioning/dashboards```

---

## Observability, monitoring and alerting

The system collects and tracks various metrics from the Rails application and databases to ensure reliability, performance, and availability. These metrics are exposed below:

### Rails Application Metrics

Collected using ```prometheus_exporter``` middleware:

* ```up``` – Check application status (Up or Down).

* ```process_resident_memory_bytes``` – Monitors memory usage to avoid exceeding RAM through memory leaks.

* ```process_cpu_seconds_total``` – Measures CPU time used by Rails. It's useful for detecting performance issues or CPU-bound behavior.

### Redis Metrics

Exposed via ```redis_exporter```:

* ```up``` – Check Redis database status (Up or Down).

* ```redis_connected_clients``` – Shows current client connections. Useful to check the DB load or misuses.

* ```redis_memory_used_bytes``` – Measures current memory usage for key eviction risk.

* ```redis_keyspace_hits_total / (redis_keyspace_hits_total + redis_keyspace_misses_total)``` – Redis server hit rate (efficiency of reads).

### PostgreSQL Metrics

Exposed via ```postgres_exporter```:

* ```pg_up``` – Check PostgreSQL database status (Up or Down).

* ```pg_stat_activity_count``` – Measures total number of active connections to the database. Useful to check the DB load

* ```pg_database_size_bytes``` – Tracks DB size growth.

* ```pg_stat_database_blks_hit / (pg_stat_database_blks_hit + pg_stat_database_blks_read``` – Buffer cache hit rate (efficiency of reads).

---

## Behaviour of Key Services

This section outlines the expected operational behavior of the core services under monitoring, including thresholds and response guidelines.

### Rails App

* The Rails app exposes a ```/metrics``` endpoint by default via the ```prometheus_exporter``` gem and a ```/up``` endpoint for health checks available in Prometheus console.

* Under normal conditions, CPU and memory usage should remain relatively stable and proportional to request load.

### Redis

* Redis should operate with minimal latency, storing frequently accessed keys in memory.

* Connections and memory usage should remain stable under typical load.

### PostgreSQL Database

* PostgreSQL should serve queries within expected latency ranges and maintain stable connection usage.

* Disk size should grow predictably with data ingestion.

---

## Further Security Improvements

There are possible improvements in terms of security for non-development environments.

The Rails application needs to know the configuration data to get access to the PostgreSQL database as well as the Redis URL. This is sensitive information stored in the file ```secrets.env``` that has been mounted into a new file in the path ```/run/secrets/my_app.env``` inside the web container (Rails container). This way, Rails is able to retrieve this information as environment variable through the ```hello-world-rails.sh``` script inside the container, avoiding the possibility of making visible the sensitive data through ```docker inspect``` command.

For PostgreSQL the approach to pass the DB information is similar to Rails as a file to store the password has been used, called ```postgres_pass.txt``` which content will be mounted in the container in the path ```/run/secrets/postgres_pass``` as a secret, so that it can not be read using ```docker inspect```.

However, although this is legit and the sensitive information is not shared in the repository, any process with container access could run a command like ```cat /run/secrets/postgres_pass``` and the secret content would be revealed. For production or non-development environments in general, it is recommended to use other solutions like Docker Swarm or even cloud storage services to get the secrets during the container execution time.

Furthermore, the ```/config/master.key``` has been uploaded to the repository only for testing purposes and make the project easier to run as this set up is not intended to work on production environment and the intention is to be run locally only.
For Production environments is would be a good fit to use a cloud storage service to keep the content of the ```master.key``` secure and add it as environment variable to the container set up when using CI/CD to deploy the application. 