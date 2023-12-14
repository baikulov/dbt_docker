# Working with dbt in Docker

Before you start, make sure you have GIT and Docker installed on your local machine.

1. Clone the GitHub repository to your local machine.

2. Rename the file private_ssh_key.example to private_ssh_key and paste your private SSH key into it.

3. Rename the file .env.example to .env and set the values.

4. Run the container:
```bash
    docker-compose up -d
```

5. Visit http://localhost:8080/ and start working.

6. After finishing your work, stop the container:
```bash
    docker-compose down
```

7. Additional commands:
```bash
    docker ps -a // Show all containers
    docker stop <container_name> // Stop a container
    docker rm <container_name> // Remove a container
```

## IMPORTANT

1. Run all commands from the root folder.
2. Commit all changes to GIT immediately. The container will lose all local changes if stopped.