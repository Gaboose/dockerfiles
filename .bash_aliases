alias dockerX11run='docker run -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -e DISPLAY=:0 -e LIBGL_ALWAYS_INDIRECT=1'

# Concatenates dockerfiles removing the FROM instruction from all but the first one
dockcat() {
  cat $1
  [ $1 = $(echo $* | cut -f1 -d' ') ] || 1='--' #zsh compatibility

  #command "sed -e '$a\'" is like "cat" except it ensures there's a newline at the end of every file
  #command $(echo $* | cut -f2- -d' ') gives all but the first argument

  [ $# -ge 2 ] && sed -e '$a\' $(echo $* | cut -f2- -d' ') | grep -v ^FROM
}

# Will remove all docker containers except the ones given as arguments
docker-clean () {
  _prefix-args() {
    sed -e 's/ / -e /g' | sed -e 's/^/-e /'
  }

  [ $# = 0 ] && local FILTER="cat" || local FILTER="grep $(echo $* | _prefix-args) -v"
  docker rm $(docker ps -a -q | $FILTER)

  unset -f _prefix-args
}
