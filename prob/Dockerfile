FROM cirrusci/flutter:stable AS build-env

WORKDIR /app
RUN git config --global --add safe.directory /sdks/flutter
COPY . /app/

# RUN useradd -ms /bin/bash flutteruser
# USER flutteruser
RUN flutter pub get
RUN flutter build web

FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


# Flutter 설치
# RUN git clone https://github.com/flutter/flutter.git /opt/flutter
# ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# RUN useradd -ms /bin/bash flutteruser
# RUN chown -R flutteruser:flutteruser /opt/flutter
# COPY . /app/
# USER root
# RUN chown -R flutteruser:flutteruser /app

# # 사용자 변경
# USER flutteruser

# # Flutter 명령어 실행
# WORKDIR /app/
# RUN flutter pub get
# RUN flutter build web

# FROM nginx:1.21.1-alpine
# COPY --from=build-env /app/build/web /usr/share/nginx/html

# Nginx 실행
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
