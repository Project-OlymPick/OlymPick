FROM ubuntu:latest
LABEL authors="thdtjdals__"

ENTRYPOINT ["top", "-b"]

# 베이스 이미지로 Azul Zulu OpenJDK 17을 사용
FROM azul/zulu-openjdk:17

# 작업 디렉토리를 설정
WORKDIR /app

# Gradle Wrapper 및 설정 파일 복사
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Gradle Wrapper에 실행 권한 부여
RUN chmod +x gradlew

# 소스 코드 복사
COPY src src

# 의존성을 다운로드하고 애플리케이션 빌드 (테스트 건너뛰기)
RUN ./gradlew build --no-daemon -x test

# 빌드된 JAR 파일을 작업 디렉토리로 복사 (빌드 후의 경로 확인)
RUN mkdir -p build/libs
COPY build/libs/*.jar app.jar

# 애플리케이션 실행 명령어
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

# 애플리케이션이 사용하는 포트
EXPOSE 8080
