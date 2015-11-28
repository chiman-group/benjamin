module.exports = (robot) ->
  room = process.env.GROUP_ID

  robot.hear /shit|عن|ان|شت/i, (res) ->
    thisRoom = res.message.user.room
    if room.localeCompare(thisRoom) is 0
      res.send "یه عن ریز 💩"
