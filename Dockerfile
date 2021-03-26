FROM ruby:2.6.6-alpine3.13

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./

RUN apk add --no-cache alpine-sdk && \
    bundle install --without development test && \
    apk del alpine-sdk

RUN apk add curl

COPY . .

EXPOSE 9981

CMD ["sh","entrypoint.sh"]