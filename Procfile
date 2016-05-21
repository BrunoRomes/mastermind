web: bundle exec puma -C config/puma.rb
cleanup_worker: bundle exec que --queue-name cleanup --worker-count 1 --wake-interval 0.5 --log-level info ./config/environment.rb