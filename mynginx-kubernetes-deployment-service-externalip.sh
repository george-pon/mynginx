#!/bin/bash
#
# kubernetes にデプロイする
#

cat > mynginx-kubernetes-deployment-service-externalip.yaml << "EOF"
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
  type: ClusterIP
  externalIPs:
  -  172.28.9.51
  selector:
    app: mynginx
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 80
EOF

if kubectl delete -f mynginx-kubernetes-deployment-service-externalip.yaml ; then
    echo "delete success"
else
    echo "delete failure, but continue."
fi

kubectl apply -f mynginx-kubernetes-deployment-service-externalip.yaml

kubectl rollout status deploy/mynginx

# テストアクセス
curl http://172.28.9.51:8080/

# ログ表示
POD_LIST=$( kubectl get pod | grep mynginx | awk '{print $1}' )
for i in $POD_LIST
do
    kubectl logs $i
done

