@REM !/bin/bat
@REM 
@REM Copyright (c) 2018 magicluo.cn
@REM All Rights Reserved.


@echo off
echo Build the Blog sorce code to static HTML pages and push to Github

set BLOG_CODE_PATH=%cd%
echo BLOG_CODE_PATH:  %BLOG_CODE_PATH%

set d=%date:~0,10%
set t=%time:~0,8%

set  commitmsg=生成新文章 %d% %t%
echo commit changes to https://github.com/magicluo0755/Blog.git [Done]

git add -A
git commit -m "%commitmsg%"
git push origin master

REM Build the blog to static htmls
cd ../magicluo0755.github.io
set BLOG_PAGES_PATH=%cd%
echo BLOG_PAGES_PATH:  %BLOG_PAGES_PATH%

cd %BLOG_CODE_PATH%

hugo  --destination=%BLOG_PAGES_PATH%

echo Build done. [Done]

pause
