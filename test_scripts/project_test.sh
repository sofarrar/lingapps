#!/bin/sh
curl -H "Accept: application/json" -X GET http://localhost:3000/projects/query.json -d "user_id=2"