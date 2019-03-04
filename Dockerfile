FROM openjdk:alpine

LABEL maintainer "Yosef Sugiarto (yosef.sugiarto@gmail.com)"


ENV ANDROID_SDK_TOOLS_VERSION="4333796"
ENV ANDROID_HOME="/usr/local/android-sdk"
ENV ANDROID_VERSION=28
ENV ANDROID_BUILD_TOOLS_VERSION=28.0.3
ENV FASTLANE_VERSION=2.116.1
ENV GLIBC_VERSION=2.29-r0

ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip"
ENV DOWNLOAD_FILE=/tmp/sdk.zip

# Deps
RUN apk add --update \
    ca-certificates \
    wget \
    unzip \
    libstdc++ \
    g++ \
    make \
    ruby \
    ruby-irb \
    ruby-dev \
    && rm -rf /var/cache/apk/*

# Fastlane
RUN gem install fastlane -N -v $FASTLANE_VERSION

# Android SDK
RUN mkdir -p "$ANDROID_HOME" \
    && wget -q -O "$DOWNLOAD_FILE" $SDK_URL \
    && unzip "$DOWNLOAD_FILE" -d "$ANDROID_HOME" \
    && rm "$DOWNLOAD_FILE" \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --update \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses


# Android Build Tools
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

