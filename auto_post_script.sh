git checkout source;
git add .;
git commit -a -m 'source backup `date +%Y%m%d`';
git push origin source;
hexo g;
hexo d;
