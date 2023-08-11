#!/bin/bash

# Clone the repository from github.ibm.com
git clone https://github.com/rishi-patel1/DatabaseChangeManagement.git

# Copy SQL files from cloned repository
cp /DatabaseChangeManagement/sql/*.sql $FLYWAY_HOME/sql/

# Perform the rest of your entrypoint commands
cp -f /var/flyway/data/*.sql  $FLYWAY_HOME/sql/
ls -a $FLYWAY_HOME/sql/
$FLYWAY_HOME/flyway baseline migrate info  -user=${DB_USER} -password=${DB_PASSWORD} -url=${DB_URL}
