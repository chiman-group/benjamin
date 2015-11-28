moment = require('moment')

module.exports = (robot) ->
  nags = [
        "من آب می‌خوام",
        "لطفا آب",
        "یادتون باشه امروز به من آب بدید",
        "یه لیوان آب میدی؟ یه لیوان! مثل صمیم خفه‌ام نکنی.",
        "تشنمه",
        "🍃😔🚰",
        "😪"
  ]

  thanks = [
        "سپاس"
  ]

  room = process.env.GROUP_ID

  random = (items) ->
    items[ Math.floor(Math.random() * items.length) ]

  robot.hear /water (.*)/i, (res) ->
    thisRoom = res.message.user.room
    command = res.match[1]

    if room.localeCompare(thisRoom) isnt 0
      robot.logger.info "#{thisRoom}, #{room}"
      res.send "من با غریبه حرف نمی‌زنم"
      return

    if command is "reset"
      date = new Date(1)
      res.send "خب من الان همه چی یادم رفت مثلا"
      robot.brain.set "lastWater", (date.getTime() // 1000)
      robot.brain.set "lastNag", (date.getTime() // 1000)
    else if command is "done"
      date = new Date()
      res.send random(thanks)
      robot.logger.info "Watered on #{date.toDateString()}"
      robot.brain.set "lastWater", (date.getTime() // 1000)
      robot.brain.set "lastNag", (date.getTime() // 1000)
    else if command is "when"
      lastWaterTime = robot.brain.get "lastWater"
      moment.locale('fa')
      lastWater = moment.unix(lastWaterTime).fromNow()
      res.send lastWater

  checkWater = ->
    # Recursive
    setTimeout () ->
      robot.emit "checkWater"
    , 60 * 1000

    robot.logger.info "Room is #{room}"
    return if !room

    robot.logger.info "Going to check for water"

    now = Date.now() // 1000
    lastWater = robot.brain.get "lastWater"
    lastNag = robot.brain.get "lastNag"
    sixDays = 6 * 24 * 60 * 60
    twoHours = 60 * 60 * 2

    if ((now - lastWater) < sixDays)
      robot.logger.info "Fine! Last watering was #{(now - lastWater) / (60 * 60 * 24)} days ago."
    else
      robot.logger.info "Needy! Last watering was #{(now - lastWater) / (60 * 60 * 24)} days ago."
      robot.logger.info "Last nag was #{(now - lastNag) / 60 } mins ago."
      if ((now - lastNag) > twoHours)
        robot.messageRoom room, random(nags)
        robot.brain.set "lastNag", now

  robot.on "checkWater", () ->
    checkWater()
          
  checkWater()
