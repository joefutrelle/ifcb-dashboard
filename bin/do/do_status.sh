#!/bin/bash

sudo service apache2 status | grep -q "not"
APACHE_UP=$?

sudo service postgresql status | grep -q "down"
POSTGRESQL_UP=$?

sudo service supervisor status | grep -q "not"
SUPERVISOR_UP=$?

UP=$((APACHE_UP + POSTGRESQL_UP + SUPERVISOR_UP))

echo $UP
