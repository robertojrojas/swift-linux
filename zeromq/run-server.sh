source ./env_vars.sh
echo "ZMQ_LIBS ${ZMQ_LIBS}"
swift ${ZMQ_LIBS}  zeromq.swift
