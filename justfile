#!/usr/bin/env just

default:
    @just --list
    @exit 1


dev:
    npm run search:dev
    npm run dev

build:
    rm -rf dist
    npm run build
