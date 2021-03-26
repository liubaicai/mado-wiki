#!/usr/bin/env sh

curl -o pandoc.tar.gz -L https://github.com/jgm/pandoc/releases/download/2.13/pandoc-2.13-linux-amd64.tar.gz
tar -zxvf pandoc.tar.gz -C .
cp pandoc-2.13/bin/pandoc /usr/bin/
puma