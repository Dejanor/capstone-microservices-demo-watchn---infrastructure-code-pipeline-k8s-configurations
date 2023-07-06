# Capstone Project - Deploy Watchn

### Watchn Application
Link to Application repo: https://github.com/niallthomson/microservices-demo

### prerequisites for project
- aws account
- iam user with administrator access
- domain
- dockerhub account
- gitlab account

### prerequisites for pipeline
- remote backend for terraform state — a sample file to create s3 backend available in ./capstone-deploy/terraform/remote.tf
- namedotcom token
- create the following variables in gitlab:
```
AWS_ACCESS_KEY_ID   [variable.type: env_var]
AWS_CREDENTIALS     [variable.type: env_var]
AWS_DEFAULT_REGION  [variable.type: env_var]
REGISTRY_PASS       [variable.type: env_var]
REGISTRY_USER       [variable.type: env_var]
```
![gitlab variables](./capstone-deploy/screenshots/gitlab-variables.png)

## Breakdown
#### stage: infrastructure
- uses 'zenika/terraform-aws-cli:release-6.0_terraform-1.3.7_awscli-1.27.60' image to connect to aws and run terraform configuration
- takes in the following variables in the 'before_script' argument: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION
- script argument runs terraform configuration
- creates artifacts
#### stage: test
- uses 'docker:23.0.1-cli' image and it's 'docker:23.0.1-dind' service 
- takes in variable: DOCKER_TLS_CERTDIR: "/certs"
- has a before_script argument to install bash
- 'script' runs the test script
#### stage: build
- uses 'docker:23.0.1-cli' image and it's 'docker:23.0.1-dind' service 
- takes in variable: DOCKER_TLS_CERTDIR: "/certs"
- has a 'before_script' to login to dockerhub
- has 'script' that builds and pushes images to dockerhub
#### stage: deploy-to-dev
- uses 'dtzar/helm-kubectl:latest' image to connect to cluster and use helm
- has 'if: $CI_COMMIT_REF_NAME != $CI_DEFAULT_BRANCH' rule which makes 'deploy-to-dev' job to only run from dev branch
- has a 'before_script' which installs aws-iam-authenticator, helmfile and helm-diff plugin on job container
- has 'script' which deploys to dev environment
#### stage: deploy-to-prod
- uses 'dtzar/helm-kubectl:latest' image to connect to cluster and use helm
- has 'if: $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH' rule which makes 'deploy-to-prod' job to only run from master branch
- has a 'before_script' which installs aws-iam-authenticator, helmfile and helm-diff plugin on job container
- has 'script' which deploys to production environment
## What pipeline does
**stage 'infrastructure':** 
- contains the infrastructure job
- deploys and sets up cluster with terraform
- creates artifacts for credentials to connect to cluster in later jobs
- contains the get_cluster_credentials job which is to only get the cluster credentials from terraform after cluster has been created 
![infrastructure job](./capstone-deploy/screenshots/infrastructure-job.png)
![get_cluster_credentials job](./capstone-deploy/screenshots/get-cluster-credentials-job.png)


**stage 'test':**
- contains the "run_tests" job
- it builds the images for the source codes and tests the application before the build stage (the tests provided by the developers for the application failed, hence why it was skipped in the pipeline)
![run_tests job](./capstone-deploy/screenshots/run_tests-job.png)

**stage 'build':**
- contains the "build_images" job
- builds the images for the various microservices (ui, catalog, carts, orders, checkout, assets, activemq) and pushes to dockerhub account
![build job](./capstone-deploy/screenshots/build-images-job.png)

**stage 'deploy-to-dev':** 
- contains the "deploy-to-dev" job
- deploys watchn, prometheus and loki to dev environment cluster before production
![deploy-to-dev job](./capstone-deploy/screenshots/deploy-to-dev-job.png)

**stage 'deploy':**
- contains the "deploy-to-prod" job
- deploys watchn, prometheus and loki to production
![deploy-to-prod job](./capstone-deploy/screenshots/deploy-to-prod-job.png)

