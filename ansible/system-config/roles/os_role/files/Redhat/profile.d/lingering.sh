if (( ${EUID} >= 1000 )) ; then
  export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi
