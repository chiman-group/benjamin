module.exports = (robot) ->
  robot.hear /setgroup/i, (res) ->
    room = res.message.user.room
    robot.brain.set "theRoom", room
    res.send "باشه یادم می‌مونه اینجا حرف بزنم."
        
