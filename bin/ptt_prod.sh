#!/bin/bash
APP_NAME=Ptt
LOW_APP_NAME=ptt
APP_PATH=$BHOME/src/$APP_NAME 
APP_USER=$BSER
FCGI_TCP_CONNECTION=127.0.0.1:55901
PID_PATH=/var/run/$APP_NAME.prod.pid
NPROC=5

case $1 in
start)
    if [ -r "$PID_PATH" ] && kill -0 $(cat "$PID_PATH") >/dev/null 2>&1
    then
        echo " PROD $APP_NAME already running"
        exit 0
    fi

    echo -n "Starting PROD $APP_NAME (${LOW_APP_NAME}_fastcgi.pl)..."

    touch "$PID_PATH"
    chown "$APP_USER" "$PID_PATH"

    cd "$APP_PATH"
    su -c "\"script/${LOW_APP_NAME}_fastcgi.pl\"\\
       --listen $FCGI_TCP_CONNECTION\\
       --pidfile \"$PID_PATH\"\\
       --nproc $NPROC\\
       --keeperr 2 &" "$APP_USER"

    # Wait for the app to start  
    TIMEOUT=10; while [ ! -r "$PID_PATH" ] && ! kill -0 $(cat "$PID_PATH")
    do
        echo -n '.'; sleep 1; TIMEOUT=$((TIMEOUT - 1))
        if [ $TIMEOUT = 0 ]; then
            echo " ERROR: TIMED OUT"; exit 0
        fi
    done
    echo " started."
    ;;

stop)
    echo -n "Stopping PROD $APP_NAME: "
    if [ -r "$PID_PATH" ] && kill -0 $(cat "$PID_PATH") >/dev/null 2>&1
    then
        PID=`cat $PID_PATH`
        echo -n "killing $PID... "; kill $PID
        echo -n "OK. Waiting for the FastCGI server to release the
        port..."
        TIMEOUT=60
        while netstat -tnl | grep -q $FCGI_TCP_CONNECTION; do
            echo -n "."; sleep 1; TIMEOUT=$((TIMEOUT - 1))
            if [ $TIMEOUT = 0 ]; then
                echo " ERROR: TIMED OUT"; exit 0
            fi
        done
        echo " OK."
    else
        echo "PROD $APP_NAME not running."
    fi
    ;;

restart|force-reload)
    $0 stop
    echo -n "A necessary sleep... "; sleep 2; echo "done."
    $0 start
    ;;

*)
    echo "Usage: $0 { stop | start | restart }"
    exit 1
    ;;
esac
