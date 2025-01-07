FROM ghcr.io/cirruslabs/flutter:3.27.1 AS build-env



RUN useradd -ms /bin/bash flutteruser

RUN chown -R flutteruser:flutteruser /sdks/flutter
# RUN chown -R flutteruser:flutteruser /code

COPY ./prob /code
WORKDIR /code
RUN chown -R flutteruser:flutteruser /code

USER flutteruser

RUN flutter pub get
RUN flutter build web
RUN ls -l ./build/web

FROM nginx:alpine
RUN ls -l /usr/share/nginx/html
COPY --from=build-env /code/build/web /usr/share/nginx/html
RUN ls -l /usr/share/nginx/html

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
