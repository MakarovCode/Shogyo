# Hanbai
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

# MODULES & FUNCTIONALITIES
* Manage companies records;
* Manage clients records;
* Funnel Trello like interface for creating and managing fully customized funnels;
    * Create and customize
        * Teams and permissions
        * Funnel Stages or States
        * Customized fields for deals
        * Activities for each deal
        * Background colors
        * Drag n Drop and more
* Calendar View
* Metrics Dashboard
* Settings
* RestAPI


# SOME SCREENSHOTS
![screen1](https://hanbai.geekoi.com/hanbai1.png)
![screen2](https://hanbai.geekoi.com/hanbai2.png)
![screen3](https://hanbai.geekoi.com/hanbai3.png)
![screen4](https://hanbai.geekoi.com/hanbai4.png)
![screen5](https://hanbai.geekoi.com/hanbai5.png)

# HOW TO INSTALL

```ruby
# 1. Clone the repo

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

# DO NOT FORGET TO install node in order to test real time functionalities
```

# DISCLAIMER
I DO NOT give support to this project any more, you are free to use the code in anyway you want, is free to use, but this web application as it is may present Bugs and Errors.

I developed this project several years ago, I kept a DEMO but is not getting supported, some libraries and dependencies maybe deprecated, the only technologies I updated were Ruby, Rails and PostgreSQL.
