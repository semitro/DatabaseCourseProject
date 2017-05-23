#! /bin/bash

# Functions
ack 'function\s+[^(]+' --output "drop $& $';" scripts/functions.sql > scripts/dfunctions.sql
sed -i 's/ default [^,)]*//g' scripts/dfunctions.sql

# Tables
ack -i 'create table ([^(]+)' --output 'drop table $1;' scripts/createtables.sql | tac > scripts/dtables.sql

# Indexes
ack -i 'create index (\w+)' --output 'drop index $1;' scripts/indexes.sql > scripts/dindexes.sql

# Data
ack -i 'create table ([^(]+)' --output 'delete from $1;' scripts/createtables.sql > scripts/ddata.sql

# Everything
cat > scripts/deverything.sql <<EOF
\ir dfunctions.sql
\ir dindexes.sql
\ir dtables.sql
EOF
