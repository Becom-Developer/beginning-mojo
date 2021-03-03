#!/usr/bin/env bash
carton install && \
carton exec -- mojo generate lite-app bulletin.pl
if [ -f ./db/bulletin.sql ] && [ -f ./db/bulletin.db ]; then
    carton exec -- morbo bulletin.pl
elif [ -s ./db/bulletin.sql ]; then
    sqlite3 ./db/bulletin.db < ./db/bulletin.sql
    carton exec -- morbo bulletin.pl
else
    echo "not exist bulletin.sql !!"
fi
