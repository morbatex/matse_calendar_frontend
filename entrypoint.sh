#!/bin/sh
sed -i -- "s|REPLACEME|$BACKEND_URL|g" /static/assets/*
nginx -g "daemon off;"
