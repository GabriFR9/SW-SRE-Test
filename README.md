# Rails App with Dockerized Monitoring Stack

This project contains a Ruby on Rails application working with PostgreSQL and Redis databases and all of them containerized with Docker and extended with a complete monitoring stack using Prometheus, Grafana as well as Redis Exporter, PostgreSQL Exporter, and Alertmanager.

---

## 📦 Infrastructure Overview

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

## 🚀 Starting the Application

1. **Install Docker**:

   ```bash
   Official website: https://docs.docker.com/get-started/get-docker/

2. **Clone the repository**:

   ```bash
   git clone https://github.com/your-org/your-repo.git
   cd your-repo


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
