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
      switch pull.action
        when "synchronize"
          robot.send user, "[\x02\x0324Pull Updated\x03\x02] #{pull.pull_request.title} - #{pull.pull_request.html_url} (owner: \x02\x0344#{pull.pull_request.user.login}\x03\x02) "
        when "opened"
          robot.send user, "[\x02\x0342New Pull Request\x03\x02] #{pull.pull_request.title} - #{pull.pull_request.html_url} (owner: \x02\x0344#{pull.pull_request.user.login}\x03\x02) "
        when "closed" 
          if pull.pull_request.merged
            robot.send user, "[\x02\x0313Merged\x03\x02] #{pull.pull_request.title} #{pull.pull_request.html_url} (owner: \x02\x0344#{pull.pull_request.user.login}\x03\x02) "
          else if !pull.pull_request.merged
            robot.send user, "[\x02\x034Closed\x03\x02] #{pull.pull_request.title} #{pull.pull_request.html_url} (owner: \x02\x0344#{pull.pull_request.user.login}\x03\x02) "
    catch error
      console.log "github-commits error: #{error}. Push: #{push}"