echo "Hello World"
ibm_cloud_login() {
              echo "INFO : Login to IBM Cloud account ... "
              ibmcloud config --check-version false
              ibmcloud login -a https://cloud.ibm.com --apikey rf7_LUzhtxwznAjGK-9ZK6SHuFMaTAHi3uwgVyWJCjDB --no-region; login_status=$?;
              ibmcloud ks cluster config -c $CLUSTER_ID > /artifacts/config_tmp.txt; rm -rf /artifacts/config_tmp.txt
          }
ibm_cloud_login
kubectl get pods
cd ../../pg-flyway-db-migration
echo INFO: inside flyway folder; ls;
export DB_PASS=$DB_PASS
cat pg-flyway-job.yaml
envsubst < pg-flyway-job.yaml > pg-flyway-job1.yaml
kubectl delete -f pg-flyway-job1.yaml; sleep 5       
kubectl apply -f pg-flyway-job1.yaml; sleep 30;     
flyway_output=$(kubectl logs `kubectl get pods | grep '\bflyway\b' |  awk '{print $1}'`)
echo $flyway_output