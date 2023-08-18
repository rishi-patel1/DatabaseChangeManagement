echo "Hello World"
ibm_cloud_login() {
              echo "INFO : Login to IBM Cloud account ... "
              ibmcloud config --check-version false
              ibmcloud login -a https://cloud.ibm.com --apikey rf7_LUzhtxwznAjGK-9ZK6SHuFMaTAHi3uwgVyWJCjDB --no-region; login_status=$?;
              ibmcloud ks cluster config -c $CLUSTER_ID > /artifacts/config_tmp.txt; rm -rf /artifacts/config_tmp.txt
          }

get_job_status(){
    jobStatus=$(kubectl get pods | grep '\bflyway\b' |  awk '{print $3}')
    echo jobStatus is $jobStatus
    while [[ $jobStatus -eq "Running" || $jobStatus -eq "Pending" || $jobStatus -eq "ContainerCreating" ]];
    do 
        sleep 10;
        jobStatus=$(kubectl get pods | grep '\bflyway\b' |  awk '{print $3}');
        echo jobStatus is $jobStatus
    done
}
ibm_cloud_login
# kubectl get pods
cd ../../pg-flyway-db-migration
echo INFO: inside flyway folder; ls;
export DB_PASS=$DB_PASS
# cat pg-flyway-job.yaml
isFlywayJobPresent=$(kubectl get pods | grep flyway)
if [[ -z $isFlywayJobPresent ]];then
    echo job not present
else
    kubectl delete -f pg-flyway-job.yaml; sleep 30;
fi       
kubectl apply -f pg-flyway-job.yaml; sleep 10;
get_job_status
kubectl logs `kubectl get pods | grep '\bflyway\b' |  awk '{print $1}'` > flyway_output.txt
