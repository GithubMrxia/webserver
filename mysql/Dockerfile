FROM mysql/mysql-server:5.7

RUN mkdir -p /mysql/data /mysql/log /mysql/files \
    && chown -R mysql:mysql /mysql

CMD ["mysqld"]