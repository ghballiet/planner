#!/bin/bash

cat input.lp > .test
cat prog.lp >> .test
gringo .test | clasp -n0 && rm .test