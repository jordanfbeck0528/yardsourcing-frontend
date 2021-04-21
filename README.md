# Yardsourcing

Have you ever been sitting in your 5th floor apartment wishing you could bask in the sun on a lawn chair? Now you can and you don't even need to leave your city! Do you need some spare cash and have own a private outdoor space? If you answered yes to either of these quetions, you need **Yardsourcing**!

Yardsourcing is a web application that allows users to create accounts via Google login, browse yards available for rent by location or list their own outdoor space! Whether you need a pet friendly yard, a party yard or a place to do your outdoor hobby - Yardsourcing has you covered!

*Turn your extra green into green.*

### Created by:
- [Alexa Morales Smyth](https://github.com/amsmyth1) | [LinkedIn](https://www.linkedin.com/in/moralesalexa/)
- [Genevieve Nuebel](https://github.com/Gvieve) | [LinkedIn](https://www.linkedin.com/in/genevieve-nuebel)
- [Dominic Padula]() | [LinkedIn]()
- [Jenny Branham](https://github.com/jbranham1) | [LinkedIn](https://www.linkedin.com/in/jenny-branham)
- [Jordan Beck](https://github.com/jordanfbeck0528) | [LinkedIn](https://www.linkedin.com/in/jordan-f-beck/)
- [Angel Breaux](https://github.com/abreaux26) | [LinkedIn](https://www.linkedin.com/in/angel-breaux)
- [Doug Welchons](https://github.com/DougWelchons/) | [LinkedIn](https://www.linkedin.com/in/douglas-welchons)

#### Built With
* [Ruby on Rails](https://rubyonrails.org)
* [HTML](https://html.com)
* [JavaScript](https://www.javascript.com)
* [Bootstrap](https://getbootstrap.com/)

This project was tested with:
* RSpec version 3.10

## Contents
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installing](#installing)
- [Database Schema](#database-schema)  
- [Application Features](#application-features)
  - [OmniAuth and Google](#omniauth-and-google-integrations)
- [Testing](#testing)
- [How to Contribute](#how-to-contribute)
- [Roadmap](#roadmap)
- [Contributors](#contributors)
- [Acknowledgments](#acknowledgments)

### Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

#### Prerequisites

* __Ruby__

  - The project is built with rubyonrails using __ruby version 2.5.3p105__, you must install ruby on your local machine first. Please visit the [ruby](https://www.ruby-lang.org/en/documentation/installation/) home page to get set up. _Please ensure you install the version of ruby noted above._

* __Rails__
  ```sh
  gem install rails --version 5.2.5
  ```

* __Postgres database__
  - Visit the [postgresapp](https://postgresapp.com/downloads.html) homepage and follow their instructions to download the latest version of Postgres app.

* __Google Oauth API__
  - Visit the [google developer tools](https://console.developers.google.com/project) to create an account and follow the instructions to create a project for your server to obtain a client_id and client_secret.

* __Omniauth for Rails__
  Visit the [google api omniauth](https://www.twilio.com/blog/2014/09/gmail-api-oauth-rails.html) homepage and follow their instructions to get familiar with how to use Omniauth in a rails application.


#### Installing

1. Clone the repo
  ```
  $ git clone https://github.com/Yardsourcing/yardsourcing-frontend
  ```

2. Bundle Install
  ```
  $ bundle install
  ```

3. Create, migrate and seed rails database
  ```
  $ rails db:{create,migrate,seed}
  ```

  If you do not wish to use the sample data provided to seed your database, replace the commands in `db/seeds.rb` and the data dump file in `db/data/rails-engine-development.pgdump`.

  4. Create your google environment variables. Run the below command to create an application.yml that is included in the .gitignore file.
  ```sh
  $ bundle exec figaro install
  ```

  5. Open the application.yml file in your text editor, in the example below it is using atom as the text editor.
  ```sh
  $ atom config/application.yml
  ```

  6. Inside of the application.yml create the environment variables for your google client_id and client_secret as. At the bottom of the file enter the following:
  ```
  GOOGLE_CLIENT_ID: '13023404400-n1orn9rntvifnqffcj45rbji69b7bq1v.apps.googleusercontent.com'
  GOOGLE_CLIENT_SECRET: 'zx8ecS0uBkPAMmh207pIPIZE'
  ys_engine_url: 'http://localhost:3001'
  mapquest_key: 'SHKnstA5dZDGGsyGX1AkAan6iEbUWUE8'
  ```

  7. Start rails server
  ```sh
  $ rails s
  ```

### Database Schema

<img src="Schema_yardsourcing.png" width="400">

### Project Architecture

<img src="ys_design.png" width="600">


### Application Features

##### OmniAuth and Google Integrations
- OmniAuth and Google Integration

##### Host Yard Create, Delete, Update
- About this feature  

##### Yard Search
- About this feature  

##### Renting a yard (Create a booking)
- About this feature  

##### Renter Dashboard
- About this feature  

##### Host Dashboard
- About this feature  

##### Email booking updates
- About this feature  


### Testing
##### Running Tests
- To run the full test suite run the below in your terminal:
```
$ bundle exec rspec
```
- To run an individual test file run the below in tour terminal:
```
$ bundle exec rspec <file path>
```
for example: `bundle exec rspec spec/features/host/dashboard/index_spec.rb`

### How to Contribute

In the spirit of collaboration, things done together are better than done on our own. If you have any amazing ideas or contributions on how we can improve this API they are **greatly appreciated**. To contribute:

  1. Fork the Project
  2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
  3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
  4. Push to the Branch (`git push origin feature/AmazingFeature`)
  5. Open a Pull Request

### Roadmap

See the [open issues](https://github.com/Yardsourcing/yardsourcing-frontend/issues) for a list of proposed features (and known issues). Please open an issue ticket if you see an existing error or bug.

### Contributors
- [Alexa Morales Smyth](https://github.com/amsmyth1)
- [Genevieve Nuebel](https://github.com/Gvieve)
- [Dominic Padula]() [LinkedIn]()
- [Jenny Branham](https://github.com/jbranham1)
- [Jordan Beck](https://github.com/jordanfbeck0528)
- [Angel Breaux](https://github.com/abreaux26)
- [Doug Welchons](https://github.com/DougWelchons/)

  See also the list of
  [contributors](https://github.com/Yardsourcing/yardsourcing-frontend/graphs/contributors)
  who participated in this project.

### Acknowledgments
  - Our fantastically wizard like Project Manager and Instructor at [Turing School of Software and Design](https://turing.io/):
    * Ian Douglas
