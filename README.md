# Prometheus demo

## Links
- [Prometheus overview](https://devopscube.com/prometheus-architecture/)
- [Prometheus operator](https://prometheus-operator.dev)
- http://prometheus-server.local
- http://prometheus-alertmanager.local
- http://prometheus-grafana.local
- http://web.local

## Setup
The following assumes that ```Helm``` has been installed and a ```Kubernetes``` cluster has been configured and selected.

Add and update the Helm repos needed by running this command:
```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Install nginx ingress controller
```sh
kubectl create namespace nginx-ingress
helm install nginx-ingress bitnami/nginx-ingress-controller -f helm/nginx-ingress-controller-values.yaml
```

Install Prometheus stack
```sh
kubectl create namespace prometheus
helm install prometheus prometheus-community/kube-prometheus-stack -f helm/kube-prometheus-stack-values.yaml
```

Run this to complete the installation and install the test website (~/git/private/prometheus)
```sh
k apply -k ./kustomize/overlay/test
```

Finally configure the following entries in the hosts file ```/etc/hosts```

```sh
127.0.0.1   prometheus-server.local
127.0.0.1   prometheus-alertmanager.local
127.0.0.1   prometheus-grafana.local
127.0.0.1   web.local
```