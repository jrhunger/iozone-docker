# iozone-docker
* packaging [iozone](https://www.iozone.org/) in an alpine container for easily running in k8s cluster
* based on [acrelle/iozone](https://github.com/acrelle/iozone-docker) but modified to:
  * run as non-root
  * use multistage build so compilers, etc. are not in the runtime
  * use latest iozone (currently 3.506)

Available on Dockerhub as 1101010/iozone

## Usage
To run using default options:
```
docker run -rm 1101010/iozone
```

To specify options (options shown are the defaults):
```
docker run -rm 1101010/iozone -e -I -a -s 100M -r 4k -i 0 -i 1 -i 2
```

Run on all worker nodes of a kubernetes cluster:
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: iozone-local
spec:
  selector:
    matchLabels:
      name: iozone-local
  template:
    metadata:
      labels:
        name: iozone-local
    spec:
      containers:
        - name: iozone
          image: 1101010/iozone
          resources:
            requests:
              memory: "512Mi"
              cpu: "500m"
            limits:
              memory: "1Gi"
              cpu: "1"
          command: ["/bin/sh"]
          args: ["-c", "pwd; df -h .; while true; do date; iozone -s 100m -r 2m -I -i 0 -i 1 -t 1 -F $(hostname); sleep 60; done" ]
      restartPolicy: Always
```

