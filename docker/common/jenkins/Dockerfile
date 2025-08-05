FROM jenkins/jenkins:alpine

USER root

RUN apk add --no-cache docker-cli-compose docker-cli-buildx

USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean pipeline-github"
