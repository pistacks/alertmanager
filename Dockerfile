FROM pistacks/alpine as builder

WORKDIR /tmp

ADD https://github.com/prometheus/alertmanager/releases/download/v0.20.0/alertmanager-0.20.0.linux-armv7.tar.gz /tmp/alertmanager-0.20.0.linux-armv7.tar.gz
RUN tar -xf alertmanager-0.20.0.linux-armv7.tar.gz

FROM scratch
COPY --from=builder /tmp/alertmanager-0.20.0.linux-armv7/alertmanager /bin/alertmanager
COPY --from=builder /tmp/alertmanager-0.20.0.linux-armv7/amtool /bin/amtool
COPY --from=builder /tmp/alertmanager-0.20.0.linux-armv7/alertmanager.yml /etc/alertmanager/alertmanager.yml

EXPOSE     9093
VOLUME     [ "/alertmanager" ]
WORKDIR    /alertmanager
ENTRYPOINT [ "/bin/alertmanager" ]
CMD        [ "--config.file=/etc/alertmanager/alertmanager.yml", \
             "--storage.path=/alertmanager" ]
