#!/bin/bash

cd /app
echo $APP_ENV

if [ "$APP_ENV" == "development" ] 
then
    echo "Development mode"
    python app.py
else
    echo "Production mode"
    gunicorn --bind 0.0.0.0:5000 uwsgi:app
fi
