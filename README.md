## Deploy code change
###
- `$ make prod_first_deploy` - for the first time, this will:
  1. Deploy the latest code
  2. Run db migrations
  3. Seed the database with dummy records
- `$ make prod_deploy` - for the continuous deployments, this will:
  1. Deploy the latest code
  2. Run db migrations
## Run tests
- `$ rspec .` - to run all the tests defined in `./spec/*`
- `$ rspec spec/**/**_spec.rb` - to run sepcific tests
- `$ rspec spec/**/**_spec.rb:Line` - to run sepcific tests at line number

## Communicate with the server apis using OAuth
- Obtain credentials from production server:
  1. `$ heroku run rails c -a rent-a-house-backend`
  2. `Doorkeeper::Application.first.uid`
  3. `Doorkeeper::Application.first.secret`
- Use `uid` value as `client_id` in the request body
- Use `secret` value as `client_secret` in the request body
