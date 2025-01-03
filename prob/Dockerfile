FROM cirrusci/flutter:stable AS build-env

# Flutter 설치
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN mkdir /app/

# 비루트 사용자 추가
RUN useradd -ms /bin/bash flutteruser
RUN chown -R flutteruser:flutteruser /usr/local/flutter
RUN chown -R flutteruser:flutteruser /app
USER flutteruser

# 파일 복사 및 권한 설정
COPY . /app/
RUN chown -R flutteruser:flutteruser /app/
RUN chmod -R 755 /app/  # 권한 설정

WORKDIR /app/
RUN flutter pub get
RUN flutter build web

FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Nginx 실행
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
