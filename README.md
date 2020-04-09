# ms-dbo-mongo

REST API for dbo database

## Pre Requisites

* Install [stack]
* Install [dotenv]
* Install [mongoDB]

## Setup and installation

* clone this repo and build the project

```
$ git clone git@github.com:juris-futura/ms-dbo-mongo.git
$ cd ms-dbo-mongo
$ stack build
```

## Running migrations

TODO: Pending

## Run the server

* copy the `.env.example` to the `.env` file
* edit `.env` according to your needs
* run the server using `dotenv`

```
$ dotenf -f .env stack run
```

* the server should be running on the port that you configured. You can test it using curl:

```
curl localhost:3000/healthcheck
```

## Running tests

```
$ stack test
```

You can also use this [postman collection](https://github.com/juris-futura/ms-dbo-mongo/blob/c58d85944be8bf314ba8481ad3f6ef3d01976ae6/HH.postman_collection.json)


[stack]: https://docs.haskellstack.org/en/stable/install_and_upgrade/
[mongoDB]: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/#install-mongodb-community-edition
[dotenv]: https://hackage.haskell.org/package/dotenv
