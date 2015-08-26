## 0.2.0 (July 28, 2015)

FEATURES:

  * Add cAdvisor for monitoring containers [#354](https://github.com/Capgemini/Apollo/pull/354)
  * Add Cassandra as a Mesos framework [#396](https://github.com/Capgemini/Apollo/pull/396)
  * Add Chronos as a Mesos framework [#407](https://github.com/Capgemini/Apollo/pull/407)

IMPROVEMENTS:

  * Multi-AZ support for High Availabilty on aws [#385](https://github.com/Capgemini/Apollo/pull/385)
  * Apollo ami available across all aws regions [#427](https://github.com/Capgemini/Apollo/pull/427)
  * Add plugin system for hooking customizations on top of Apollo [#357](https://github.com/Capgemini/Apollo/pull/357)
  * Add DCOS-CLI support for installing frameworks [#396](https://github.com/Capgemini/Apollo/pull/396)
  * Add hvm virtualisation type support for aws [#427](https://github.com/Capgemini/Apollo/pull/427)
  * Support for single machine Vagranfile [#369](https://github.com/Capgemini/Apollo/pull/369)


## 0.1.4 (June 30, 2015)

FEATURES:

  * Add Dockerbench role [GH-334]

IMPROVEMENTS:

  * Add serverspecs for marathon deployment [GH-344]

BUG FIXES:

  * Fix weave network instability [GH-342]
  * Fix issues around bash / sh inconsistencies in Ubuntu [GH-350]

## 0.1.3 (June 24, 2015)

FEATURES:

  * Add dynamic terraform inventory based on state
  * Add a nodeJS example [GH-306]
  * Add a spring boot example [GH-294]
  * Add support for Google compute engine [GH-287]
  * Move marathon to a Docker container

IMPROVEMENTS:

  * Upgrade docker, weave, marathon [GH-323]
  * Set marathon artifact store dir [GH-314]
  * Use aufs for Docker [GH-319]
  * Add bash test for get_apollo_variables [GH-313]
  * Refactor bash functions [GH-290]

BUG FIXES:

  * Fix awk error in get_apollo_variables [GH-311]
  * Ensure we use common instance_type instead of _size across the board  [GH-303]
  * Set ssh port dynamically [GH-304]

## 0.1.2 (June 12, 2015)

FEATURES:

  * Add support for weave scope [GH-229]
  * Add proxy support for Vagrant [GH-283]
  * Add example deploying Drupal/mysql on marathon [GH-139]
  * Add AWS public terraform plan [GH-198]
  * Add auto-deploy from wercker [GH-230]

IMPROVEMENTS:

  * Add spec tests around weavescope [GH-298]
  * Add wercker deploy to AWS public cloud [GH-300]
  * Allow ansible provisioning to run in parallel in Vagrant [GH-279]
  * Use vagrant-hostmanager instead of vagrant-hosts [GH-264]
  * Wait for SSH to be available before provisioning [GH-260]

BUG FIXES:

  * Fix health check issues on amazon ELB [GH-281]
  * Fix dependencies being run over and over in provisioning [GH-284]
  * Fix problems with consul retry-join [GH-280]
  * Fix marathon wait for listen [GH-271]
  * Fix issue with mesos redirect to leader [GH-253]

## 0.1.1 (May 18, 2015)

FEATURES:

  * Add vmware builder for vagrant [GH-173]
  * Add serverspec test harness [GH-169]
  * Add the ability for dynamic environment variables for Terraform [GH-158]

IMPROVEMENTS:

  * Add weave spec tests [GH-180]
  * Add ansible performance improvements on provison [GH-206]
  * Deploy docker/weave/registrator everywhere [GH-186]
  * Add spec tests for registrator [GH-196]
  * Add spec tests for docker [GH-193]
  * Add spec tests for mesos [GH-194, GH-182]
  * Add spec tests for zookeeper [GH-192]
  * Add packer docs [GH-163]
  * Add syntax checking for ansible [GH-157]
  * provider/digitalocean: Move DO dynamic inventory to API v2 [GH-103]
  * Allow override of mesos task port range [GH-133]

BUG FIXES:

  * only start slave mesos when: mesos_install_mode == slave [GH-187]
  * Packer box versioning [GH-162]
  * Fix shell warnings on destroy [GH-166]

## 0.1.0 (May 5, 2015)

  * Initial release
