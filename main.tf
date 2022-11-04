terraform {
  required_providers {
    google = {
        version = "5.0.0"
    #   source = "/Users/luisenriquegonzalezrodriguez/go/src/github.com/hashicorp/terraform-provider-google"
    #   version = "4.41.0"
    }
  }
}


provider "google" {
  # Configuration options
  project = "svc-project-1fae"
}



resource "google_bigtable_instance" "instance" {
  name = "tf-instance"
  cluster {
    cluster_id   = "tf-instance-cluster-1"
    num_nodes    = 3
    zone         = "us-central1-a"
    storage_type = "HDD"
  }

  cluster {
    cluster_id   = "tf-instance-cluster-2"
    zone         = "us-central1-b"
    num_nodes    = 3
    storage_type = "HDD"
  }
  deletion_protection = false
}

resource "google_bigtable_table" "table" {
  name          = "tf-table"
  instance_name = google_bigtable_instance.instance.name

  column_family {
    family = "name"
    gc_policy {
       mode = "UNION"

        max_age {
          duration = "110h" # 7 days
        }

        max_version {
          number = 9
        }
        # max_age {
        #     duration = "130h"
        # }
        # mode = "UNION"
        # gc_rules = "1"
    }
  }

  column_family {
    family = "password2"
    gc_policy {
      max_version {
        number = "12" # 7 days
      }
    }
  }

  column_family {
    family = "column1"
    gc_policy {
      # max_version {
      #   number = 11
      # }
      max_age {
        duration = "9h" # 7 days
      }
    }
  }

  column_family {
    family = "column2"
    gc_policy {
      max_age {
        duration = "20h" # 7 days
      }
    }
  }

  # column_family {
  #   family = "column3"
  #   gc_policy {
  #     gc_rules = <<EOF
  #     {
  #       "mode": "union",
  #       "rules": [
  #         {
  #           "max_age": "10h"
  #         },
  #         {
  #           "mode": "intersection",
  #           "rules": [
  #             {
  #               "max_age": "2h"
  #             },
  #             {
  #               "max_version": 7
  #             }
  #           ]
  #         }
  #       ]
  #     }
  #     EOF
  #   }
  # }



   


#   column_family {
#     family = "column3"
#     gc_policy {
#       max_age {
#         duration = "120h" # 7 days
#       }
#     }
#   }


}

# resource "google_bigtable_gc_policy" "policy" {
#   instance_name = google_bigtable_instance.instance.name
#   table         = google_bigtable_table.table.name
#   column_family = "name"

#   max_age {
#     duration = "168h"
#   }
# }