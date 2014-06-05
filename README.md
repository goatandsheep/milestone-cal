milestone-cal
========

Renders GitHub Milestones in a iCal-compatible `.ics` feed that can be subscribed to via Google Calendar, iCal, etc.

## Usage

1. Fork this repo
2. `heroku create`
3. Set these environment variables:
  - `GITHUB_TOKEN` - a personal OAuth token
  - `GITHUB_REPOS` - a comma-separated list of github repos that we'll pull milestones from
  - `URL_SECRET` - (optional) an arbitrary string that will become part of your uri, for "security"
4. `git push heroku master`
5. Point your calendar to `http://[hostname]/milestones.ics`, or `http://[hostname]/milestones/[URL_SECRET].ics` if you set a `URL_SECRET`.
