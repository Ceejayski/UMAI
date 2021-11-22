# UMAI API Test
It is required to create a JSON API service in Ruby with Ruby on Rails.
## General
Entities: The platform is split into 4 main components.
1. User - has only a login authenticated using JWT tokens.
2. The Post - it belongs to the user. Has a title, content, author's IP (saved separately for each post).
3. Rating - belongs to the post. Accepts a value from 1 to 5.
4. feedback. It accepts user_id or post_id, comment, owner_id - Check if post or user already have a feedback from same owner - Return feedback list form same owner

### Setup

We use Docker to prepare a local environment.

#### Using Docker

Install [Docker](https://docs.docker.com/install/) and
[Docker Compose](https://docs.docker.com/compose/install/) first.

1. Run `docker-compose build app`
2. Run `docker-compose up`
3. Run migrations `docker-compose run --rm app rake db:migrate`
4. Open your browser and navigate to `http://localhost:3000`

To run the tests use:

```bash
$ docker-compose run --rm -e RAILS_ENV=test app rake
```

### Get a local copy

`$ git clone https://github.com/Ceejayski/UMAI`

### Initial Setup

- Go to the local repo and run `bundle install`

### Database Setup:
- First run `rails db:create`
- Then run `rails db:migrate`

### Start server:
- Run `rails server`

- Go to `http://localhost:3000/`



# Run tests
- Run `rails db:migrate RAILS_ENV=test`

- Run  ```bundle exec rspec ``` to run the tests.


# Author

👤 **Okoli Chijioke**

- Github: [@ceejayski](https://github.com/ceejayski)

- LinkedIn: [LinkedIn](https://www.linkedin.com/in/okoli-ceejay/)


## 🤝 Contributing

Contributions, issues and feature requests are welcome!
