FROM cirrusci/flutter:stable AS build

RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    zip \
    wget \
    
    wget apt-transport-https ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Flutter 설치(chrome, java,  android studio필요)
RUN git clone https://github.com/flutter/flutter.git /opt/flutter
RUN dpkg --add-architecture i386
RUN apt-get update 
RUN apt-get install -y libc6:i386 libncurses6:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

RUN apt-get install -y \
    bash \
    xz-utils \
    libglu1-mesa \
    software-properties-common \
    openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"
RUN java -version
RUN apt-get update && apt-get install -y \
    wget gnupg2 apt-transport-https ca-certificates && \
    rm -rf /var/lib/apt/lists/*
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \ 
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get -y install google-chrome-stable


# 비루트 사용자 추가
RUN useradd -ms /bin/bash flutteruser

# Flutter 디렉토리 권한 변경
RUN chown -R flutteruser:flutteruser /opt/flutter

# 작업 디렉토리 설정
WORKDIR /app

# Flutter 프로젝트 파일 복사
COPY . .

# 앱 파일 권한 변경
RUN chown -R flutteruser:flutteruser /app

# Flutter PATH 설정
ENV PATH="/opt/flutter/bin:${PATH}"

# Flutter 명령어 실행을 위해 사용자 변경
USER flutteruser

RUN flutter doctor 

# Flutter 의존성 설치
RUN flutter pub get

# Flutter 웹 애플리케이션 빌드
RUN flutter build web

# 빌드 후 웹 디렉토리 확인
RUN ls -l /app/build/web

# 최종 배포 환경
FROM nginx:alpine

# 빌드된 Flutter 웹 애플리케이션을 Nginx 디렉토리로 복사
COPY --from=build /app/build/web /usr/share/nginx/html

# Nginx 서버 실행
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
