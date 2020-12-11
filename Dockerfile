ARG BASE_RUBY_IMAGE=ruby:2.7.2-alpine

FROM ${BASE_RUBY_IMAGE} AS base-image

RUN apk add --update --no-cache tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

RUN apk add --update --no-cache --virtual runtime-dependances \
    yarn

WORKDIR /app

COPY Gemfile Gemfile.lock .tool-versions ./

RUN apk add --update --no-cache --virtual build-dependances \
    build-base  && \
    bundle install --jobs=4 && \
    apk del build-dependances

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

COPY . .

RUN bundle exec rake assets:precompile && \
    rm -rf node_modules /usr/local/bundle/cache


FROM ${BASE_RUBY_IMAGE}
ARG COMMIT_SHA

WORKDIR /app
COPY --from=base-image /app /app
COPY --from=base-image /usr/local/bundle/ /usr/local/bundle/

ENV SHA=${COMMIT_SHA}

RUN apk add --update --no-cache tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

CMD bundle exec rails server -b 0.0.0.0
