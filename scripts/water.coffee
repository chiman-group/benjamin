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

  robot.hear /water/i, (res) ->
    room = res.message.user.room
    now = Date.now() // 1000
    robot.brain.set "theRoom", room
    robot.brain.set "lastWater", now
    robot.logger.info "Watered on #{now}"
    res.send random(thanks)

  random = (items) ->
    items[ Math.floor(Math.random() * items.length) ]

  checkWater = ->
    # Recursive
    setTimeout () ->
      robot.emit "checkWater"
    , 30 * 60 * 1000

    room = robot.brain.get "theRoom"
    robot.logger.info "Room is #{room}"
    return if !room

    robot.logger.info "Going to check for water"

    now = Date.now() // 1000
    last = robot.brain.get "lastWater"
    diff = now - last
    sixDays = 6 * 24 * 60 * 60

    if diff < sixDays
      robot.logger.info "Fine! Last watering was #{diff / (60 * 60 * 24)} days ago."
    else
      robot.logger.info "Needy! Last watering was #{diff / (60 * 60 * 24)} days ago."
      robot.messageRoom room, random(nags)

  robot.on "checkWater", () ->
    checkWater()
          
  checkWater()
