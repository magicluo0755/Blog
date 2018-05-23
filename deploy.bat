@REM !/bin/bat
@REM 
@REM Copyright (c) 2018 magicluo.com
@REM All Rights Reserved.


@echo off
echo Deploying updates to Github

::set HUGO_SITECDOE_ROOT=%cd%
::echo HUGO_SITECODE_ROOT:  %HUGO_SITECODE_ROOT%

set d=%date:~0,10%
set t=%time:~0,8%
set commitmsg=rebuidling site %d% %t%

::Commit changes to https://github.com/magicluo0755/my-hugo-blog.git
git add -A
git commit -m "%commitmsg%"
git push origin master

echo Commit site code changes to https://github.com/magicluo0755/my-hugo-blog.git [Done]

:: Build the site project
cd ../magicluo0755.github.io
set HUGO_SITE_ROOT=%cd%

hugo --theme=beautifulhugo --destination=%HUGO_SITE_ROOT%

echo Build site. [Done]

pause
