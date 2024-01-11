FDO + Assisted Installer
===

This is an integration example between FDO and Assisted Installer. Agent based installation will not start unless FDO device credentials are validated against an onboarding server.

tl;dr
---

```
$ git clone https://github.com/kwozyman/fdo2assisted.git
$ make create
$ make update-discovery
$ curl -L $(make show-iso-url | tail -n1) -o fdo-sno.iso
$ make serviceinfo
## onboard the target host to FDO
## add the generated serviceinfo configuration to the onboarding server
## boot fdo-sno.iso on your host
```

Workflow
---

1. `make create`:
    * this will create an assisted installer cluster using `aicli` and the cluster definition from `cluster.yaml`
    * the script will also download the live discovery iso ignition file and extract the secrets into the local file `.secrets`

2. `make update-discovery`:
    * remove `agent.service` systemd unit from discovery iso
    * add `fdo2assisted.te` SELinux type enforcement file
    * add `fdo-client-linuxapp.service` systemd unit -- this unit will mount local boot partition and copy `device-credentials` file to the live `/etc`, apply SELinux rules and then download and run `fdo-client-linuxapp`

3. `curl -L $(make show-iso-url | tail -n1) -o fdo-sno.iso`:
    * download the generated discovery iso

4. `make serviceinfo`
    * this will print to stdout a generated FDO serviceinfo configuration containing the secrets (extracted in the first step)
    * the configuration needs to be copied over to the FDO configuration

5. After the succesful FDO onboarding, serviceinfo will simply start the Assisted Installer agent and the installation proceeds normally
