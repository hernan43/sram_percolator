FROM ruby:2.7.2

RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -
#RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
#RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#RUN apt-get update -qq && apt-get install -y gnupg2 nodejs yarn postgresql-client
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
#RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN npm install -g yarn

RUN mkdir /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock
COPY . /app
WORKDIR /app
RUN bundle config set without 'development test'
#RUN bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3
RUN bundle install --retry 3
RUN yarn install --check-files
#RUN yarn install
RUN RAILS_ENV=production bundle exec rake assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
