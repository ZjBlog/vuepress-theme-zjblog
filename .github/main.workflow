workflow "New workflow" {
  on = "push"
  resolves = [
    "GitHub Action for npm-3",
  ]
}

action "GitHub Action for npm" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  args = "install"
}

action "GitHub Action for npm-1" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  args = "install"
}

action "Filters for GitHub Actions-1" {
  uses = "actions/bin/filter@d820d56839906464fb7a57d1b4e1741cf5183efa"
  needs = ["GitHub Action for npm-1"]
  args = "branch master"
}

action "GitHub Action for npm-3" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  needs = ["Filters for GitHub Actions-1"]
  args = "publish --access public"
  secrets = ["NPM_AUTH_TOKEN"]
}
