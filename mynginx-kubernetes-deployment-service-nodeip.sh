#!/bin/bash
#
# kubernetes にデプロイする
#

cat > mynginx-kubernetes-deployment-service-nodelip.yaml << "EOF"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mynginx
  labels:
    app: mynginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mynginx
  template:
    metadata:
      labels:
        app: mynginx
    spec:
      containers:
      - name: mynginx-container
        image: docker.io/georgesan/mynginx:latest
        ports:
        - name: mynginx
          containerPort: 80
---
kind: Service
apiVersion: v1
metadata:
  name: mynginx
  labels:
    app: mynginx
spec:
  # type ClusterIP(default) / NodePort(for minikube) / LoadBalancer(for GKE)
  # type: NodePort
  type: NodePort
  selector:
    app: mynginx
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
    nodePort: 30081
EOF

if kubectl delete -f mynginx-kubernetes-deployment-service-nodelip.yaml ; then
    echo "delete success"
else
    echo "delete failure, but continue."
fi

kubectl apply -f mynginx-kubernetes-deployment-service-nodelip.yaml

kubectl rollout status deploy/mynginx

# テストアクセス
curl http://172.28.9.51:30081/

# ログ表示
POD_LIST=$( kubectl get pod | grep mynginx | awk '{print $1}' )
for i in $POD_LIST
do
    kubectl logs $i
done

