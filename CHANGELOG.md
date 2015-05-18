# Change Log

## [Unreleased](https://github.com/capgemini/Apollo/tree/HEAD)

[Full Changelog](https://github.com/capgemini/Apollo/compare/0.1...HEAD)

**Implemented enhancements:**

- Tag all tasks in ansible roles [\#175](https://github.com/Capgemini/Apollo/issues/175)

- Bootstrap script to rerun ansible playbooks only [\#174](https://github.com/Capgemini/Apollo/issues/174)

- Change terraform environment variables to use TF\_VAR... rather than pass -var on the command line [\#141](https://github.com/Capgemini/Apollo/issues/141)

- Create Atlas artifacts for Digitalocean / Google compute engine [\#121](https://github.com/Capgemini/Apollo/issues/121)

- Combine packer JSON files [\#116](https://github.com/Capgemini/Apollo/issues/116)

- Move digitalocean dynamic inventory to use API version 2 [\#103](https://github.com/Capgemini/Apollo/issues/103)

- Move serverspec testing to be via ansible [\#101](https://github.com/Capgemini/Apollo/issues/101)

**Fixed bugs:**

- Slave machine not coming up correctly sometimes in the vagrant machine [\#172](https://github.com/Capgemini/Apollo/issues/172)

- Occassionally mesos isnt able to send registration acknowledgement to marathon [\#167](https://github.com/Capgemini/Apollo/issues/167)

- Transient AWS build failures [\#85](https://github.com/Capgemini/Apollo/issues/85)

**Closed issues:**

- Support vmware-iso for packer vagrant box [\#161](https://github.com/Capgemini/Apollo/issues/161)

- Not really best practice to write ssh key to bastion/nat instance [\#144](https://github.com/Capgemini/Apollo/issues/144)

- Allow override of mesos task port range [\#133](https://github.com/Capgemini/Apollo/issues/133)

**Merged pull requests:**

- Make version an ENV var so we dont accidentally push over existing ve… [\#207](https://github.com/Capgemini/Apollo/pull/207) ([tayzlor](https://github.com/tayzlor))

- pipelining=True timeout = 15 ins ansible.cfg for performance improvement. [\#206](https://github.com/Capgemini/Apollo/pull/206) ([enxebre](https://github.com/enxebre))

- Add docs around looking up DO images manually [\#204](https://github.com/Capgemini/Apollo/pull/204) ([tayzlor](https://github.com/tayzlor))

- Capture only first row of terraform --version output [\#203](https://github.com/Capgemini/Apollo/pull/203) ([enxebre](https://github.com/enxebre))

- Add note in vagrant docs about sudo [\#202](https://github.com/Capgemini/Apollo/pull/202) ([wallies](https://github.com/wallies))

- Exporing TF vars in script by default. [\#201](https://github.com/Capgemini/Apollo/pull/201) ([enxebre](https://github.com/enxebre))

- Update digitalocean.md [\#199](https://github.com/Capgemini/Apollo/pull/199) ([haf](https://github.com/haf))

- Add spec for registrator [\#196](https://github.com/Capgemini/Apollo/pull/196) ([tayzlor](https://github.com/tayzlor))

- add mesos client tests \#182 [\#194](https://github.com/Capgemini/Apollo/pull/194) ([asnaedae](https://github.com/asnaedae))

- Docker spec tests [\#193](https://github.com/Capgemini/Apollo/pull/193) ([tayzlor](https://github.com/tayzlor))

- \#181 - zookeeper spec tests [\#192](https://github.com/Capgemini/Apollo/pull/192) ([tayzlor](https://github.com/tayzlor))

- Fix the fact mesos spec tests were showing 1 as the quorum count instead of 2 [\#191](https://github.com/Capgemini/Apollo/pull/191) ([tayzlor](https://github.com/tayzlor))

- increase quality of mesos master tests for issue \#182 [\#189](https://github.com/Capgemini/Apollo/pull/189) ([asnaedae](https://github.com/asnaedae))

- only start slave mesos   when: mesos\_install\_mode == slave [\#187](https://github.com/Capgemini/Apollo/pull/187) ([enxebre](https://github.com/enxebre))

- Deploy docker/weave/registrator to all hosts [\#186](https://github.com/Capgemini/Apollo/pull/186) ([tayzlor](https://github.com/tayzlor))

- Rename packer / artifacts to just apollo, rather than apollo-mesos [\#185](https://github.com/Capgemini/Apollo/pull/185) ([tayzlor](https://github.com/tayzlor))

- Fix \#175 - add tags for roles, and some slight refactoring / style fixes [\#184](https://github.com/Capgemini/Apollo/pull/184) ([tayzlor](https://github.com/tayzlor))

- \#161 add builder for vmware images [\#173](https://github.com/Capgemini/Apollo/pull/173) ([asnaedae](https://github.com/asnaedae))

- Initial commit of serverspec test harness [\#169](https://github.com/Capgemini/Apollo/pull/169) ([tayzlor](https://github.com/tayzlor))

- artifact name [\#168](https://github.com/Capgemini/Apollo/pull/168) ([enxebre](https://github.com/enxebre))

- Fix shell warning on destroy [\#166](https://github.com/Capgemini/Apollo/pull/166) ([tayzlor](https://github.com/tayzlor))

- Fix aws docs [\#165](https://github.com/Capgemini/Apollo/pull/165) ([wallies](https://github.com/wallies))

- revert artifact names to be under capgemini namespace [\#164](https://github.com/Capgemini/Apollo/pull/164) ([tayzlor](https://github.com/tayzlor))

- Fix \#159 - Packer box versioning [\#162](https://github.com/Capgemini/Apollo/pull/162) ([tayzlor](https://github.com/tayzlor))

- 152 dynamic vars [\#158](https://github.com/Capgemini/Apollo/pull/158) ([enxebre](https://github.com/enxebre))

- Add syntax checking for ansible-playbook to wercker [\#157](https://github.com/Capgemini/Apollo/pull/157) ([tayzlor](https://github.com/tayzlor))

- Addresses \#103 Digitalocean v2 api [\#156](https://github.com/Capgemini/Apollo/pull/156) ([tayzlor](https://github.com/tayzlor))

- \[roles/mesos\] parameterize slave work\_dir [\#151](https://github.com/Capgemini/Apollo/pull/151) ([pmbauer](https://github.com/pmbauer))

- \[terraform/aws\] nat uses atalas artifact for ami [\#150](https://github.com/Capgemini/Apollo/pull/150) ([pmbauer](https://github.com/pmbauer))

- Digitalocean atlas version [\#149](https://github.com/Capgemini/Apollo/pull/149) ([tayzlor](https://github.com/tayzlor))

- Update docs to reference just using pip install -r to ease the setup [\#147](https://github.com/Capgemini/Apollo/pull/147) ([tayzlor](https://github.com/tayzlor))

- Change CI tests to do ansible-lint / packer-validate [\#146](https://github.com/Capgemini/Apollo/pull/146) ([tayzlor](https://github.com/tayzlor))

- Fix \#144 dont provision SSH key to the bastion host as we dont need it [\#145](https://github.com/Capgemini/Apollo/pull/145) ([tayzlor](https://github.com/tayzlor))

- Allow override of docker options for weave [\#143](https://github.com/Capgemini/Apollo/pull/143) ([tayzlor](https://github.com/tayzlor))

- cleanup of markdown for the digitalocean instructions [\#142](https://github.com/Capgemini/Apollo/pull/142) ([asnaedae](https://github.com/asnaedae))

- Add a Gitter chat badge to README.md [\#137](https://github.com/Capgemini/Apollo/pull/137) ([gitter-badger](https://github.com/gitter-badger))

- Fix some inconsistencies / bugs with registrator / docker /consul [\#136](https://github.com/Capgemini/Apollo/pull/136) ([tayzlor](https://github.com/tayzlor))

- centos box [\#43](https://github.com/Capgemini/Apollo/pull/43) ([wallies](https://github.com/wallies))

## [0.1](https://github.com/capgemini/Apollo/tree/0.1) (2015-05-05)

**Implemented enhancements:**

- Add consul service definition for zookeeper [\#91](https://github.com/Capgemini/Apollo/issues/91)

- Add consul service definition for marathon [\#90](https://github.com/Capgemini/Apollo/issues/90)

- Add consul service definitions for mesos master service [\#89](https://github.com/Capgemini/Apollo/issues/89)

- Create a terraform plan for Digitalocean [\#15](https://github.com/Capgemini/Apollo/issues/15)

- Create a docker compose.yml to allow us to test the stack [\#14](https://github.com/Capgemini/Apollo/issues/14)

- Create a packer template for GCE  [\#13](https://github.com/Capgemini/Apollo/issues/13)

- Create a packer template for digitalocean [\#12](https://github.com/Capgemini/Apollo/issues/12)

- Configure consul via terraform on master/slaves [\#8](https://github.com/Capgemini/Apollo/issues/8)

- Install and configure dnsmasq  [\#3](https://github.com/Capgemini/Apollo/issues/3)

- Set the mesos cluster name to the AWS/DO region we are in [\#81](https://github.com/Capgemini/Apollo/issues/81)

- Provision registrator docker container via terraform and link it into the Consul backend [\#77](https://github.com/Capgemini/Apollo/issues/77)

- Create a single script for bootstrapping AWS [\#50](https://github.com/Capgemini/Apollo/issues/50)

- Create serverspec tests that test the end state of configuration after applied through terraform [\#49](https://github.com/Capgemini/Apollo/issues/49)

**Fixed bugs:**

- wercker not catching correct exit code on test failures [\#40](https://github.com/Capgemini/Apollo/issues/40)

- Consul Web UI unavailable through VPN [\#27](https://github.com/Capgemini/Apollo/issues/27)

- Dependency ordering issue with mesos master / slave nodes [\#21](https://github.com/Capgemini/Apollo/issues/21)

- Consul service not working correctly in AWS VPC [\#119](https://github.com/Capgemini/Apollo/issues/119)

- Weave launch command needs to be aware of other machines in the cluster when launching [\#98](https://github.com/Capgemini/Apollo/issues/98)

- Internal links and redirects for mesos not redirecting properly [\#61](https://github.com/Capgemini/Apollo/issues/61)

- Lock package versions in packer install.sh scripts [\#46](https://github.com/Capgemini/Apollo/issues/46)

- Terraform apply fails first time, applies correctly on 2nd run [\#24](https://github.com/Capgemini/Apollo/issues/24)

- Cannot access the internet from the private VPC [\#18](https://github.com/Capgemini/Apollo/issues/18)

**Closed issues:**

- provisioner error when spinning up vagrant based instances [\#125](https://github.com/Capgemini/Apollo/issues/125)

- Move to ansible for provisioning from terraform [\#57](https://github.com/Capgemini/Apollo/issues/57)

- Set collaborators up on quay.io for use as a private docker registry [\#53](https://github.com/Capgemini/Apollo/issues/53)

- Provision docker registrator so containers spinning up in the cluster publish their information to consul [\#52](https://github.com/Capgemini/Apollo/issues/52)

- Create a readme doc on how to setup VPN access for yourself through the nat sever [\#11](https://github.com/Capgemini/Apollo/issues/11)

- Tidy up README.md [\#9](https://github.com/Capgemini/Apollo/issues/9)

- Fix routing to amazon private\_dns instances via the VPN [\#5](https://github.com/Capgemini/Apollo/issues/5)

- Add a license file to the repository [\#74](https://github.com/Capgemini/Apollo/issues/74)

- Push packer box to vagrant cloud for vagrant based setup [\#72](https://github.com/Capgemini/Apollo/issues/72)

- Set the consul datacenter config option by AWS zone we are in  [\#62](https://github.com/Capgemini/Apollo/issues/62)

- Fix any issues against terraform 0.4.0 [\#59](https://github.com/Capgemini/Apollo/issues/59)

- Update dnsmasq spec test to test the config file provisioned [\#39](https://github.com/Capgemini/Apollo/issues/39)

- Upgrade to mesos 0.22 [\#35](https://github.com/Capgemini/Apollo/issues/35)

- Create a vagrant based setup [\#32](https://github.com/Capgemini/Apollo/issues/32)

- Create a packer image for the front-end load balancer to services in the cluster [\#7](https://github.com/Capgemini/Apollo/issues/7)

- Configure weave through terraform on the mesos masters/slaves [\#6](https://github.com/Capgemini/Apollo/issues/6)

**Merged pull requests:**

- doc fix [\#132](https://github.com/Capgemini/Apollo/pull/132) ([enxebre](https://github.com/enxebre))

- default variable fix and docs improvement [\#131](https://github.com/Capgemini/Apollo/pull/131) ([enxebre](https://github.com/enxebre))

- Add docs for atlas, add push config for do/googlecompute, refactor names... [\#128](https://github.com/Capgemini/Apollo/pull/128) ([tayzlor](https://github.com/tayzlor))

- PR issue \#125 failure provision on vagrant [\#127](https://github.com/Capgemini/Apollo/pull/127) ([asnaedae](https://github.com/asnaedae))

- \#47 - add docs for dnsmasq, networking, dns [\#126](https://github.com/Capgemini/Apollo/pull/126) ([tayzlor](https://github.com/tayzlor))

- Fix errors in apollo launch for host keys and docker-py version [\#124](https://github.com/Capgemini/Apollo/pull/124) ([wallies](https://github.com/wallies))

- 13 gce packer [\#114](https://github.com/Capgemini/Apollo/pull/114) ([enxebre](https://github.com/enxebre))

- Moving haproxy to a container [\#112](https://github.com/Capgemini/Apollo/pull/112) ([tayzlor](https://github.com/tayzlor))

- add --local-encoding to work around bintray/wget issue with charset conversion [\#111](https://github.com/Capgemini/Apollo/pull/111) ([asnaedae](https://github.com/asnaedae))

- \#47 Add docs for docker/packer/terraform [\#106](https://github.com/Capgemini/Apollo/pull/106) ([tayzlor](https://github.com/tayzlor))

- Registrator [\#104](https://github.com/Capgemini/Apollo/pull/104) ([enxebre](https://github.com/enxebre))

- 93 digital ocean [\#102](https://github.com/Capgemini/Apollo/pull/102) ([enxebre](https://github.com/enxebre))

- Fix \#83 change references from capgemini \> apollo and move AWS provisioning to ansible [\#100](https://github.com/Capgemini/Apollo/pull/100) ([tayzlor](https://github.com/tayzlor))

- Allow consul domain override [\#99](https://github.com/Capgemini/Apollo/pull/99) ([tayzlor](https://github.com/tayzlor))

- Fixes \#61 - marathon hostname link was not resolving correctly from the ... [\#97](https://github.com/Capgemini/Apollo/pull/97) ([tayzlor](https://github.com/tayzlor))

- Add use case examples to main README [\#96](https://github.com/Capgemini/Apollo/pull/96) ([tayzlor](https://github.com/tayzlor))

- 15 terraform digitalocean [\#88](https://github.com/Capgemini/Apollo/pull/88) ([tayzlor](https://github.com/tayzlor))

- Fix \#80 - add getting started guide for vagrant [\#87](https://github.com/Capgemini/Apollo/pull/87) ([tayzlor](https://github.com/tayzlor))

- Fixes \#39 - add spec test for dnsmasq file provisioned [\#86](https://github.com/Capgemini/Apollo/pull/86) ([tayzlor](https://github.com/tayzlor))

- 47 component docs [\#82](https://github.com/Capgemini/Apollo/pull/82) ([tayzlor](https://github.com/tayzlor))

- 50 aws bootstrap script [\#79](https://github.com/Capgemini/Apollo/pull/79) ([tayzlor](https://github.com/tayzlor))

- Fixes \#74 - add a license file to the repo [\#78](https://github.com/Capgemini/Apollo/pull/78) ([tayzlor](https://github.com/tayzlor))

- Fix artifact naming for 0.22, add 5min timeout on wercker builds [\#76](https://github.com/Capgemini/Apollo/pull/76) ([tayzlor](https://github.com/tayzlor))

- fix \#10 - add roadmap [\#75](https://github.com/Capgemini/Apollo/pull/75) ([tayzlor](https://github.com/tayzlor))

- Fix \#32 Vagrant setup [\#73](https://github.com/Capgemini/Apollo/pull/73) ([tayzlor](https://github.com/tayzlor))

- serverspecs over terraform apply [\#69](https://github.com/Capgemini/Apollo/pull/69) ([enxebre](https://github.com/enxebre))

- locking mesos version [\#64](https://github.com/Capgemini/Apollo/pull/64) ([enxebre](https://github.com/enxebre))

- consul dynamic dc and dynamic ami experiment [\#63](https://github.com/Capgemini/Apollo/pull/63) ([enxebre](https://github.com/enxebre))

- Make bash exit on errors and use stricter checks [\#45](https://github.com/Capgemini/Apollo/pull/45) ([tayzlor](https://github.com/tayzlor))

- enforce stricter checking on packer build scripts [\#44](https://github.com/Capgemini/Apollo/pull/44) ([tayzlor](https://github.com/tayzlor))

- Wercker builds [\#37](https://github.com/Capgemini/Apollo/pull/37) ([tayzlor](https://github.com/tayzlor))

- \#12 - Add a packer template for DO [\#33](https://github.com/Capgemini/Apollo/pull/33) ([tayzlor](https://github.com/tayzlor))

- Readme fixes [\#31](https://github.com/Capgemini/Apollo/pull/31) ([tayzlor](https://github.com/tayzlor))

- Fixes \#27 - Consul WEB UI unavailable [\#28](https://github.com/Capgemini/Apollo/pull/28) ([tayzlor](https://github.com/tayzlor))

- Fixes \#11 - Add docs for VPN setup [\#26](https://github.com/Capgemini/Apollo/pull/26) ([tayzlor](https://github.com/tayzlor))

- Fixes \#3 - install and setup dnsmasq on masters/slaves [\#23](https://github.com/Capgemini/Apollo/pull/23) ([tayzlor](https://github.com/tayzlor))

- Provision all masters before slaves [\#22](https://github.com/Capgemini/Apollo/pull/22) ([tayzlor](https://github.com/tayzlor))

- Initial stab at consul integration for the cluster [\#20](https://github.com/Capgemini/Apollo/pull/20) ([tayzlor](https://github.com/tayzlor))

- Fix startup script. give nat instance elastic IP. Reset rules back to de... [\#19](https://github.com/Capgemini/Apollo/pull/19) ([tayzlor](https://github.com/tayzlor))

- Initial commit on terraform integration [\#2](https://github.com/Capgemini/Apollo/pull/2) ([tayzlor](https://github.com/tayzlor))

- Packer integration [\#1](https://github.com/Capgemini/Apollo/pull/1) ([tayzlor](https://github.com/tayzlor))

- Fix \#81 - set mesos\_cluster\_name and consul\_dc via environment variables [\#108](https://github.com/Capgemini/Apollo/pull/108) ([tayzlor](https://github.com/tayzlor))

- Fix \#98 weave launch needs to be cluster aware [\#107](https://github.com/Capgemini/Apollo/pull/107) ([tayzlor](https://github.com/tayzlor))

- \#59 - terraform 0.4.0 fixes [\#60](https://github.com/Capgemini/Apollo/pull/60) ([tayzlor](https://github.com/tayzlor))

- basic weave setup [\#41](https://github.com/Capgemini/Apollo/pull/41) ([enxebre](https://github.com/enxebre))

- packer files for load balancer [\#36](https://github.com/Capgemini/Apollo/pull/36) ([wallies](https://github.com/wallies))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*