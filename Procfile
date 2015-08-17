web: bundle exec puma -C config/puma.rb

worker: bundle exec sidekiq -q mailer -q default -c 3 -v