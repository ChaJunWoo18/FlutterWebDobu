FROM ubuntu:24.04 as build-env

# 필수 패키지 설치 및 시스템 업데이트
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    bash \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-8-jdk \
    software-properties-common \
    libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 \
    && apt-add-repository ppa:maarten-fonville/android-studio \
    && apt-get install -y android-studio \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Java 환경 변수 설정
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Flutter SDK 설치
RUN git clone https://github.com/flutter/flutter.git -b stable /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"

# Flutter 의존성 다운로드
RUN flutter precache

# Chrome 설치
RUN wget -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -y ./google-chrome.deb \
    && rm google-chrome.deb

# 애플리케이션 작업 디렉토리 설정
WORKDIR /app

# pubspec.yaml 파일 복사 및 Flutter 의존성 설치
COPY pubspec.yaml .
RUN flutter pub get

# Flutter 애플리케이션 코드 복사 및 웹 빌드
COPY . .
RUN flutter build web

# 최종 배포 환경
FROM nginx:1.21.1-alpine

# 빌드된 Flutter 애플리케이션을 Nginx 디렉토리로 복사
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Nginx 서버 실행
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
