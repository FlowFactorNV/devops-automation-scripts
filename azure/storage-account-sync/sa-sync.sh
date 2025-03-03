#!/bin/bash

###############################################################################
#           _____ _               _____          _                            #
#          |  ___| | _____      _|  ___|_ _  ___| |_ ___  _ __                #
#          | |_  | |/ _ \ \ /\ / / |_ / _` |/ __| __/ _ \| '__|               #
#          |  _| | | (_) \ V  V /|  _| (_| | (__| || (_) | |                  #
#          |_|   |_|\___/ \_/\_/ |_|  \__,_|\___|\__\___/|_|                  #
#                                                                             #
#                    https://flowfactor.be                                    #
#                                                                             #
#  Script Name  : sa-sync.sh                                                  #
#  Author       : Levente Kátai-Pál                                           #
#  Email        : sos@flowfactor.be                                     	    #
#  Description  : Synchronizes containers from a set of storage accounts to   #
#                 another set of storage accounts using the azcopy tool.      #
#  Disclaimer   : These scripts aren’t a magic solution—they’re tools to get  #
#                 you started. They worked for us at a certain time, and      #
#                 we’re sharing them so you don’t have to reinvent the wheel. #
#                 But every environment is different.                         #
#                 FlowFactor assumes no responsibility or liability for any   #
#                 errors, omissions, or unexpected chaos that might arise     #
#                 from using them. The scripts are provided as is, with no    #
#                 guarantees of completeness, accuracy, or suitability for    #
#                 your use case.                                              #
#                                                                             #
###############################################################################

set -e

help() {
  cat <<EOF
Usage: $0 [options]

Synchronizes containers from a set of storage accounts to another set of storage accounts using the azcopy tool.

Options:
  --source-subscription STRING   The name of the Azure subscription where the source storage accounts are provisioned. (required)
  --target-subscription STRING   The name of the Azure subscription where the target storage accounts are provisioned. (optional, defaults to source subscription)
  --source-sas STRING            Comma-separated list of source storage account names. (required)
  --target-sas STRING            Comma-separated list of target storage account names. (required)
  --excluded-containers STRING   Comma-separated list of containers to exclude from the sync. (optional)
  --dry-run                      Performs a dry run without actually copying any data. (optional)
  --help                         Display this help message.

Notes:
  - The script requires Azure CLI and azcopy to be installed and configured.
  - The same number of storage account names must be provided for --source-sas and --target-sas.

Author: Levente Kátai-Pál
Email: sos@flowfactor.be
EOF
}

# Arguments:
#   $1: The name of the subscription
#   $2: The name of the storage account
#   $3: The name of the container
# Outputs:
#   The Shared-Access Signature without double quotes to stdout
generate_sas() {
  local account_key
  account_key=$(az storage account keys list \
    --account-name "$2" \
    --query '[0].value' \
    --subscription "$1" \
    --output tsv
  )

  local sas
  sas=$(az storage container generate-sas \
    --account-name "$2" \
    --account-key "$account_key" \
    --expiry "$(date --date="1 days" +"%Y-%m-%dT%H:%M:%SZ")" \
    --name "$3" \
    --permissions acdlrw \
    --subscription "$1"
  )

  echo "$sas" | awk '{print substr($0, 2, length($0)-2)}'
}

info() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] INFO: $*"
}

warn() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] WARN: $*"
}

error() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] ERROR: $*" >&2
}

dry_run="false"

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --source-subscription)
      source_subscription="$2"
      shift 2
      ;;
    --target-subscription)
      target_subscription="$2"
      shift 2
      ;;
    --source-sas)
      IFS=',' read -r -a source_sas <<< "$2"
      shift 2
      ;;
    --target-sas)
      IFS=',' read -r -a target_sas <<< "$2"
      shift 2
      ;;
    --excluded-containers)
      IFS=',' read -r -a excluded_containers <<< "$2"
      shift 2
      ;;
    --dry-run)
      dry_run="true"
      shift 1
      ;;
    --help)
      help
      exit 0
      ;;
  esac
done

info "Dry run is $dry_run"

if [[ -z "$source_subscription" ]]; then
  error "--source-subscription must be provided."
  exit 1
fi

if [[ -z "$target_subscription" ]]; then
  target_subscription="$source_subscription"
fi

# shellcheck disable=SC2128
if [[ -z "$target_sas" ]]; then
  error "--target-sas must be provided."
  exit 1
fi

# shellcheck disable=SC2128
if [[ -z "$source_sas" ]]; then
  error "--source-sas must be provided."
  exit 1
fi

if [[ "${#source_sas[@]}" -ne "${#target_sas[@]}" ]]; then
  error "The same number of storage account names must be passed to --source-sas and --target-sas"
  exit 1
fi

i=0
for source_sa in "${source_sas[@]}"; do
  target_sa="${target_sas[$i]}"
  info "($source_sa) Starting container sync to $target_sa"

  containers=$(az storage container list --account-name "${source_sa}" --auth-mode login | jq '.[].name' --raw-output)
  # shellcheck disable=SC2206
  containers=($containers)

  j=1
  len="${#containers[@]}"
  for container in "${containers[@]}"; do
    if echo "${excluded_containers[@]}" | grep -q "$container"; then
      info "($source_sa $j/$len) Skipping container $container"
    else
      info "($source_sa $j/$len) Generating SAS for $source_sa/$container"
      sa_sas=$(generate_sas "$source_subscription" "$source_sa" "$container")

      info "($source_sa $j/$len) Generating SAS for $target_sa/$container"
      sa_dr_sas=$(generate_sas "$target_subscription" "$target_sa" "$container")

      info "($source_sa $j/$len) Syncing container $container"
      source_url="https://${source_sa}.blob.core.windows.net/${container}?${sa_sas}"
      target_url="https://${target_sa}.blob.core.windows.net/${container}?${sa_dr_sas}"
      azcopy sync "$source_url" "$target_url" --dry-run="$dry_run"
    fi

    j=$((j+1))
  done

  i=$((i+1))
done
