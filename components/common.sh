checkRootUser() {

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[35mYou are suppose to be running as suddo or root user\e[0m"
  exit 1
else
  echo It is ok!
  fi
}

checkStatus() {

  if [ $1 -eq 0 ]; then
  echo -e "\e[35mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  echo "\e[35mplease check the ${LOG_FILE}\e[0m"
  exit 1
fi

}

LOG_FILE=/tmp/robo.log
rm -f $LOG_FILE

ECHO(){
  echo -e "==================== $1 ====================\n" >>${LOG_FILE}
  echo "$1"
}