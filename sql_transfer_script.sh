
heroku pg:backups capture --app visitman

curl -o latest.dump `heroku pg:backups public-url --app visitman`

pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d visitman latest.dump

