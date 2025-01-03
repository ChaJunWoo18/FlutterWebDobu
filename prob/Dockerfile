# Flutter 빌드 환경
FROM cirrusci/flutter:stable AS build-env

# Flutter 설치(chrome, java,  android studio필요)
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN useradd -ms /bin/bash flutteruser

WORKDIR /app/
COPY . /app/
USER flutteruser

# RUN chown -R flutteruser:flutteruser /app

RUN flutter pub get
RUN flutter build web

FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html


# # 최종 배포 환경 (Nginx)
# FROM nginx:alpine

# # 빌드된 Flutter 웹 애플리케이션을 Nginx 디렉토리로 복사
# COPY --from=build /app/build/web /usr/share/nginx/html

# # # Nginx 서버 실행
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
