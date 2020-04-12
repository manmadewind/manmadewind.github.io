#!/bin/bash
now_date=`date +%Y%m%d`

git checkout source;
git add .;
git commit -a -m "source backup ${now_date}";
git push origin source;
hexo g;
hexo d;

echo "Done ${now_date}"