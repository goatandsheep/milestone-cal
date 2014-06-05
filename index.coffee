icalendar = require 'icalendar'
async = require 'async'
github = require 'githubot'
express = require 'express'
_ = require 'underscore'
app = express()

process.env.HUBOT_GITHUB_TOKEN = process.env.GITHUB_TOKEN
allRepos = process.env.GITHUB_REPOS.split(',')

url = if process.env.URL_SECRET
  "/milestones/#{process.env.URL_SECRET}.ics"
else
  '/milestones.ics'

renderCalendar = (milestones) ->
  ical = new icalendar.iCalendar()

  for milestone in milestones
    repoName = _.find(allRepos, (x) -> milestone.url.match(x)).split('/')[1]
    event = ical.addComponent 'VEVENT'
    event.setSummary "[#{repoName}] #{milestone.title}"
    eventDate = new Date milestone.due_on
    eventDate.date_only = true
    event.setDate eventDate

  ical.toString()

app.get url, (req, res) ->

  showMilestoneFunctions = []

  for repo in allRepos
    do (repo) =>
      showMilestoneFunctions.push( (cb) ->
        github.get "repos/#{repo}/milestones", { state: 'open' }, (data) ->
          cb(null, data)
      )

  async.parallel showMilestoneFunctions, (err, results) ->
    console.log("ERROR: #{err}") if err
    allResults = [].concat.apply([], results)

    allResults = _.filter allResults, (r) ->
      r.due_on

    res.send(renderCalendar(allResults));

app.listen(process.env.PORT || 3000)
