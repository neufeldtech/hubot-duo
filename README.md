# hubot-duo

This package will allow you to make use of DUO two-factor authentication (push notifications) in your hubot scripts.

## Installation

- Run the `npm install` command
```
npm install hubot-duo --save
```

- Add **hubot-duo** to the array in your `external-scripts.json`
```
[
  "hubot-duo"
]
```

## Setup

### DUO Setup

- [Follow the instructions](https://duo.com/docs/authapi) for setting up **DUO Auth API**. Note: the Auth API is only available on DUO Enterprise and Platform editions, but they do offer a [30 day trial](https://duo.com/trial). 
- Set your environment variables to your API Host, Integration Key, and Secret key (See [Environment Variables](#environment-variables))
- Create DUO users and enroll their devices for push notifications. Hint: if you can create the DUO users with the same naming convention as your chat users (`msg.message.user.name`), you can save yourself some work.

### Environment variables

- DUO_API_HOST - DUO API hostname
- DUO_API_IKEY - DUO Integration key  
- DUO_API_SKEY - DUO Secret key

## Usage
Verifying the setup:
```
user@localhost$ export DUO_API_HOST=api-a1d2f3g4h5j6.duosecurity.com
user@localhost$ export DUO_API_IKEY=123456789SADFGHJK
user@localhost$ export DUO_API_SKEY=123456789LKJHGFDSAMNBVCXZ
user@localhost$ bin/hubot
hubot> hubot duo verify
hubot> {"time":1479154215}
```
If you didn't get any errors, your DUO keys are valid!


**hubot-duo** works by binding a `duo` object to the global `robot` for use inside any other hubot script that you wish to add 2FA to.

In this short example, we are assuming that our chat platform usernames (`msg.message.user.name`) are the same as the usernames in DUO.
```
module.exports = (robot) ->
  robot.respond /launch the rocket/i, (msg) ->
    msg.reply 'In order to launch the rocket, you have to authenticate via DUO. Sending you a push notification now...'
    robot.duo.auth msg.message.user.name, (err, res) ->
      if err
        return msg.send "Error during DUO authentication: #{err}"
      if res.result == 'allow'
        return msg.send 'LAUNCHING THE ROCKET!!! :rocket:'
      return msg.send 'Aborting the rocket launch...'
```