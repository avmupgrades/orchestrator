locals {
  # Concat with repos.json name
  commit_email = "terraform@orchestrator.avmupgrades"
}
resource "github_repository_file" "ga_workflow_main_updates" {
  repository          = "terraform-azurerm-avm-res-documentdb-databaseaccount"
  branch              = "main" # or whichever branch you want to add the file to
  file                = ".github/workflows/avmupgrades_update_dependabot.yml"
  content             = file("${path.module}/../files/avmupgrades_update_dependabot.yml")
  commit_message      = "[AVMUpgrades] Add GitHub Action workflow to update main branch"
  commit_author       = "Terraform"
  commit_email        = local.commit_email
  overwrite_on_create = true
}
