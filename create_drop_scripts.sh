#! /bin/bash

# Functions
ack --ignore-case 'function\s+[^(]+' --output "drop $& $';" scripts/functions.sql > scripts/dfunctions.sql
sed --in-place 's/ default [^,)]*//g' scripts/dfunctions.sql

# Tables
ack --ignore-case 'create table ([^(]+)' --output 'drop table $1;' scripts/createtables.sql | tac > scripts/dtables.sql

# Indexes
ack --ignore-case 'create index (\w+)' --output 'drop index $1;' scripts/indexes.sql > scripts/dindexes.sql

# Data
ack --ignore-case 'create table ([^(]+)' --output 'delete from $1;' scripts/createtables.sql > scripts/ddata.sql

# Triggers
ack --ignore-case 'create trigger\s+(\w+).*?on\s+(\w+)' --output 'drop trigger $1 on $2;' scripts/triggers.sql > scripts/dtriggers.sql
ack --ignore-case 'function\s+[\w]+' --output "drop $& $';" scripts/triggers.sql >> scripts/dtriggers.sql

# Everything
cat > scripts/deverything.sql <<EOF
\ir dfunctions.sql
\ir dtriggers.sql
\ir dindexes.sql
\ir dtables.sql
EOF
