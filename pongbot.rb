require 'slack-ruby-bot'
require 'chronic'
# def remind(channel, text, user)
#     if text.match(/remind (\S+) to (.+) ((?:in) .+|tomorrow)$/)
#         who = text.match(/remind (\S+) to (.+) ((?:in) .+|tomorrow)$/)[1]
#         msg = text.match(/remind (\S+) to (.+) ((?:in) .+|tomorrow)$/)[2]
#         duration = text.match(/remind (\S+) to (.+) ((?:in) .+|tomorrow)$/)[3]
#         t = Chronic.parse(duration)
#         puts who
#         puts message
#         puts duration
#         puts t
#         # if t.nil?
#         #     return "{sender}: Sorry, I don't understand that time."
#         # end
#         # if (t - Time.now) < 0
#         #     return "{user}: Uh, that's in the past."
#         # end
#         new_reminder = reminder.create(sender: user, people: who, message: msg, time: t)
#         # return "#{user}: Okay, I'll let #{who} know in around #{duration}."
#     end
# end

class PongBot < SlackRubyBot::Bot
    command 'remind' do |client, data, match|
        client.web_client.reactions_add(
          name: :hourglass_flowing_sand,
          channel: data.channel,
          timestamp: data.ts,
          as_user: true
        )
        # client.say(text: output, channel: data.channel)
        client.say(text: "ok!", channel: data.channel)
        # client.say(channel: data.channel, text: "Received command #{match[:command]} with args #{match[:expression]}")
        who = data.text.match(/remind (\S+) to (.+) ((?:in) .+|tomorrow)$/)[1]
        msg = data.text.match(/remind (\S+) to (.+) ((?:in) .+|tomorrow)$/)[2]
        duration = data.text.match(/remind (\S+) to (.+) ((?:in) .+|tomorrow)$/)[3]
        t = Chronic.parse(duration)
        puts who
        puts msg
        puts duration
        puts t
        client.say(text: "<@#{data.user}>: Okay, I'll let #{who} know in around #{duration}", channel: data.channel)
        @reminder = Reminder.new sender: data.user, people: who, message: msg, time: t
        reminder.save
    end
    # command 'reminders' do |client, data, match|
    #   client.say(text: $arr, channel: data.channel)
    # end
end

# SLACK_API_TOKEN='xoxb-489640812756-489153957760-aG2AsSswgYkaGq1IKGwWd0wm' bundle exec ruby pongbot.rb
PongBot.run

# @ivy: @BotName remind
# @myles to plan the timelines in 3 days
# filter out anything that contains @
# anything between 'in' and 'to'
# 3 days
