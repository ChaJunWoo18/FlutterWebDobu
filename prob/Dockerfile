FROM ubuntu:24.04 as build-env

RUN apt update
RUN apt upgrade -y
RUN apt install -y wget



# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    bash \
    snapd

# Snapd 활성화 및 Flutter 설치
RUN snap install flutter --classic
# android studio 설치
RUN apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
# chrome 설치
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb

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
