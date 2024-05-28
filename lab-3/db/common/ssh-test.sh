#!/bin/sh

set -e

ssh -q $1 "echo Hello, World!"
