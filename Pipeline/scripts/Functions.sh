ibm_cloud_login() {
              echo "INFO : Login to IBM Cloud account ... "
              ibmcloud config --check-version false
              ibmcloud login -a https://cloud.ibm.com --apikey $API_KEY --no-region; login_status=$?;
              ibmcloud ks cluster config -c $CLUSTER_ID > /artifacts/config_tmp.txt; rm -rf /artifacts/config_tmp.txt
          }

get_job_status(){
    jobStatus=$(kubectl get pods | grep '\bflyway\b' |  awk '{print $3}')
    echo jobStatus is $jobStatus
    count=0
    while [[ $jobStatus == "Running" || $jobStatus == "Pending" || $jobStatus == "ContainerCreating" ]];
    do 
        sleep 10;
        $((count++))
        jobStatus=$(kubectl get pods | grep '\bflyway\b' |  awk '{print $3}');
        isError=$(echo $jobStatus | grep '\bflyway\b' |  awk '{print $3}' | grep Error)
        # echo jobStatus is $jobStatus
        if [[ -z $isError ]];
        then 
            echo INFO: No Errors, Job is $jobStatus after $(($count * 10)) seconds
        else
            SLACK_ERROR="THERE WERE ERRORS IN MIGRATION SQL FILES"
            break
        fi
        if [[ $jobStatus == "Completed" ]];
        then 
            break
        fi
    done
}

send_slack_alert(){
    # slackTest=`cat flyway_output.txt`
    slackTest=`cat flyway_output.txt | sed "s/\"//g" | sed "s/\'//g" | awk '/Database:/ {p=1} p;'`
    if [ -n "$SLACK_ERROR" ];then
        json="{\"text\": \"$SLACK_ERROR\n<$PIPELINE_RUN_URL| See the Pipeline logs> | Trigger by $TRIGGERED_BY \"}"
    elif [ -n "$slackTest" ]
    then
        json='{"text": ":successful: Flyway Migration Job ran Successfully\n'$slackTest'\n<'$PIPELINE_RUN_URL'| See the Pipeline logs> | Trigger by '$TRIGGERED_BY'"}'
    else
        echo "\$slackTest is empty"
        json="{\"text\": \"No Flyway Migration needed\n<$PIPELINE_RUN_URL| See the Pipeline logs> | Trigger by $TRIGGERED_BY \"}"
    fi
    # Sending Slack Alert
    curl -s -d "payload=$json" $SLACK_URL
}