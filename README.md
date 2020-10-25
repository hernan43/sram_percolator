# SRAM Percolator

The plan is to make this a self hostable web service for syncing game saves from software like Retroarch or something similar. 

I would like this to have a simple to use API that will make it easy to write your own plugins for this.

**THIS IS A MEGA WORK IN PROGRESS**

## How it works

The idea here was for me to create a "service" that I could use to synchronize save files between my [MiSTer FPGAs](https://github.com/MiSTer-devel/Main_MiSTer/wiki). There are already options to use things like Google Drive and whatnot. None of the options work like I'd like them to. 

I'm not sure another service is the right idea but I don't have anything better to do with my time so I may as well try something new. 

This app:

* is a multi-user game save syncing service
* annotate save files with notes
* maintains a full history of save files for each game
* lookup games by system
* lookup saves by checksum
* grab latest save for each game(uses "mtime")
* simple API(hopefully) allowing user to write scripts to push/pull saves
* allows users to write sync scripts for Retroarch, MiSTer, etc

I have some grand ideas of things I'd like to do with it(sync between MiSTer and Retroarch, convert between save formats, etc.). If I get the time I'd love to implement these things. 

Right now, with the [sample MiSTer script](https://github.com/hernan43/sram_percolator/blob/master/sample_scripts/mister_saves_sync.sh) it does what I want. Lets me sync, download, and browse games/saves.

## How it runs

### The (hopefully) Easier Way

Since standing up Rails apps isn't the most universal skill, I went ahead an [Dockerized](https://docker.org) the app so that it can be launched a little bit easier.

I am not a Docker expert. I have only done the bare minimum with it, so I am probably not doing this in the best fashion BUT it does work so that is ne positive.

I made a Docker Hub repo for the app: [here](https://hub.docker.com/r/hernan43/sram_percolator).

  1. Install [Docker](https://docker.org) OR EVEN BETTER [Docker Desktop](https://www.docker.com/products/docker-desktop) on your platform of choice
  2. Install [Docker Compose](https://docs.docker.com/compose/install/)
        1.  In my case, Docker Desktop came with compose already so I didn't have to do this. 
  2. Git clone this repo
  3. There is a `docker-compose.yml` file in the repo. It does work out of the box but you will want to generate your own SECRET_KEY_BASE
        1.  `rake secret` is the easy way
  4. Run `docker-compose up`
    6. Assuming it launched, you need to build the database
        1. Open a bash shell on your web container `docker exec -it CONTAINER_ID /bin/bash`
        2. You can get your container IDs by running  - [docs](https://docs.docker.com/engine/reference/commandline/ps/)
        3. Run `rake db:migrate` in your newly launched shell - it should run a bunch of DB junk
  6. By default the app will launch on port 3000. 
        1. Go to http://HOSTNAME:3000 in your browser - ex. http://localhost:3000
  7. You will be prompted with a login page and sign up options
  8. This is still pretty RAW so you have to poke around yourself

### The More Tedious Way

This can be deployed like a normal run of the mill [Rails](https://rubyonrails.org/) app. The following are terrible instructions that I hope will get better over time:

  1. Deploy the app - I'd like to avoid rehashing info that is all over the web. Look at any of the zillion tutorials or use [Rails Guides](https://guides.rubyonrails.org/) to see what suits you best.
  2. Create yourself a user account - Go to the `/users/sign_up` URL of your deployed app.
  3. Grab your API token - Go to the `/profile` URL of the deployed app
  4. Use a [sample script](https://github.com/hernan43/sram_percolator/tree/master/sample_scripts) or write your own, making sure to use your app credentials

## Apologies

I am going to attempt to document the API for this, but I am not sure how I want to. This is a work in progress so it is going to be a mess for some time.


## Author
Ray Hernandez - @hernan43
