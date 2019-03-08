FROM anapsix/alpine-java:8_jdk

LABEL maintainer "Yosef Sugiarto (yosef.sugiarto@gmail.com)"

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="e.g. https://github.com/microscaling/microscaling"

ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"

ENV ANDROID_HOME "/android-sdk"
ENV ANDROID_COMPILE_SDK "28"
ENV ANDROID_BUILD_TOOLS "28.0.0"
ENV ANDROID_SDK_TOOLS "3859397"
ENV PATH "$PATH:${ANDROID_HOME}/platform-tools"

ARG CLOUD_SDK_VERSION=237.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

RUN apk update && \
    apk add --no-cache \
        git \
        bash \
        curl \
        wget \
        zip \
        unzip \
        ruby \
        ruby-rdoc \
        ruby-irb \
        ruby-dev \
        openssh \
        g++ \
        python \
        py-crcmod \
        bash \
        openssh-client \
        gnupg \
        make \
        imagemagick \
    && rm -rf /tmp/* /var/tmp/*

RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-2.26-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-bin-2.26-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-i18n-2.26-r0.apk

RUN apk add glibc-2.26-r0.apk
RUN apk add glibc-bin-2.26-r0.apk
RUN apk add glibc-i18n-2.26-r0.apk
RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8

RUN gem install fastlane -v 2.117.1

## installing gcloud 

ENV PATH /google-cloud-sdk/bin:$PATH
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud --version

ADD https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip sdk-tools-linux.zip

RUN unzip sdk-tools-linux.zip -d ${ANDROID_HOME} && \
    rm sdk-tools-linux.zip && \
    echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}"

