#!/bin/bash

sudo service apache2 status | grep -q "Active: inactive"
APACHE_UP=$?

sudo service postgresql status | grep -q "Active: inactive"
POSTGRESQL_UP=$?

sudo service supervisor status | grep -q "Active: inactive"
SUPERVISOR_UP=$?

UP=$((APACHE_UP + POSTGRESQL_UP + SUPERVISOR_UP))

echo $UP
