FROM ruby:3.0.0
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1


WORKDIR /usr/src/iot_rails

COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN yarn install

COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server","-b", "0.0.0.0"]
