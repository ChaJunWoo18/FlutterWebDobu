# Flutter 빌드 환경
FROM cirrusci/flutter:stable AS build

# 작업 디렉토리 설정
WORKDIR /app

# Flutter 프로젝트 파일 복사
COPY . .

# Flutter 설치(chrome, java,  android studio필요)
RUN git clone https://github.com/flutter/flutter.git /opt/flutter
# Flutter 의존성 설치
RUN flutter pub get

# Flutter 웹 애플리케이션 빌드
RUN flutter build web

# 빌드 후 웹 디렉토리 확인
RUN ls -l /app/build/web

# 최종 배포 환경 (Nginx)
FROM nginx:alpine

# 빌드된 Flutter 웹 애플리케이션을 Nginx 디렉토리로 복사
COPY --from=build /app/build/web /usr/share/nginx/html

# Nginx 서버 실행
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
