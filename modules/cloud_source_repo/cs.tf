# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A GOOGLE CLOUD SOURCE REPOSITORY
# ---------------------------------------------------------------------------------------------------------------------

# Enable API
resource "google_project_service" "enabled_services" {
  for_each = toset(var.services_to_enable)
  project  = var.project_id
  service  = each.key
}



# Make Cloud Source Repo
resource "google_sourcerepo_repository" "repo" {
   depends_on = [
    google_project_service.enabled_services
  ]    
  name = var.repository_name
}

# Clone Existing Repo and Push to Cloud Source Repo
resource "time_sleep" "sleep_x" {
  create_duration = "30s"
  depends_on = [
    google_sourcerepo_repository.repo
  ]
}

resource "null_resource" "git_clone" {

 # Clone local repo (# cp ${path.module}/files/* . on line 37 and touch test.txt for testing)
 provisioner "local-exec" {
   command = <<EOF
cd ./modules/cloud_source_repo/files
sed -i 's/$PROJECT_ID/${var.project_id}/g' ./deployment.yaml
cd ..
gcloud source repos clone example-repo
cp -r ./files/* example-repo
cd example-repo
git config --global user.email \"you@example.com\" 
git config --global user.name \"Your Name\" 
git add -A .
git commit -m "first commit"
git push origin master
cd ..
rm -rf example-repo
EOF
 }
depends_on = [
 time_sleep.sleep_x
]

}


#   # Clone local repo
#   provisioner "local-exec" {
#     command = "gcloud source repos clone example-repo"
#   }

#   provisioner "local-exec" {
#     command = "cd example-repo || touch test.txt"
#   }
  
# Pull the code from Github
#   provisioner "local-exec" {
#     command = "git clone https://github.com/vikramshinde12/config-service-googlesheet.git"
#   }

#   # Configure Git
#   provisioner "local-exec" {
#     command = "cd example-repo || git config --global user.email \"you@example.com\" || git config --global user.name \"Your Name\" && git add ."
#   }

#   # Push to Cloud Repo
#   provisioner "local-exec" {
#     command = "cd example-repo || git commit -m \"First file using Cloud Source Repositories\" || git push origin master"
#   }
# depends_on = [
#   google_sourcerepo_repository.repo
# ]

