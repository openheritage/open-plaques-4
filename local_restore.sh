heroku pg:backups capture --app open-plaques-beta
rm latest.dump
heroku pg:backups:download --app open-plaques-beta
dropdb -h postgres -U postgres openplaques_development
createdb -h postgres -U postgres openplaques_development
pg_restore -h postgres -U postgres -d openplaques_development latest.dump
createdb -h postgres -U postgres openplaques_test
bin/rails db:environment:set
