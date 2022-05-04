checkRootUser() {

USER_ID=$(id -u)

if [ "$USER_ID" -ne 0 ]; then
  echo You are suppose to be running as suddo or root user
else
  echo It is ok!
  fi
}

