# OneBitBot

This project has the purpose of learning new skills. The project was developed following the lessons of bootcamp [OneBitCode](http://onebitcode.com/), with exception of some features that was developed for to conclude the challenges proposed.

## Pre-requisites

- [Docker](https://docker.com)
- [Docker Compose](https://docs.docker.com/compose)

## Getting Started

To build this project. Make sure you have the [Docker](https://docker.com) installed on your machine.

#### Cloning the project

```bash
git clone https://github.com/rands0n/onebitbot.git && cd onebitbot
```

To build using Docker, run:

```bash
docker-compose build && docker-compose run --rm app bundle install
```

And to open up the app, run:

```bash
docker-compose up
```

### Initialization

To create our database, use `rails db:create`. After that you can migrate all the tables availables with `rails db:migrate`

To create the database inside docker:

```bash
docker-compose run --rm app rake db:create
```

And running all the migrations inside docker:

```bash
docker-compose run --rm app rake db:migrate
```

## Tests

To run our tests, simply put the `rspec` command on terminal.

