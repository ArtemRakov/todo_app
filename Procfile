web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -C config/sidekiq.yml
scheduler: bundle exec clockwork config/scheduler.rb
release: rails db:migrate
