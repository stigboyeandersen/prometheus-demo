# Prometheus demo
The following links provides background info for this demo:

- [Prometheus overview](https://devopscube.com/prometheus-architecture/)
- [Prometheus operator](https://prometheus-operator.dev)

## Setup
The following assumes that ```Helm``` has been installed and a ```Kubernetes``` cluster has been configured and selected.

Add and update the Helm repos needed by running this command:
```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Install Prometheus stack
```sh
kubectl create namespace prometheus
helm install prometheus prometheus-community/kube-prometheus-stack -f helm/kube-prometheus-stack-values.yaml
```

Install nginx ingress controller
```sh
kubectl create namespace nginx-ingress
helm install nginx-ingress bitnami/nginx-ingress-controller -f helm/nginx-ingress-controller-values.yaml
```

Install Prometheus black box exporter
```sh
kubectl create namespace prometheus-blackbox
helm install prometheus-blackbox prometheus-community/prometheus-blackbox-exporter -f helm/prometheus-blackbox-exporter-values.yaml
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

## Access
To access the various parts of the demo use the links below:

- http://prometheus-server.local
- http://prometheus-alertmanager.local
- http://prometheus-grafana.local
- http://web.local

To get the Grafana admin password run the following command:


## Grafana

To get access to the default Grafana installation run the following to get the password for the admin user:

```sh
kubectl get secrets prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```

To find premade dashboards check this site: https://grafana.com/grafana/dashboards/. For the nginx web server used in this demo the dashboard with id ´´´2949´´´ can be used. 