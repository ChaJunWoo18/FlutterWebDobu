# FROM ubuntu:24.04 as build-env

# RUN dpkg --print-architecture
# RUN dpkg --print-foreign-architectures
# RUN dpkg --add-architecture i386
# RUN dpkg --print-foreign-architectures
# RUN apt-get update

# RUN apt-get install -y libc6:i386
# # RUN apt-get install -y libncurses5:i386
# RUN apt-get install -y libncurses6:i386
# RUN apt-get install -y libstdc++6:i386

# RUN apt-get install -y \
#     curl \
#     unzip \
#     zip \
#     git \
#     wget \
#     bash \
#     xz-utils \
#     libglu1-mesa \
#     software-properties-common \
#     openjdk-8-jdk \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# # 작업 디렉토리 설정
# WORKDIR /opt

# # chrome 설치
# RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
#     add-apt-repository "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" && \
#     apt-get update && \
#     apt-get install -y google-chrome-stable && \
#     rm -rf /var/lib/apt/lists/*
# #RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# #RUN apt install -y ./google-chrome-stable_current_amd64.deb

# ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
# ENV PATH="$JAVA_HOME/bin:$PATH"
# RUN java -version

# # android studio 설치
# # RUN apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 
# RUN apt-add-repository ppa:maarten-fonville/android-studio
# RUN apt-get install -y android-studio

# # Flutter SDK를 GitHub에서 클론
# RUN git clone https://github.com/flutter/flutter.git /opt/flutter
# ENV PATH="/opt/flutter/bin:${PATH}"
# RUN flutter doctor
# COPY pubspec.yaml .
# RUN flutter pub get

# Flutter SDK 설치 이미지를 사용하여 Flutter 애플리케이션 빌드
FROM cirrusci/flutter:stable AS build

# Flutter 설치
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Flutter 설치
RUN git clone https://github.com/flutter/flutter.git /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"

# Flutter 버전 지정 (필요에 따라)
RUN flutter --version

# 작업 디렉토리 설정
WORKDIR /app

# Flutter 프로젝트 파일 복사
COPY . .

# Flutter 의존성 설치
RUN flutter pub get

# Flutter 웹 애플리케이션 빌드
RUN flutter build web

# 최종 배포 환경
FROM nginx:alpine

# 빌드된 Flutter 웹 애플리케이션을 Nginx 디렉토리로 복사
COPY --from=build /app/build/web /usr/share/nginx/html

# Nginx 서버 실행
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
