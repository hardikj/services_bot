# Description:
#   An HTTP Listener for notifications on github pushes, issues etc
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#   "gitio2": "2.0.0"
#
# Configuration:
#   Just put this url <HUBOT_URL>:<PORT>/hubot/gh-commits?room=<room> into you'r github hooks
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/gh-commits?room=<room>[&type=<type]

url = require('url')
querystring = require('querystring')
gitio = require('gitio2')

module.exports = (robot) ->
  robot.router.post "/hubot/gh-commits", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    res.send 200

    user = {}
    user.room = query.room if query.room

    return if req.body.zen? # initial ping
    pull = req.body
    try
      if pull.action == "opened"
        robot.send user, "[\x02\x0335New Pull Request\x03\x02] #{pull.pull_request.title} [#{pull.pull_request.html_url}] (owner: \x02\x0344#{pull.pull_request.user.login}\x03\x02) "
      else if pull.action == "close" && pull.pull_request.merged
        robot.send user, "[\x02\x033Merged\x03\x02] #{pull.pull_request.title} [#{pull.pull_request.html_url}] (owner: \x02\x0344#{pull.pull_request.user.login}\x03\x02) "
      else if pull.action == "close" && !pull.pull_request.merged
        robot.send user, "[\x02\x034Closed\x03\x02] #{pull.pull_request.title} [#{pull.pull_request.html_url}] (owner: \x02\x0344#{pull.pull_request.user.login}\x03\x02) "
      ###
      else
          if push.commit
              #commitWord = if push.commits.length > 1 then "commits" else "commit"
              #push.commits.length > 0
              for commit in push.commits
                do (commit) ->
                  gitio commit.url, (err, data) ->
                  robot.send user, "  * #{commit.message} (#{if err then commit.url else data})"
      #      robot.send user, "#{push.commit.commit.author.username}: #{push.commit.commit.message} (#{if err then commit.url else data})"
      ###
    catch error
      console.log "github-commits error: #{error}. Push: #{push}"
