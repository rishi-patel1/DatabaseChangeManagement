echo "Hello World"
ibm_cloud_login() {
              echo "INFO : Login to IBM Cloud account ... "
              ibmcloud config --check-version false
              ibm_cloud_login_retry(){
                ibmcloud login -a https://cloud.ibm.com --apikey rf7_LUzhtxwznAjGK-9ZK6SHuFMaTAHi3uwgVyWJCjDB --no-region; login_status=$?;
              }
              for login_retry in {1..3}; do
                  if [[ -z $(echo $login_status | grep "OK" )]] then
                    echo "INFO : trying to line $login_retry times in ibm account..."; ibm_cloud_login_retry
                  else 
                    echo LOGIN SUCCEEDED. INFO: $login_status
                    break
                  fi
              done
              ibmcloud ks cluster config -c $CLUSTER_ID > /artifacts/config_tmp.txt; rm -rf /artifacts/config_tmp.txt
          }
ibm_cloud_login
# kubectl get pods
cd ../../pg-flyway-db-migration
echo INFO: inside flyway folder; ls;
export DB_PASS=$DB_PASS
envsubst < pg-flyway-job.yaml > pg-flyway-job.yaml
cat pg-flyway-job.yaml
kubectl delete -f pg-flyway-job.yaml       
