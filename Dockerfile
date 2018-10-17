FROM php:5-apache

RUN set -ex \
    && apt-get update && apt-get install -y --no-install-recommends \
        gnupg \
    && curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        libicu-dev \
        libpq-dev \
        libpq5 \
    && docker-php-ext-install  \
        intl \
        pcntl \
        pdo \
        pgsql \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
	&& cd /usr/local/src/ \
    && curl -O https://excellmedia.dl.sourceforge.net/project/pgstatsinfo/pg_stats_reporter/3.3.1/pg_stats_reporter-3.3.1.tar.gz \
    && tar xvf pg_stats_reporter-3.3.1.tar.gz \
    && rm -rf pg_stats_reporter-3.3.1.tar.gz \
    && cd pg_stats_reporter-3.3.1 \
    && cp pg_stats_reporter_lib/pg_stats_reporter.ini.sample /etc/pg_stats_reporter.ini \
    && cp -R html/pg_stats_reporter /var/www/html \
    && cp -R pg_stats_reporter_lib /var/www \
    && cp bin/pg_stats_reporter /usr/local/bin \
    && chown www-data:www-data /var/www/pg_stats_reporter_lib/cache /var/www/pg_stats_reporter_lib/compiled

