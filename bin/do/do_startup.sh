#!/bin/bash

sudo service postgresql start 2>/dev/null
sudo service apache2 start 2>/dev/null
sudo service supervisor start 2>/dev/null
