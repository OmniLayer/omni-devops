#!/bin/sh
BACKUP_RET_PERIOD="0"  # No backups for test server
rds-create-db-instance $OMNI_DB_INSTANCE            \
    --engine postgres                               \
    --engine-version 9.3.3                          \
    --db-instance-class db.t2.micro                 \
    --allocated-storage 5                           \
    --publicly-accessible true                      \
    --vpc-security-group-ids $OMNI_DB_SEC_GID       \
    --backup-retention-period $BACKUP_RET_PERIOD    \
    --master-username $PGUSER                       \
    --master-user-password $PGPASSWORD

