provider "google" {
  credentials = file("eaproj.json")
  project     = "eaproj"
  region      = "us-central1"
  zone    = "us-central1-a"
}
resource "kubernetes_deployment" "user-ms" {
  metadata {
    name = "user-ms"
    labels = {
      ms-label = "user-ms-label"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        ms-label = "user-ms-label"
      }
    }

    template {
      metadata {
        labels = {
          ms-label = "user-ms-label"
        }
      }
      spec {  
        container {
          image = "islamahmad/eauser-ms:1.0.0"
          name  = "user-ms-container"
          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/user_ms_liveness"
              port = 8080

            #   http_header {
            #     name  = "X-Custom-Header"
            #     value = "Awesome"
            #   }
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
          env{
             name = "MYSQL_HOST"
            value = "mysql" 
          }
          env{
            name = "MYSQL_USER"
            value = "" 
          }
          env{
             name = "MYSQL_PORT"
            value = "" 
          }

          env{
             name  = "SERVICE_API_KEY" 
             value = ""
             }
         #  env{
         #     name = ""
         #     value = "" 
         #     } 
          env{  
            name = "MYSQL_PASSWORD" 
            value_from { 
               env_from {  "user-ms-config"}
               }
            }
         env_from  {
               config_map_ref  {  
                  name  = "user-ms-config" 
                  # key = "MYSQL_PASSWORD"
               # }
               }
         }
         #  env {
         #    name = "MYSQL_PASSWORD"
         #    value = {
         #       valueFrom {
         #          secretMapKeyRef {
         #             name = "user-ms-secret"
         #             key = "MYSQL_PASSWORD"
         #          }
         #       }           
         #    }
         #  }

        }
      }
    }
  }
}
