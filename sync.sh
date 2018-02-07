#!/bin/bash
cd ./compiled; scp -r ./* root@sam-watkinson.com:/var/www/sam-watkinson/public; cd ..