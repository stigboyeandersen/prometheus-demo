terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.10"
    }
  }
}

provider "grafana" {
  url  = "http://api-prometheus-grafana.local"
  auth = "glsa_rP84le1VRifB3LiyMGmodjym0Q4IXnsJ_f87991f9"
}

# resource "grafana_contact_point" "email_alert" {
#   name = "email"

#   email {
#     addresses = ["stigboyeandersen@gmail.com"]
#   }
# }

# resource "grafana_notification_policy" "default_policy" {
#   contact_point = grafana_contact_point.email_alert.name
#   group_by = ["alertname"]

#   policy {
#     contact_point = grafana_contact_point.email_alert.name
#   }
# }

# resource "grafana_folder" "alerts" {
#   title = "Terraform Alerts"
# }