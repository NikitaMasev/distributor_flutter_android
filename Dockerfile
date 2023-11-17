#FROM dart:stable as builder
FROM plugfox/flutter:stable-android as builder

#ENV PORT=""
#ENV URL_SRC_CODE=""
#ENV LOC_DIR_SRC_CODE=""
#ENV PERIOD_UPDATE_SRC_CODE_MINUTE=""

#RUN apt-get -y update && apt-get -y upgrade
#RUN apt-get install snapd -y
#RUN apt-get install openjdk-8-jdk
#RUN snap install flutter --classic
COPY . /distributor_flutter_android
WORKDIR /distributor_flutter_android
RUN dart pub get
RUN dart compile exe ./lib/main.dart -o ./runner
CMD ["./runner"]