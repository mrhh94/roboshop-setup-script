checkRootUser() {

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[35mYou are suppose to be running as suddo or root user\e[0m"
  exit 1
else
  echo It is ok!
  fi
}

