#!/usr/bin/env just

default:
    @just --list
    @exit 1


dev:
    npm run search:dev
    npm run dev

build:
    just clean
    npm run build

clean:
    rm -rf dist .astro
