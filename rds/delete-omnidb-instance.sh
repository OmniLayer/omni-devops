#!/bin/sh
rds-delete-db-instance $OMNI_DB_INSTANCE --skip-final-snapshot --force
