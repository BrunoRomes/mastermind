FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN apt-get install -y graphviz
RUN apt-get install -y postgresql-client-9.4
WORKDIR /home/application
ADD Gemfile /Gemfile
ADD Gemfile.lock /Gemfile.lock
RUN bundle install