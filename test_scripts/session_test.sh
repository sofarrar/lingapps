#!/bin/sh
curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/sessions#create -d "{"session" : {"email" : "paco@mexico.com", "password" : "mexico"}}"