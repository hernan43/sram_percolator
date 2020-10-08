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

This can be deployed like a normal run of the mill [Rails](https://rubyonrails.org/) app. The following are terrible instructions that I hope will get better over time:

  1. Deploy the app - I'd like to avoid rehashing info that is all over the web. Look at any of the zillion tutorials or use [Rails Guides](https://guides.rubyonrails.org/) to see what suits you best.
  2. Create yourself a user account - Go to the `/users/sign_up` URL of your deployed app.
  3. Grab your API token - Go to the `/profile` URL of the deployed app
  4. Use a [sample script](https://github.com/hernan43/sram_percolator/tree/master/sample_scripts) or write your own, making sure to use your app credentials

## Apologies

I am going to attempt to document the API for this, but I am not sure how I want to. This is a work in progress so it is going to be a mess for some time.


## Author
Ray Hernandez - @hernan43