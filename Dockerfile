FROM ubuntu:latest AS jenkins-build
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk wget gnupg2 && \
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add - && \
    echo "deb https://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y jenkins && \
    rm -rf /var/lib/apt/lists/*

FROM ubuntu:latest AS apache2-build
RUN apt-get update && \
    apt-get install -y apache2 && \
    rm -rf /var/lib/apt/lists/*

FROM ubuntu:latest
COPY --from=jenkins-build /usr/share/jenkins /usr/share/jenkins
COPY --from=apache2-build /usr/sbin/apache2 /usr/sbin/apache2
COPY --from=apache2-build /etc/apache2 /etc/apache2
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80
