# ----------------------------------------------------------------------------------------------------------------------
# CREATE SERVICE ACCOUNT & Permissions
# ----------------------------------------------------------------------------------------------------------------------
# GKE Node SA
resource "google_service_account" "gke-node-sa" {
    account_id   = "gke-node-sa"
    display_name = "gke node sa"
    depends_on = [
        google_project_service.enable-services
    ]
}
resource "google_project_iam_member" "service_account-roles" {
    project = var.project_id
    for_each = toset(var.gke_service_account_roles)
    role    = "roles/${each.value}"
    member  = "serviceAccount:${google_service_account.gke-node-sa.email}"
    depends_on = [
        google_service_account.gke-node-sa
        ]
}