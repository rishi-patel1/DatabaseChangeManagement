source ./Functions.sh
echo "-----------------------------------------------------------------------------"
    # Checking its trigger by timer, scm or manual, w.r.t inventory decide to use
    if [[ "$TRIGGER_TYPE" == "generic" ]]; then
        echo "INFO : This is Trigger by generic SCM (github/gitlab webhook) ..."; TRIGGERED_BY="Generic"
        echo "INFO : TRIGGER_TYPE=$TRIGGER_TYPE and PIPELINE_RUN_URL=$PIPELINE_RUN_URL and TRIGGERED_BY=$TRIGGERED_BY"
    elif [[ "$TRIGGER_TYPE" == "timer" ]]; then
        echo "INFO :: This is Trigger by timer ..."; TRIGGERED_BY="Timer"
        echo "INFO :: TRIGGER_TYPE=$TRIGGER_TYPE and PIPELINE_RUN_URL= $PIPELINE_RUN_URL and TRIGGERED_BY= $TRIGGERED_BY"
    else
        TRIGGERED_BY=$(echo $TRIGGERED_BY | tr "[:upper:]" "[:lower:]")
        echo "INFO : TRIGGER_TYPE=$TRIGGER_TYPE and TRIGGERED_BY=$TRIGGERED_BY"
    fi
echo "-----------------------------------------------------------------------------"
ibm_cloud_login

cd ../../pg-flyway-db-migration
# FOR LOCAL TEST UNCOMMENT THIS LINE AND COMMENT ABOVE LINE
# cd pg-flyway-db-migration
echo INFO: inside flyway folder;
isFlywayJobPresent=$(kubectl get pods | grep flyway)
if [[ -z $isFlywayJobPresent ]];then
    echo job not present
else
    kubectl delete -f pg-flyway-job.yaml; 
fi       
kubectl apply -f pg-flyway-job.yaml;
get_job_status
kubectl logs `kubectl get pods | grep '\bflyway\b' |  awk '{print $1}'` > flyway_output.txt
send_slack_alert

