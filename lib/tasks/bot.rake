namespace :bot do
  desc "Run the bot"
  task start: :environment do
      # reminder = Reminder.new sender: '', people: '', message: '', time: ''
      # puts reminder
      # reminder.save
      require 'slack-ruby-bot'
      require 'chronic'
      require 'slack-ruby-client'

      ENV['SLACK_API_TOKEN'] = 'xoxb-489640812756-489153957760-aG2AsSswgYkaGq1IKGwWd0wm'

      Slack.configure do |config|
          config.token = ENV['SLACK_API_TOKEN']
          raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
      end

      $web_client = Slack::Web::Client.new
      $web_client.auth_test
      class PongBot < SlackRubyBot::Bot
          command 'remind' do |client, data, match|
              client.web_client.reactions_add(
                name: :hourglass_flowing_sand,
                channel: data.channel,
                timestamp: data.ts,
                as_user: true
              )

              client.say(text: "ok!", channel: data.channel)
              realname = $web_client.users_info(user: data.user).user.name
              who = data.text.match(/remind (\S+) to (.+) ((?:in) .+|tomorrow)$/)[1]
              msg = data.text.match(/remind (\S+) to (.+) ((?:in) .+|tomorrow)$/)[2]
              duration = data.text.match(/remind (\S+) to (.+) ((?:in) .+|tomorrow)$/)[3]
              t = Chronic.parse(duration)

              todo = Todo.new name: realname, sender: data.user, people: who, message: msg, time: t
              todo.save!
              client.web_client.chat_postMessage(
                channel: data.channel,
                as_user: true,
                attachments: [
                  {
                    fallback: "test",
                    title: "To Do: ",
                    text: "<@#{data.user}> -- #{msg}",
                    color: '#FF0000'
                  }
                ]
              )
              puts
          end

          command 'reminders' do |client, data, match|
            realname = $web_client.users_info(user: data.user).user.name
            reminders = Todo.where(name: realname)
            client.say(text: "Here are all your reminders:", channel: data.channel)
            reminders.each do |r|
                client.web_client.chat_postMessage(
                  channel: data.channel,
                  as_user: true,
                  attachments: [
                    {
                      fallback: "test",
                      title: "To Do: ",
                      text: "#{r.message} \n Created at #{r.time} by #<@#{r.sender}>",
                      color: '#002fa7'
                    }
                  ]
                )
            end
          end
      end

      PongBot.run
  end
end
