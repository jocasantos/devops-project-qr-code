# Documentation 

### Create dockerfiles for frontend and api, and test it
- Create front-end dockerfile
```
docker build
```
- and test it locally
```
docker run
```
> Open localhost:3000 on your browser and you should see the website.

- Create api dockerfile
```
docker build
```
- Test it locally
```
docker run
```
> Open 0.0.0.0:8000 on your browser and you should see a established connection.

### Create your CI/CD pipeline and configure the CI part (build and push Docker images to a repository)
- I used GitHub Actions and DockerHub
- Create a deploy-example.yml file in .github > workflows folder
- First add the DockerHub credentials to the repository secrets in GitHub console or by GitHub CLI
- Write the first part of the pipeline (CI) and test it. I created mine with simple versioning tag for the front-end and api images.

### Create a EKS Cluster
1. Prerequisites:
  - kubectl
  - eksctl
  - helm
