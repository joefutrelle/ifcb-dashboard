#!/bin/bash

service postgresql start 2>/dev/null
service apache2 start 2>/dev/null
service supervisor start 2>/dev/null
