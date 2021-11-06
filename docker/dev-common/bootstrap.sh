source "${DEV_COMMON}/bash-infinity/lib/oo-bootstrap.sh"

export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

function render_template() {
  perl -p -e 's/%%([^%]+)%%/defined $ENV{$1} ? $ENV{$1} : $&/eg' <$1
}

function exec_dir() {
  cd $(dirname $0) && pwd
}

function require_env() {
  local name=$1

  local current=$(echo ${!name})
  if [[ -z "$current" ]]; then
    echo "Variable $name must be set"
    exit 1
  else
    echo $current
  fi
}

function Debug() {
  if [ "${BASH_DEBUG}" != "" ]; then
    >&2 echo "[D] $*"
  fi
}

function Log() {
    >&2 echo "[I] $*"
}

function writeFile() {
  local fileName=$1
  local contents=$2
  Debug "Writing file: ${fileName}"
  echo ${contents} >$fileName
}
