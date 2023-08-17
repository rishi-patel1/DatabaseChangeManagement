echo "Hello World"
ibm_cloud_login() {
              echo "INFO : Login to IBM Cloud account ... "
              ibmcloud config --check-version false
              ibm_cloud_login_retry(){
                  if [[ $WNR_DEBUG_FLAG -eq 1 ]]; then ibmcloud login -a $IBM_APIKEY -r $REGION --apikey $API_KEY; login_status=$?; else ibmcloud login -q -a $IBM_APIKEY -r $REGION --apikey $API_KEY > /artifacts/tmp.txt; login_status=$?; fi
              }
              for login_retry in {1..3}; do
                  echo "INFO : trying to line $login_retry times in ibm account..."; ibm_cloud_login_retry
                  if [[ $login_status -ne 0 ]]; then cat /artifacts/tmp.txt; echo "ERROR : Not able to login into cluster ! "; rm -rf /artifacts/tmp.txt; if [[ $login_retry -eq 3 ]]; then exit 1; else echo "--------------------------------------"; fi; else rm -rf /artifacts/tmp.txt; break; fi
              done
              ibmcloud ks cluster config -c $CLUSTER_NAME > /artifacts/config_tmp.txt; rm -rf /artifacts/config_tmp.txt
          }