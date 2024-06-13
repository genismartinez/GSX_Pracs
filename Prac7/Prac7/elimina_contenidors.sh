#!/bin/bash

for node in 1 2 3 4; do
    docker kill R$node
done

