#!/usr/bin/env bash

###
# APP_URL and API_KEY are the only two pieces of information you should
# need to update in this script to make it work.
#
# APP_URL is the hostname for your app
# ex: 
# APP_URL=http://localhost:3000
# or maybe
# APP_URL=https://remote.host.name
#
# API_KEY is the API_KEY as listed in your user profile within the app
# ex:
# API_KEY=3fda4e34df3e5def3d4fae4df5e3453
###
APP_URL=<THE_URL_OF_YOUR_APP>
API_KEY=<GET_THIS_FROM_YOUR_USER_ACCOUNT>
NOTES="Uploaded from MiSTer" # this can be whatever
###
API_URL=$APP_URL/api/v1


CURL=/bin/curl

SAVES_DIR=/media/fat/saves
BACKUP_DIR=/media/fat/saves_backup
BACKUP_COUNT=100
PLATFORMS=`ls -d $SAVES_DIR/*`
CACHE_DIR=/media/fat/Scripts/.cache/sync_saves
LAST_RUN_FILE=$CACHE_DIR/last_run
LAST_RUN=

function html_escape {
  echo $1 | curl -Gso /dev/null -w %{url_effective} --data-urlencode @- "" | sed -E 's/..(.*).../\1/'
}

function html_unescape {
  echo $1 | python3 -c "import sys; from urllib.parse import unquote; print(unquote(sys.stdin.read()));"
}

function get_json_val {
  if [ ! -z "$2" ] && [ "$2" != '[]' ]; then
    echo "$2" | python3 -c "import sys, json; print(json.load(sys.stdin)$1)"
  fi
}

function generate_checksum {
  openssl md5 -binary "$1" | base64
}

function get_mtime {
  stat -c %y "$1"
}

function get_mtime_seconds {
  stat -c %Y "$1"
}

function get_last_run {
  if [ -f "$LAST_RUN_FILE" ]; then
    LAST_RUN=`cat $LAST_RUN_FILE`
  fi
}

function update_last_run {
  date +%s > $LAST_RUN_FILE
}

function get_game {
  ESC=`html_escape "$1"`
  URL="$API_URL/games/lookup?name=$ESC"
  curl -s --request GET "$URL" --header "Authorization: Token $API_KEY"
}

function create_game {
  NAME=`html_escape "$1"`
  PLATFORM=`html_escape "$2"`
  URL="$API_URL/games?game\[name\]=$NAME&game\[platform_list\]=$PLATFORM"
  curl -s --request POST "$URL" --header "Authorization: Token $API_KEY"
}

function latest_save_file {
  GAME_ID=`html_escape "$1"`
  URL="$API_URL/games/$GAME_ID/save_files/latest"
  curl -s --request GET "$URL" --header "Authorization: Token $API_KEY"
}

function lookup_save_file {
  GAME_ID=`html_escape "$1"`
  CHECKSUM=`html_escape "$2"`
  URL="$API_URL/games/$GAME_ID/save_files/lookup?checksum=$CHECKSUM"
  curl -s --request GET "$URL" --header "Authorization: Token $API_KEY"
}

function upload_save_file {
  GAME_ID=`html_escape "$1"`
  SAVE_FILE_PATH="$2"
  MTIME=`get_mtime "$SAVE_FILE_PATH"`
  MTIME_ESC=`html_escape "$MTIME"` 
  #NOTES_ESC=`html_escape "$NOTES"`
  URL="$API_URL/games/$GAME_ID/save_files"
  curl -s --request POST "$URL" --header "Authorization: Token $API_KEY" \
   --form "save_file[mtime]=$MTIME" \
   --form "save_file[notes]=$NOTES" \
   --form "save_file[sram]=@\"$SAVE_FILE_PATH\""
}

echo "Getting LAST_RUN..."
get_last_run

echo "Creating save dir backup..."
DATE_DIR=`date +'%Y-%m-%d-%H%M%S'`
RSYNC_DEST=$BACKUP_DIR/$DATE_DIR
mkdir -p $CACHE_DIR
mkdir -p $RSYNC_DEST # make sure the target exists
rsync -r $SAVES_DIR/ $RSYNC_DEST
if [ $BACKUP_COUNT -gt 0 ]; then
  echo "Removing excess save dirs($BACKUP_COUNT)..."
  BACKUP_COUNT=$((BACKUP_COUNT+1)) # needs to be one more than desired
  ls -tp $BACKUP_DIR | grep '/$' | tail -n +$BACKUP_COUNT | xargs -I {} rm -rf -- $BACKUP_DIR/{}
