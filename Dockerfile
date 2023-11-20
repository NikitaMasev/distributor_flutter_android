FROM plugfox/flutter:stable-android

ENV PORT="4500"
ENV URL_SRC_CODE="https://github.com/NikitaMasev/home_monitor_app"
ENV LOC_DIR_SRC_CODE="home_monitor"
ENV PERIOD_CHECK_REPO="60"
ENV AWAITING_BEFORE_BUILD_MINUTE = "10"
ENV BRANCH_REM_SRC_CODE="main"
ENV BRANCH_LOC_SRC_CODE="origin"
ENV KEY=""
ENV IV=""

#EXPOSE ${PORT}

COPY . /distributor_flutter_android
WORKDIR /distributor_flutter_android
RUN dart pub upgrade
RUN dart pub get
RUN dart compile exe ./lib/main.dart -o ./runner
CMD ["./runner"]