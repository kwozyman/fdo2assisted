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
