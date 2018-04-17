# Terraform-modules

A good practice is to create a repository containing common infrastructure components which can be referenced and configured within other projects (e.g. web-app, rds-database, ecs-service etc.). Utilising Terraform modules to create 'building blocks' allows conventions to be enforced and standards defined for infrastructure (e.g. tags, security etc.). Modules are defined once then referenced and configured within projects using the repository URL/branch/tag/subfolder as the module source. This makes it easy for developers to define infrastructure as code within projects, achieve total ownership (provisioning and deploying as needed) and move fast. It also makes it easy to try out new concepts/ideas on isolated infrastructure. See [Standardizing Application Deployments Using Amazon ECS and Terraform](https://www.slideshare.net/AmazonWebServices/aws-reinvent-2016-gam401-riot-games-standardizing-application-deployments-using-amazon-ecs-and-terraform) for a more detailed introduction.

### TODO

- Add module readmes
- Add more modules
