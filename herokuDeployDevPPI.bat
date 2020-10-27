mkdir ..\PPI_HEROKU_DEPLOY
cd ..\PPI_HEROKU_DEPLOY
git init
echo ----------------------------------------------
echo      RUN SCRIPT: herokuAdditionalDevPPI.sh
echo ----------------------------------------------
pause
git pull heroku master
REM HERE DELETE ALL FILES INSTAED .git AND system.properties FROM ACTUAL FOLDER
xcopy ..\PPI\PPI_BACKEND\viroshop ..\PPI_HEROKU_DEPLOY /E
echo system.properties >> system.properties
git add .
git commit -m "Release to dev-ppi into heroku"
git push -f heroku master:master
cd ..
rd /s /q PPI_HEROKU_DEPLOY