#!/bin/sh

set -o errexit

cargo build

kill_all() {
    SERVICE='raft-key-value-rocks'
    if [ "$(uname)" = "Darwin" ]; then
        if pgrep -xq -- "${SERVICE}"; then
            pkill -f "${SERVICE}"
        fi
    else
        set +e # killall will error if finds no process to kill
        killall "${SERVICE}"
        set -e
    fi
}

rpc() {
    local uri=$1
    local body="$2"

    echo '---'" rpc(:$uri, $body)"

    {
        if [ ".$body" = "." ]; then
            time curl --silent "127.0.0.1:$uri"
        else
            time curl --silent "127.0.0.1:$uri" -H "Content-Type: application/json" -d "$body"
        fi
    } | {
        if type jq > /dev/null 2>&1; then
            jq
        else
            cat
        fi
    }

    echo
    echo
}

export RUST_LOG=trace
export RUST_BACKTRACE=full
bin=./target/debug/raft-key-value-rocks

echo "Killing all running raft-key-value-rocks and cleaning up old data"

kill_all
sleep 1

if ls 127.0.0.1:*.db
then
    rm -r 127.0.0.1:*.db || echo "no db to clean"
fi

echo "Start 1 uninitialized raft-key-value-rocks servers..."

${bin} --id 1 --http-addr 127.0.0.1:21001 --rpc-addr 127.0.0.1:22001 2>&1 > n1.log &
PID1=$!
sleep 1
echo "Server 1 started"

#echo "Initialize server 1 as a single-node cluster"
#sleep 2
#echo
#rpc 21001/cluster/init '{}'

#echo "Server 1 is a leader now"

#echo "Killing all nodes in 3s..."
#sleep 1
#echo "Killing all nodes in 2s..."
#sleep 1
#echo "Killing all nodes in 1s..."
#sleep 1
#kill_all

kill_all
