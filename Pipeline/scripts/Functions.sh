ibm_cloud_login() {
              echo "INFO : Login to IBM Cloud account ... "
              ibmcloud config --check-version false
              ibmcloud login -a https://cloud.ibm.com --apikey rf7_LUzhtxwznAjGK-9ZK6SHuFMaTAHi3uwgVyWJCjDB --no-region; login_status=$?;
              ibmcloud ks cluster config -c $CLUSTER_ID > /artifacts/config_tmp.txt; rm -rf /artifacts/config_tmp.txt
          }

get_job_status(){
    jobStatus=$(kubectl get pods | grep '\bflyway\b' |  awk '{print $3}')
    echo jobStatus is $jobStatus
    while [[ $jobStatus == "Running" || $jobStatus == "Pending" || $jobStatus == "ContainerCreating" ]];
    do 
        sleep 10;

        jobStatus=$(kubectl get pods | grep '\bflyway\b' |  awk '{print $3}');
        echo jobStatus is $jobStatus
        if [[ $jobStatus == "Completed" ]];
        then 
            echo inside if $jobStatus
            break
        fi
    done
}

send_slack_alert(){
    # slackTest=`cat flyway_output.txt`
    slackTest=`cat flyway_output.txt | sed "s/\"//g" | sed "s/\'//g" | awk '/Database:/ {p=1} p;'`
    echo $slackTest
    if [ -z "$slackTest" ]
    then
        echo "\$slackTest is empty"
        json="{\"text\": \"No Flyway Migration needed\n<$PIPELINE_RUN_URL| See the Pipeline logs> | Trigger by $TRIGGERED_BY \"}"
    else
        json='{"text": ":successful: Flyway Migration Job Completed Successfully\n'$slackTest'\n<'$PIPELINE_RUN_URL'| See the Pipeline logs> | Trigger by '$TRIGGERED_BY'"}'

    fi
    # echo $json
    # Sending Slack Alert
    curl -s -d "payload=$json" $SLACK_URL
}