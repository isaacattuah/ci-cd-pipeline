# ----------------------------------------------------------------------------------------------------------------------
# CREATE Cloud Run SA
# ----------------------------------------------------------------------------------------------------------------------
# Service Account
resource "google_service_account" "cloud-run-sa" {
    project = var.project_id
    account_id   = "cloud-run-sa"
    display_name = "cloud-run-sa"
}
resource "google_project_iam_member" "service_account-roles" {
    project = var.project_id
    for_each = toset(var.cloud_run_iam_roles)
    role    = "roles/${each.value}"
    member  = "serviceAccount:${google_service_account.cloud-run-sa.email}"
    depends_on = [
        google_service_account.cloud-run-sa
        ]
}