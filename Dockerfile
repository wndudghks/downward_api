# 제공된 베이스 이미지를 기반으로 설정
FROM python:3.8-slim

# 작업 디렉토리 설정
WORKDIR /app

# 현재 디렉토리의 모든 파일을 컨테이너로 복사
ADD . /app

# curl 모듈 추가 설치
RUN apt-get update && apt-get install -y curl

# Flask 패키지 설치 (requirements.txt에 정의된 패키지 설치)
RUN pip install -r requirements.txt

# 로컬 타임존 설정 (한국 표준시)
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && echo Asia/Seoul > /etc/timezone

# Flask 애플리케이션의 포트 설정
EXPOSE 40003

# Flask 애플리케이션 실행
CMD ["python", "app.py"]

