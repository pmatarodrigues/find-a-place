FROM ruby:3.0
RUN apt-get update -qq

# Install dependencies:
# - build-base: To ensure certain gems can be compiled
# - libxslt-dev libxml2-dev: Nokogiri native dependencies
RUN apt-get install -y libxslt-dev libxml2-dev

# Set an environment variable to store where the app is installed inside
# of the Docker image.
ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