else
  echo "Backups are set to retain all..."
fi
echo "Done."

echo "Checking save file platforms..."
for PLATFORM_DIR in $PLATFORMS
do
  PLATFORM=`basename $PLATFORM_DIR`
  if [ -d $PLATFORM_DIR ] && [ ! -z $PLATFORM_DIR ] && [ "$(ls -A $PLATFORM_DIR)" ]; then
    echo "Checking $PLATFORM..."
    for SAVE_PATH in "$PLATFORM_DIR"/*
    do

      SAVE_FILE=`basename "$SAVE_PATH"`
      LOCAL_MTIME_SECONDS=`get_mtime_seconds "$SAVE_PATH"`

      if [ ! -z "$LAST_RUN" ] && [ "$LAST_RUN" -ge "$LOCAL_MTIME_SECONDS" ]; then
	echo "$SAVE_FILE not updated since last run, skipping..."
        continue
      fi

      GAME="${SAVE_FILE%.*}"
      OUTPUT=`get_game "$GAME"`
      GAME_ID=`get_json_val "['id']" "$OUTPUT"`
      echo "Checking for existence of $GAME in percolator..."
      if [ -z "$GAME_ID" ]; then
        echo "does not exist creating..."
        OUTPUT=`create_game "$GAME" "$PLATFORM"`
        GAME_ID=`get_json_val "['id']" "$OUTPUT"`
        echo "created with ID $GAME_ID"
      fi
      
      CHECKSUM=`generate_checksum "$SAVE_PATH"`
      OUTPUT=`lookup_save_file "$GAME_ID" "$CHECKSUM"`
      SAVE_FILE_ID=`get_json_val "['id']" "$OUTPUT"`
      if [ -z "$SAVE_FILE_ID" ]; then
        echo "Save file for $CHECKSUM does not exist..."
        OUTPUT=`upload_save_file "$GAME_ID" "$SAVE_PATH"`
        SAVE_FILE_ID=`get_json_val "['id']" "$OUTPUT"`
        echo "created with ID $SAVE_FILE_ID"
      else
        echo "Save for $CHECKSUM exists, skipping."
      fi

      OUTPUT=`latest_save_file "$GAME_ID"`
      LATEST_SAVE_FILE_ID=`get_json_val "['id']" "$OUTPUT"`
      REMOTE_MTIME_SECONDS=`get_json_val "['mtime_seconds']" "$OUTPUT"`
      SRAM_PATH=`get_json_val "['sram']['path']" "$OUTPUT"`
      DOWNLOAD=false
      if [ -z "$LATEST_SAVE_FILE_ID" ]; then
        # save ID is empty
        # download latest save file
        echo "No local save, downloading remote..."
        DOWNLOAD=true
      else
        # check if latest remote save file is newer than the local save file
        echo "Local mtime: $LOCAL_MTIME_SECONDS"
        echo "Remote mtime: $REMOTE_MTIME_SECONDS"
        if [ $REMOTE_MTIME_SECONDS -gt $LOCAL_MTIME_SECONDS ]; then
          # if newer then download the latest file
          echo "Remote save is newer, downloading..."
          DOWNLOAD=true
        else
          echo "Local save is already up to date"
          DOWNLOAD=false
        fi

        if [ $DOWNLOAD = true ]; then
          SRAM_URL=$APP_URL/$SRAM_PATH
          OUTPUT_FILE_ENCODED=`basename $SRAM_PATH`
          OUTPUT_FILE=`html_unescape $OUTPUT_FILE_ENCODED`
          echo "Downloading $SRAM_URL..."
          curl $SRAM_URL -L -s -o "$PLATFORM_DIR/$OUTPUT_FILE"
        else
          echo "Skipping download..."
        fi

      fi
    done
  fi
  echo
done

echo "Updating LAST_RUN..."
update_last_run
