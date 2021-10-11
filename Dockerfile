FROM ruby:3.0.0
RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1


WORKDIR /usr/src/iot_rails

COPY Gemfile Gemfile.lock ./
RUN bundle install


COPY . .

COPY package.json .
COPY yarn.lock .
RUN yarn install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server","-b", "0.0.0.0"]
