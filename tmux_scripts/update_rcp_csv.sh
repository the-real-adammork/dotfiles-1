#!/bin/bash

cd "$(dirname "$0")";
source user_exports.sh

PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

echo $USER_HOME

/usr/local/bin/rcp https://www.realclearpolitics.com/epolls/other/president_trump_job_approval-6179.html
