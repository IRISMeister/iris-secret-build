#!/bin/bash
docker build -t test --no-cache --progress=plain --secret id=mysecret,src=iris.key .