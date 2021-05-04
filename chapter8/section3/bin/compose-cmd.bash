#!/usr/bin/env bash
carton install && \
if [ -f ./db/bulletin.sql ] && [ -f ./db/bulletin.db ]; then
    carton exec -- morbo script/bulletin
elif [ -s ./db/bulletin.sql ]; then
    sqlite3 ./db/bulletin.db < ./db/bulletin.sql
    carton exec -- morbo script/bulletin
else
    echo "not exist bulletin.sql !!"
fi
