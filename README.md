## Devops POC task: 

Preparation 
	Goal
	Setup the challenge environment.

	Steps
Register for a free Google Cloud account here.
Google Cloud provides generous free tiers for all its services so your interview questions below can all be answered with a free tier. Be sure to check what is free on Google Cloud before you start the exercises.
Make sure Terraform, gcloud and kubectl are installed on your laptop and work with GCP.
Create a new GCP project for the challenge 

Requirements
Give the Project Viewer access to ray@apollo.io, david@apollo.io, and jonathan.pigree@apollo.io to your Google Cloud account so that we can inspect your infrastructure.

Docker 
Goal
	Containerize the hello-world Python app.
	
Steps
Create a Dockerfile to generate the Docker image
Build and push the Docker image into your GCP project’s registry.

Requirements
The Docker image should be runnable anywhere by default
The webapp should be served by passenger + nginx
Nginx access logs should be redirected to stdout
Nginx error logs should be redirected to stderr

	Files to submit
The Dockerfile and its attached files



Terraform 
Goal
Create a small GKE cluster with Terraform.

Steps
Write a Terraform module to deploy the GKE cluster
Apply it to your GCP project

Requirements
Cluster
Zonal
Minimal Kubernetes version should be 1.16
Horizontal Pod Autoscaling and HTTP Load Balancing addons should be activated
1 node pool attached to the cluster
Initial node count is 1
Autoscaling enabled from 1 to 3 instances
Node type is preemptible (cheap instances) “n1-standard-1” 
Nodes auto-repair and auto-upgrade options on

Files to submit
The Terraform module

Kubernetes
Goal
	Deploy the hello-world app into the GKE cluster created.

Steps
Write Kubernetes manifests/templates/code
Apply them to your cluster
Document your solution (architecture, deployment) as if you are explaining it to a new engineer with no background in Kubernetes (this is a test of your communication skills)

Requirements
The app must be accessible from a domain name (use <your project name>.<ip>.xip.io or a personal domain)
The app must be accessible using HTTPS. You can use letsencrypt-staging to create the certificates or another certificate provider.
The app must be able to autoscale depending on CPU usage from 2 to 4 instances 
The app should have an healthcheck setup with appropriate parameters
The app must be protected from full eviction (all instances removed at the same time)
Updating the app must not have downtime.

Files to submit
The Kubernetes manifests, templates, scripts wrote to deploy the app
The website domain name
Your solution’s documentation









# Solution: 
## Requirements
To be able to deploy  `k8s-hello-app` to k8s cluster, these tools must be installed:

[Google Cloud SDK](https://cloud.google.com/sdk/?utm_source=google&utm_medium=cpc&utm_campaign=emea-emea-all-en-dr-bkws-all-all-trial-e-gcp-1009139&utm_content=text-ad-none-any-DEV_c-CRE_253515221930-ADGP_Hybrid%20%7C%20AW%20SEM%20%7C%20BKWS%20~%20EXA_M%3A1_EMEA_EN_Developer_SDK_SEO-KWID_43700053284622903-aud-606988878134%3Akwd-506032303392-userloc_9062308&utm_term=KW_sdk%20google%20cloud-NET_g-PLAC_&gclid=CJXb28Pqxe0CFQNAHgIdFVMLNw) - needed for authentification for Google Cloud project where Kubernetes cluster resides.

[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - tool for interacting with Kubernetes cluster.

Google account with correct rights for particular project and cluster.

Docker registry of Your choice with public availability.
In this case we will use [DockerHub](https://hub.docker.com/)
## Steps

1. Build the docker image using code in this repository. We are building docker image with respective *username/repository:tag* `kalvkusk/k8s-hello-app:0.0.2`  
`docker build -t kalvkusk/k8s-hello-app:0.0.2 .`, don't forget the `.` at the end, it provides build context ( source directory from which source code will be taken)
2. Once the image is built, we need to push it to our docker registry, for it to be available for download in our Kubernetes cluster.
`docker push  kalvkusk/k8s-hello-app:0.0.2`
When this process has finished,  our image is ready for deployment.
3. For deployment we will need `kubectl` tool. To be able to use `kubectl` with our cluster, we need to get Kubernetes cluster credentials.
   1. Authentificate `gcloud` sdk using this command:
   `gcloud auth login`, follow the steps mentioned in command output.
   2. Gather Kubernetes cluster credentials(cluster and rights are already set up):
   `gcloud container clusters get-credentials apollo-io-poc-gke --zone europe-west1-b --project apollo-io-poc`
   3. Run `kubectl cluster-info` command to verify that kubectl authentification and access to cluster is working. Sample output:
   ```
    Kubernetes master is running at https://34.78.146.185
    GLBCDefaultBackend is running at https://34.78.146.185/api/v1/namespaces/kube-system/services/default-http-backend:http/proxy
    KubeDNS is running at https://34.78.146.185/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
    Metrics-server is running at https://34.78.146.185/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy
   ```
4. Initially we need our application to be deployed.
   1. Easiest way to do this, is with attached Kubernetes manifest in current repo `k8s/deployment-k8s-hello.yaml`. Manifest has all settings to be able to deploy the application. Check manifest for line `image: kalvkusk/k8s-hello-app:0.0.2`. If Your initial image differs, change it to the one You used in step 1. It is assumed that infrastructure guys have prepared Kubernetes environment ( Autoscaler, Ingress, Service, DNS subdomain )
   Run `kubectl apply -f k8s/deployment-k8s-hello.yaml`
   2. If You want to deploy updated version of the application e.g. `kalvkusk\k8s-hello-app:0.0.3`, run:
  `kubectl set image deployment/k8s-hello-app k8s-hello-app=kalvkusk/k8s-hello-app:0.0.3`
   This will trigger image change and rollingUpdate.
   3. Verify that rollout has finished succesfully:
  `kubectl rollout status deployment/k8s-hello-app`
   Sample output:
  `deployment "k8s-hello-app" successfully rolled out`

   4. Check that `pods` are up and running.  `kubectl get pods`
   Sample output for healthy `pods`:
    ```
    NAME                            READY   STATUS    RESTARTS   AGE
    k8s-hello-app-99979fc48-5n7pn   1/1     Running   0          6m28s
    k8s-hello-app-99979fc48-ww6v7   1/1     Running   0          6m27s
    ```  
5. If You run into issues, don't hesitate to reach out: kalvis.kuskis@gmail.com, slack, etc.
