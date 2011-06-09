#!/bin/sh
curl -H "Accept: application/json" -X GET http://localhost:3000/projects/query.json -d "user_id=2&salt=bde45ec30b2fb6b0c08c5b3f4f914b0e4a0b39807b0c993272840d24ed84e21e"