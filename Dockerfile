FROM ubuntu:focal AS base
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt upgrade -y

FROM base AS redis
RUN apt install redis-server -y && apt clean
EXPOSE 6379
CMD ["redis-server", "/etc/redis/redis.conf"]

FROM base AS sentinel
RUN apt install redis-sentinel -y && apt clean
EXPOSE 26379
CMD ["redis-sentinel", "/etc/redis/sentinel.conf"]
