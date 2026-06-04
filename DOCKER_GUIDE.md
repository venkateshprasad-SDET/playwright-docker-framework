# Playwright Docker Integration Guide

This guide explains how to build and execute Playwright tests in Docker using the configuration files provided.

---

## Prerequisites

- **Docker Desktop** installed and running on your system.
- **Node.js** installed on your host machine (only needed to view reports/allure results locally).

---

## 1. Build the Docker Image

Build the Docker image using Docker Compose. This prepares the container environment and installs the required packages (including build prerequisites and Playwright dependencies):

```bash
docker-compose build
```

---

## 2. Run Tests

### Run the Default Suite
By default, this will execute `npm run test` inside the container:

```bash
docker-compose up
```

### Run a Specific Script
You can override the default execution command to run different test profiles or linting scripts defined in `package.json`:

* **Run all tests in suite project:**
  ```bash
  docker-compose run --rm playwright npm run test
  ```

* **Run local/debug tests:**
  ```bash
  docker-compose run --rm playwright npm run local:test
  ```

---

## 3. Override Environment Variables

You can override any environment variable on the fly without changing your local `.env` file:

* **Run tests using Firefox instead of Chrome:**
  ```bash
  docker-compose run --rm -e BROWSER=firefox playwright
  ```

* **Run a specific test file by overriding the name filter:**
  ```bash
  docker-compose run --rm -e TEST_NAME=LoginTest playwright npm run local:test
  ```

---

## 4. View Test Reports Locally

Because the `./test-results` and `./allure-results` directories are mounted as volumes, all files generated during Docker test execution are written directly to your Windows host machine.

To view HTML and Allure reports on your local machine:

1. Run the Allure reporter on your host:
   ```bash
   npm run report
   ```
2. Open the default Playwright HTML report on your host:
   ```bash
   npx playwright show-report ./test-results/report
   ```

---

## 5. Connecting to Host Databases

If your tests connect to a database (like MS SQL, DB2, or Oracle) running on your local Windows machine:
1. The container cannot resolve `localhost`.
2. Instead, use `host.docker.internal` in your `DB_CONFIG` inside `.env`:
   ```env
   DB_CONFIG=Server=host.docker.internal,1433;Database=AutomationDB;User Id=SA;Password=Auto2021
   ```
3. Docker Compose is already configured with `extra_hosts` to route `host.docker.internal` to your host machine's gateway automatically.
