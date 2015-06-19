
apollo_down() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    terraform destroy -var "azure_settings_file=${TF_VAR_azure_settings_file}" \
      -var "region=${TF_VAR_region}"
  popd
}
