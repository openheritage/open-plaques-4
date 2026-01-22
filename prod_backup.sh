export PGPASSWORD=postgres
heroku pg:backups:capture --app open-plaques-beta
rm latest.dump
heroku pg:backups:download --app open-plaques-beta
