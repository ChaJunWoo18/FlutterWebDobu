# Flutter 빌드를 위한 환경 설정
FROM ubuntu:24.04 as build-env

# 필수 패키지 설치 (Flutter와 관련된 환경 설정)
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    xz-utils \
    git \
    bash

# Flutter SDK 다운로드 및 설치
RUN curl -LO https://storage.googleapis.com/download.flutter.io/flutter_linux_v3.13.2-stable.tar.xz
RUN tar xf flutter_linux_v3.13.2-stable.tar.xz
RUN mv flutter /opt/

# PATH에 Flutter 추가
ENV PATH="/opt/flutter/bin:${PATH}"

# Flutter 의존성 설치
RUN flutter doctor

# 작업 디렉토리 설정
WORKDIR /app

# pubspec.yaml 파일을 복사하고 Flutter 의존성 설치
COPY pubspec.yaml .
RUN flutter pub get

# 나머지 애플리케이션 코드 복사
COPY . .

# Flutter 웹 애플리케이션 빌드
RUN flutter build web

# 최종 배포 환경
FROM nginx:1.21.1-alpine

# 빌드된 Flutter 애플리케이션을 Nginx 디렉토리로 복사
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Nginx 서버 실행
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
