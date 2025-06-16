# Prometheus demo
The following links provides background info for this demo:

- [Prometheus overview](https://devopscube.com/prometheus-architecture/)
- [Prometheus operator](https://prometheus-operator.dev)
- [Terraform Grafana provider](https://registry.terraform.io/providers/grafana/grafana/latest/docs)

## Setup
The following assumes that ```Helm``` has been installed and a ```Kubernetes``` cluster has been configured and selected.

Add and update the Helm repos needed by running this command:
```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add argo https://argoproj.github.io/argo-helm

helm repo update
```

#### Install Prometheus stack
```sh
kubectl create namespace prometheus
kubectl label namespace prometheus monitored-by=prometheus

helm install prometheus prometheus-community/kube-prometheus-stack -f helm/kube-prometheus-stack-values.yaml
```

#### Install nginx ingress controller
```sh
kubectl create namespace nginx-ingress
helm install nginx-ingress bitnami/nginx-ingress-controller -f helm/nginx-ingress-controller-values.yaml
```

#### Install Prometheus black box exporter
```sh
kubectl create namespace prometheus-blackbox
helm install prometheus-blackbox prometheus-community/prometheus-blackbox-exporter -f helm/prometheus-blackbox-exporter-values.yaml
```

#### Install Argo
```sh
kubectl create namespace argo-cd
helm install argo-cd argo/argo-cd -f helm/argo-cd-values.yaml
```

#### Install web site

Run this to complete the installation and install the test website (~/git/private/prometheus).

```sh
k apply -k ./kustomize/overlay/test
```

Note that in addition to the web site various other components needed for the monitoring to work is also installed.

#### Configure lookup (hosts file)

Add the following entries in the hosts file ```/etc/hosts``` to allow for easy access through the browser.

```sh
127.0.0.1   prometheus-server.local
127.0.0.1   prometheus-alertmanager.local
127.0.0.1   prometheus-grafana.local
127.0.0.1   argo-cd.local
127.0.0.1   web.local
```

Once the entries above has been configured the following links is working:

- http://prometheus-server.local
- http://prometheus-alertmanager.local
- http://prometheus-grafana.local
- http://api-prometheus-grafana.local
- http://argo-cd.local
- http://web.local

To get the Grafana admin password run the following command:

## Reconfigure

In case changes are made to one of the ```value.yaml``` files related to the Helm charts used the cooresponding Helm chart needs to be upgrade using a command like thie:

```sh
helm upgrade prometheus-blackbox prometheus-community/prometheus-blackbox-exporter -f helm/prometheus-blackbox-exporter-values.yaml
helm upgrade prometheus prometheus-community/kube-prometheus-stack -f helm/kube-prometheus-stack-values.yaml
helm upgrade argo-cd argo/argo-cd -f helm/argo-cd-values.yaml
```


## Passwords

### Grafana
To get access to the default Grafana installation run the following to get the password for the admin user:

```sh
kubectl get secrets prometheus-grafana -o jsonpath="{.data.admin-password}" -n prometheus | base64 -d ; echo
```

### Argo cd
To get access to the default Grafana installation run the following to get the password for the admin user:

```sh
kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```


To find premade dashboards check this site: https://grafana.com/grafana/dashboards/. For the nginx web server used in this demo the dashboard with id ´´´2949´´´ can be used. 