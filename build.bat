@REM !/bin/bat
@REM 
@REM Copyright (c) 2018 magicluo.com
@REM All Rights Reserved.


@echo off
echo Deploying updates to Github

set HUGO_SITECODE_ROOT=%cd%
echo HUGO_SITECODE_ROOT:  %HUGO_SITE_ROOT%

set d=%date:~0,10%
set t=%time:~0,8%

set  commitmsg=rebuidling site %d% %t%

REM commit changes to https://github.com/magicluo0755/my-hugo-blog.git [Done]

git add -A
git commit -m "%commitmsg%"
git push origin master

REM Build the site project
cd ../magicluo0755.github.io
ehco
set HUGO_SITE_ROOT=%cd%
echo HUGO_SITE_ROOT:  %HUGO_SITE_ROOT%
cd %HUGO_SITECODE_ROOT%

hugo --theme=beautifulhugo --destination=%HUGO_SITE_ROOT%

REM Build site. [Done]

pause
