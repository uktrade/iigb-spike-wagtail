FROM python:3.6

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV NVM_DIR /usr/local/nvm # or ~/.nvm , depending
ENV NODE_VERSION 0.10.33

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Required to compile install wagtail dev static files [1] until 2.0 is released on pypi
#RUN apt-get update && apt-get install -y nodejs nodejs-legacy npm && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN nvm install node
RUN nvm use node

COPY requirements.txt /usr/src/app/
# Different src directory for pip to prevent 'pip install -e' packages to be installed in /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt --src /usr/local/src

# [1] http://docs.wagtail.io/en/latest/contributing/developing.html
RUN cd /usr/local/src/wagtail && npm install && npm run build

COPY . /usr/src/app

CMD ["/usr/src/app/docker/cmd-webserver.sh"]

EXPOSE 8000
