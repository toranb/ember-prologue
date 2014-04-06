# ember-prologue

## Just the facts right now. A better README to come

## Get it running
- `npm install`
- I find the bower install hook flaky so maybe bower install also
- Make you virtaulenv and hit a `pip install -r requirements/dev.txt `
- `./manage.py syncdb` (You might want to create a super user to see/test the permissions on the site)
- In the admin change the row in the sites table that says `example.com` to `localhost:8000` this is for the email reset
- The tests expect you are sending email so add values to `EMAIL_HOST_USER` and `EMAIL_HOST_PASSWORD` in the settings.
- While you are in the admin you may want to add a few users as well.
- `grunt build` (sometimes on a clean install this needs to be done twice or do a `grunt test` because well Larry Flint doesn't always preform as one would hope)
- You should be ready to rock at localhost:8000 at this point

## Running the tests
- Standard fair here

### Python
- `./manage.py test`

### JavaScript
- `grunt test`
