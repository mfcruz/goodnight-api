# GOODNIGHT-API
a simple api app to track sleep time

## Features

- User Create and Index
- Users can Follow And Un-follow Each Other
- Users can Clock-In and Clock-out to track sleep time
- Users can view friends previous week's sleep time records in order of sleep duration

## Technologies and Gems used

- Ruby on Rails (Ruby: 3.2.2, Rails: 7.0.4.3)
- Test: rspec, factory_bot_rails, shoulda-matchers
- Database: Postgres 14

## How to run locally
- Ensure Ruby on Rails, Postgres, Git and other prerequisites are installed properly
- You can use your desired poster to connect to api

```sh
# Clone Repository
git clone git@github.com:mfcruz/goodnight-api.git

# Go to Folder
cd ./goodnight-api

# Run bundle to install dependencies
bundle

# Create Database
rails db:create

# Run migration
rails db:migrate

# Start the server
rails s
```

## Run Specs

```sh
bundle exec rspec
```

## APIs List

| No. | End Point                                            | Request Type | Description                                    |
| --- | ---------------------------------------------------- | ------------ | ---------------------------------------------  |
| 1.  | /api/v1/users?name="NAME"                            | POST         | Create User                                    |
| 2.  | /api/v1/users                                        | GET          | List Users                                     |
| 3.  | /api/v1/users/:user_id/follow/:followee_id           | POST         | Follow User                                    |
| 4.  | /api/v1/users/:user_id/unfollow/:followee_id         | DELETE       | Un-Follow User                                 |
| 5.  | /api/v1/users/:user_id/followees/sleep_records       | GET          | User's Followees' Last Week Sleep Time Records |
| 6.  | /api/v1/users/:user_id/sleep_times/clock_in          | POST         | Clock In Event                                 |
| 7.  | /api/v1/users/:user_id/sleep_times/clock_out         | PATCH        | Clock Out Event                                |

## TODO
- User authentication
- Services for next version
