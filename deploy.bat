@REM !/bin/bat
@REM 
@REM Copyright (c) 2018 magicluo.com
@REM All Rights Reserved.


@echo off
echo Deploying updates to Github

set HUGO_SITE_ROOT=%cd%
echo HUGO_SITE_ROOT:  %HUGO_SITE_ROOT%

set d=%date:~0,10%
set t=%time:~0,8%

set  commitmsg=rebuidling site %d% %t%

REM commit changes to https://github.com/magicluo0755/my-hugo-blog.git

git add -A
git commit -m "%commitmsg%"
git push origin master

REM Build the site project

hugo --theme=beautifulhugo

cd public
REM git add -A
REM git commit -m "%commitmsg%"

REM Push source and build repos
REM git push origin master

cd ../

pause
