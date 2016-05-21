FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
WORKDIR /home/application
ADD Gemfile /Gemfile
ADD Gemfile.lock /Gemfile.lock
RUN bundle install
ADD . /home/application