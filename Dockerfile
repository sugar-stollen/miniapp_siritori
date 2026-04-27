FROM ruby:3.2.2
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp