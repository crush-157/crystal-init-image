FROM crystallang/crystal
RUN mkdir /tmp/crystal-cache
ENV CRYSTAL_CACHE_DIR /tmp/crystal-cache
RUN mkdir /tmp/iofs
WORKDIR /app
COPY helper.cr lib/
