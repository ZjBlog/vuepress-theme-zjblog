workflow "New workflow" {
  on = "push"
  resolves = ["Message"]
}

action "Master" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  args = "branch master"
}

action "Install" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  needs = ["Master"]
  args = "install"
}

action "Deploy" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  needs = ["Master"]
  args = "publish --access public"
  secrets = ["NPM_AUTH_TOKEN"]
}
action "Message" {
  uses = "ZjBlog/message@master"
  needs = ["Deploy"]
  secrets = ["URL"]
  env = {
    MESSAGE = "npm包发布成功"
  }
}
