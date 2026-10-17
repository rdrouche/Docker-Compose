docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgresql > init/initdb.sql
mkdir -p data/postgresql
chown -R 999:999 data/postgresql
mkdir -p data/guacd/drive
mkdir -p data/guacd/record
chown -R 1000:1001 ./data/guacd
chmod -R 770 ./data/guacd
