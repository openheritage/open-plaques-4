export PGPASSWORD=postgres
dropdb -h postgres -U postgres openplaques_development
createdb -h postgres -U postgres openplaques_development
pg_restore -h postgres -U postgres -d openplaques_development latest.dump
createdb -h postgres -U postgres openplaques_test
