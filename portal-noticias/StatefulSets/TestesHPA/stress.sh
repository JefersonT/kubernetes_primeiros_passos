#!/bin/bash
for i in {1..10000}; do
  curl -s 192.168.59.100:30000
  sleep $1
done
