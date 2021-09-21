# README

This project is part of Kinside code challange.

## Environment
This code is executed under the following versions:
- ruby 2.7.4p191
- Rails 6.1.4.1
- PostgreSQL 13.4
- MacOS 10.15.7

## Execution
To properly run this code you need to:

1. Have postgres server running
2. Run the following commands into Postgres:
```
CREATE USER kinside_user WITH PASSWORD <user_password>
ALTER USER kinside_user SUPERUSER
```
3. Once the user is created, you need first export some environment variables in your terminal tab:
```
> export DB_PASSWORD=<user_password>
> export RAILS_ENV=production
```
4. Once this is done, you can run the following commands:
```
> rails db:setup    # To create the database
> rails db:migrate  # To create the tables
```
5. With the database setup, you can just run the server:
```
> rails s
```

## Available APIs
The available APIs for this project are the following:

### http://localhost:3000/api/v1/init

This API is to initialize the tables ```Movies``` and ```Actors``` with the content from external API given by kinside.

### http://localhost:3000/api/v1/movies?ids=

This API can be used in two different ways:

- Calling without the query parameters defined by ```?ids=```, which will return all movies raw from the database.

- Another option is, specifying the ```?ids=``` parameter, the API will return the information from the movies for the given ids with the actors information as well.

### http://localhost:3000/api/v1/actors?ids=

This API can be used in two different ways:

- Calling without the query parameters defined by ```?ids=```, which will return all actors raw from the database.

- Another option is, specifying the ```?ids=``` parameter, the API will return the information from the actors for the given ids, in addition to the top 5 co-actors for each actor ID.



