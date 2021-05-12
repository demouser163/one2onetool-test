
1. Setup AWS Cloud VM:
   - Create Terraform Code as follow
     * Create VPC
     * Create Public Subnet
     * Create Internet gateway
     * Create Routing Table
     * Create Routing Table Association
     * Create Security Group
       - open SSH port 22 for all (0.0.0.0/0)
       - open TCP Port 0 - 65535 (0.0.0.0/0)
     * Create AWS Launch Configuration
       - Volune: 10
       - instance type: t2.medium
       - Keyname: test-key
     * Create Autoscalling Group
       - Instance count 1
    
    - Code URL: https://github.com/demouser163/aws-terraform-demo.git

2. Connect AWS Server:
   - Place the ssh pem key (test-key.pem) into location
   - Change permission
       chmod 400 test-key.pem
   - Command to connect server:
       ssh -i "test-key.pem" ubuntu@public_ip-address

3. Install software
   - Install docker
      sudo apt-get update -y
      sudo apt-get install docker.io
      docker --version

   - Install Java:
      sudo apt-get update -y
      sudo apt install openjdk-11-jre-headless -y
      java -version 
 
   - Install Jenkins:
      wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
      vi /etc/apt/sources.list
      add at bottom -> deb https://pkg.jenkins.io/debian-stable binary/
      sudo apt-get update
      sudo apt-get install jenkins
      ps -ef | grep jenkins

   - Configure Jenkins:
     get the password: --> cat /var/log/jenkins/jenkins.log
     open URL --> public_ip-address:8080
     update the password
     install the plugins
     add credentials
4. Add the credentials
   Manage Jenkins --> Credentials --> add the github credentials

5. Install plugins
    Manage Jenkins --> Manage plugins --> Available
    NodeJs Plugin
    
6.  Create CICD pipeline Job:
    Create the free style job
    goto --> This project is parameterised --> select choice parameter
     - branch (staging,release)
     
    goto --> Source Code Management --> select Git --. add the github url
     https://github.com/demouser163/one2onetool-test.git

    Add github credentials 
    Branch specifier --> $branch

7. Build section:
   goto Build Environment --> Provide Node & npm bin/ folder to PATH --> NodeJS

   goto Build --> select Execute Shell
     echo $WORKSPACE
     cd $WORKSPACE
     echo "npm install"
     npm install
     echo "npm test"
     npm test

8. login to AWS VM
    Login into docker hub
    docker login [userid and password]

    goto Docker Build and publish
     repositiry name --> ramudocker15/nodejs-app
     Registory Credential --> [Manage Jenkins -> Credentials --> Docker hub Credential]

9. Verify the image into docker hub with latest timestamp
   URL: https://hub.docker.com/repository/docker/ramudocker15/nodejs-app

10. Containerize the application.
    Login to AWS VM
    pull the image
    docker pull ramudocker15/nodejs-app
    docker images
    docker run -p 3000:3000 ramudocker15/nodejs-app
    docker ps

    Output:
    CONTAINER ID   IMAGE                     COMMAND       CREATED             STATUS          PORTS                    NAMES
    87216882ced1   ramudocker15/nodejs-app   "npm start"   About an hour ago   Up 57 minutes   0.0.0.0:3000->3000/tcp   quizzical_colden

11. verify the URL
     http://public-ipaddress:3000/