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

### Create your storage (S3 bucket) and configure API accordingly
- You can use my terraform config or just create by the cli/console.
- Replace in your api folder > main.py > bucket_name = os.getenv("S3_BUCKET") 
> This will get the bucket name from the environment variables
- Replace in your api folder > main.py > s3 = boto3.client('s3')
- Delete the .env file 
> I don't need to specify my aws credentials since I'm using EKS (roles based permissions)

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

2. Create the cluster (I'm using fargate)
`eksctl create cluster --name qr-code-cluster --region eu-north-1 --fargate`
  - Delete cluster
  `eksctl delete cluster --name qr-code-cluster --region eu-north-1`

3. Configuring kubectl for EKS
`aws eks --region eu-north-1 update-kubeconfig --name qr-code-cluster`

4. Verify the connection
`kubectl get svc`

5. Create a fargate profile
```
eksctl create fargateprofile \
    --cluster qr-code-cluster \
    --region eu-north-1 \
    --name qr-code-app \
    --namespace qr-code
```
> Note: This command will create a namespace called qr-code besides the fargate profile.

6. Create the namespace
`kubectl create namespace qr-code`

7. Configure IAM OIDC provider:
  `export cluster_name=qr-code-cluster`
  `oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)`
  - Check if there is an IAM OIDC provider configured already
  `aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4`
  - If not, run the below command
  `eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve`

### Create the IAM Role for pod communication with s3
- Create an IAM policy (read and write for s3)
```
aws iam create-policy --policy-name S3ReadWritePolicy \
  --description "Allow read and write access to S3" \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource": [
          "arn:aws:s3:::<your-bucket-name>", 
          "arn:aws:s3:::<your-bucket-name>/*"
        ]
      }
    ]
  }'
```

- Create an IAM Role
```
eksctl create iamserviceaccount \
  --name s3-access-sa \
  --namespace qr-code \
  --cluster qr-code-cluster \
  --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/S3ReadWritePolicy \
  --approve
```

### Deploy your app
- Apply your deployments.yml, services.yml and ingress.yml files for the front-end and api

### ALB Configuration
- Download IAM policy
```
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
```
- Create IAM Policy
```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
```
- Create IAM Role
```
eksctl create iamserviceaccount \
  --cluster=qr-code-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```

### Deploy ALB controller
- Add helm repo
```
helm repo add eks https://aws.github.io/eks-charts
```
- Update the repo
```
helm repo update eks
```
- Install
```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
  --set clusterName=qr-code-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=eu-north-1 \
  --set vpcId=<your-vpc-id>
```
- Verify that the deployments are running.
```
kubectl get deployment -n kube-system aws-load-balancer-controller
```
> Can take a minute to deploy your alb

- Get the Ingress adress and check it on your browser!
`kubectl get ingress -n qr-code`


> Congratulations! :tada::tada::tada:



