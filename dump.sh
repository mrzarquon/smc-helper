#!/bin/bash

curl -X GET http://localhost:8080/pdb/query/v4/facts --data-urlencode 'query=["=", "name", "processorcount"]' > processors.json

curl -X GET http://localhost:8080/pdb/query/v4/facts --data-urlencode 'query=["=", "name", "memorysize_mb"]' > memory.json

curl -X GET http://localhost:8080/pdb/query/v4/facts --data-urlencode 'query=["=", "name", "kernel"]' > kernel.json
