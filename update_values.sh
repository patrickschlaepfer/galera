#!/usr/bin/bash

helm upgrade -f values.yaml mariadb-galera-new \
  bitnami/mariadb-galera \
  --reuse-values 

