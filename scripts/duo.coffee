# Description:
#   Hubot script for using DUO 2FA Push notifications with Hubot
#   
#   To use it, you can invoke the robot.duoAuth method from within any hubot script:
#     robot.duo.auth <duo_username>, <callback>
#
# Dependencies:
#   duo-api 
#
# Configuration:
#   DUO_API_HOST: Duo api host.
#   DUO_API_IKEY: Duo api integration key.
#   DUO_API_SKEY: Duo api secret key.
#
# Commands:
#   hubot duo verify - verifies the DUO configuration settings
#
Client = require 'duo-api'

client = new Client({
  host: process.env.DUO_API_HOST || 'duo_host',
  ikey: process.env.DUO_API_IKEY || 'duo_ikey',
  skey: process.env.DUO_API_SKEY || 'duo_skey'
})

module.exports = (robot) ->
  class DUO
    auth: (duo_username, callback) ->
      client.request 'post', '/auth/v2/auth', {
        'username': duo_username,
        'factor': 'push',
        'device': 'auto'
      }, (err, res) -> 
        if err
          robot.logger.error "Threw an error during duo auth: #{err}"
          return callback(err)
        robot.logger.debug "Got a response from duo: #{res}"
        return callback(null, res.response)

    verify: (callback) ->
      client.request 'get', '/auth/v2/check', null, (err, res) ->
        if err 
          robot.logger.error "Threw an error during duo verify: #{err}"
          return callback(err)
        robot.logger.debug "Got a response from duo: #{res}"
        return callback(null, res.response)

  robot.duo = new DUO

  robot.respond /duo verify/i, (msg) ->
    robot.duo.verify (err, res) ->
      if err
        return msg.send err
      return msg.send "#{JSON.stringify(res)}"