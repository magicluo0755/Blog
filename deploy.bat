@REM !/bin/bat
@REM 
@REM Copyright (c) 2018 magicluo.com
@REM All Rights Reserved.


@echo off
echo Deploying updates to Github

set HUGO_SITECODE_ROOT=%cd%
echo HUGO_SITECODE_ROOT:  %HUGO_SITECODE_ROOT%

set d=%date:~0,10%
set t=%time:~0,8%
set  commitmsg=rebuidling site %d% %t%

REM commit changes to https://github.com/magicluo0755/my-hugo-blog.git

git add -A
git commit -m "%commitmsg%"
git push origin master

echo Commit site's code changes to github [Done] !

REM Build the site and commit changes to https://github.com/magicluo0755/magicluo0755.github.io.git. 
REM Make sure [mgicluo0755.github.io] folder existed,otherwise you need to create it first!
REM  ---D:\
REM  |
REM  ------D:\site_code
REM  |
REM  ------D:\site_release [magicluo0755.github.io]
REM 
REM "site_code" folder is the local site's code git repo and associted with remote git repo :http://github.com/magicluo0755/my_hugo_blog.git
REM "site_release" folder is the local site's git repo and associted with remote git repo :http://github.com/magicluo0755/magicluo0755.github.io

cd ../magicluo.github.io
set HUGO_SITE_ROOT=%cd%

cd %HUGO_SITECODE_ROOT%

REM build site and write files to destination folder
hugo --theme=beautifulhugo  --destination=%HUGO_SITE_ROOT%

cd %HUGO_SITE_ROOT%

REM commit changes to http://github.com/magicluo0755/magicluo0755.github.io
git add -A
git commit -m "%commitmsg%"
git push origin master

echo Commit site's files changes to github [Done] !

pause
