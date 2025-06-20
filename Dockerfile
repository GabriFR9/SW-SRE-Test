FROM ruby:3.2

RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client redis wget

RUN gem install bundler rails

WORKDIR /app

COPY hello-world-rails.sh /hello-world-rails.sh
RUN chmod +x /hello-world-rails.sh

COPY . .

CMD ["/hello-world-rails.sh"]
