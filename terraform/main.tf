data "local_file" "repos" {
  filename = "${path.module}/repos.json"
}


locals {
  repos_list = jsondecode(data.local_file.repos.content)
  repos = { for repo in local.repos_list : repo.name => repo }
}

resource "null_resource" "create_forks" {
  for_each = local.repos

  provisioner "local-exec" {
    command = <<EOT
      curl -X POST -H "Authorization: Bearer ${var.github_app_jwt_token}" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/repos/Azure/${each.value.repo}/forks \
      -d '{"organization": "${var.organization}"}'
    EOT
  }
}

data "github_repository" "forks" {
  for_each = local.repos

  full_name = "${var.organization}/${each.value.name}"

  depends_on = [ null_resource.create_forks ]
}
