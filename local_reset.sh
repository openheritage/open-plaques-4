export PGPASSWORD=postgres
dropdb -h postgres -U postgres openplaques_development --if-exists
dropdb -h postgres -U postgres openplaques_test --if-exists
