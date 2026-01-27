FROM ruby:3.3

WORKDIR /srv/jekyll

# Copy only gem files first (better caching)
COPY Gemfile Gemfile.lock* ./

RUN bundle install

# Copy the rest of the site
COPY . .

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--incremental", "--livereload", "--force_polling", "--baseurl", ""]
