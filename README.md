# netology-devops
edit

Игнорируются все файлы попадающие под эти маски:

**/.terraform/* - все файлы в любой папке .terraform
*.tfstate - все файлы заканчивающиеся на .tfstate
*.tfstate.* - имеющие в имени .tfstate.
crash.log - все файлы с именем crash.log
crash.*.log - все файлы начинающиеся с crash. и заканчивающиеся на .log
*.tfvars - все файлы заканчивающиеся на 
*.tfvars.json - все файлы заканчивающиеся на 
override.tf - все файлы с именем override.tf
override.tf.json - все файлы с именем override.tf.json
*_override.tf - все файлы заканчивающиеся на _override.tf
*_override.tf.json - все файлы заканчивающиеся на _override.tf.json
.terraformrc - все файлы с именем .terraformrc
terraform.rc - все файлы с именем terraform.rc
