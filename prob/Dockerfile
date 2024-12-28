# Flutter 빌드를 위한 환경 설정
FROM flutter:latest as build-env

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
FROM ubuntu:latest

# 빌드된 Flutter 애플리케이션을 Nginx 디렉토리로 복사
COPY --from=build-env /app/build/web /var/www/html

# Nginx 서버 실행 (이미 설치된 Nginx 사용)
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
