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

  random = (items) ->
    items[ Math.floor(Math.random() * items.length) ]

  robot.hear /water (.*)/i, (res) ->
    room = res.message.user.room
    command = res.match[1]

    if command is "reset"
      date = new Date(1)
      res.send "خب من الان همه چی یادم رفت مثلا"
    else if command is "done"
      date = new Date()
      res.send random(thanks)

    robot.brain.set "theRoom", room
    robot.brain.set "lastWater", (date.getTime() // 1000)
    robot.brain.set "lastNag", (date.getTime() // 1000)
    robot.logger.info "Watered on #{date.toDateString()}"

  checkWater = ->
    # Recursive
    setTimeout () ->
      robot.emit "checkWater"
    , 60 * 1000

    room = robot.brain.get "theRoom"
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
