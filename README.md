# Shogyo
Multi-Sided Platform for sellers and buyers with Gamification Levels and Achivements, includes a Blog, Consults like forum, and it's own simple Ads system.

# DEMO
[Shogyo](https://shogyo.geekoi.com) - Test the web app


# TECHNOLOGIES USED AND CHALLENGES
* Ruby;
    * Version 2.7.1;
* Rails;
    * Version 6.1;
* AngularJS;
    * Legacy;
    * This app has a Trello like interface for dealing with the Funnels and Sales
* PostgreSQL;
    * 13;
* Elasticsearch;
    * 7

# MODULES & FUNCTIONALITIES
* Feed of products, consults and more;
* Market and search functionalities with Elasticsearch;
* Question between seller and buyer;
* Ratings for both seller and buyer;
* Gamification with Points, Levels and Achivements.
* Blog
* Consults or Forum
* Email and Push notifications
* Favorites
* Dashboard, Account and Profile
* RestAPI
* Test data seed with Faker.


# SOME SCREENSHOTS
![screen1](https://shogyo.geekoi.com/shogyo1.png)
![screen2](https://shogyo.geekoi.com/shogyo2.png)
![screen3](https://shogyo.geekoi.com/shogyo3.png)
![screen4](https://shogyo.geekoi.com/shogyo4.png)
![screen5](https://shogyo.geekoi.com/shogyo5.png)

# HOW TO INSTALL

```ruby
# 1. Clone the repo and install Elasticsearch if not already installed

git clone https://github.com/MakarovCode/Shogyo.git

# 2. Run bundle

bundle

# 3. Run the DB

rails db:create db:migrate db:seed

# 4. Make sure to install the unaccent function in PostgreSQL

psql YourDataBaseName

# SQL
CREATE EXTENSION unaccent;

# Type localhost:3000

```

# DISCLAIMER
I DO NOT give support to this project any more, you are free to use the code in anyway you want, is free to use, but this web application as it is may present Bugs and Errors.

I developed this project several years ago, I kept a DEMO but is not getting supported, some libraries and dependencies maybe deprecated, the only technologies I updated were Ruby, Rails and PostgreSQL.
