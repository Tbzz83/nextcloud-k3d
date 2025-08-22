NAMESPACE=$1
SERVICE=$2
LOCAL_PORT=$3
K8S_SERVICE_PORT=$4

command="kubectl -n $NAMESPACE port-forward svc/$SERVICE $LOCAL_PORT:$K8S_SERVICE_PORT"
while true; do
      echo "--> $command"
      $command 2>&1 >/dev/null |
      while IFS= read -r line
      do
            echo "### $line"
            if [[ "$line" == *"portforward.go"* ]]; then
                  echo "Restarting port forwarding $command"
                  exit 1
            else
                  exit 0
            fi
      done
      sleep 0.1
      if [ $? -eq 0 ]; then
            break;
      fi
done

