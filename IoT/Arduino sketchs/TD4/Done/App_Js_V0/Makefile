
all:
	git add .
	git commit -m "urls version"
	git push -u origin main
	git push heroku main
	heroku  dyno:restart
	heroku logs
