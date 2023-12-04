SHELL := bash
cluster-name=fdo-test

default: create update-discovery serviceinfo show-iso-url

create:
	aicli create cluster --paramfile cluster.yaml $(cluster-name)
	aicli download discovery-ignition $(cluster-name)
	./extract-secrets.sh discovery.ign.$(cluster-name)

update-discovery:
	#cat discovery-update.json | jq --rawfile unit fdo-client-linuxapp.service --arg selinux "$(shell base64 fdo2assisted.te -w0)" '.systemd.units[1].contents=$$unit | .storage.files[0].contents.source="data:text/plain;base64," + $$selinux' > .ignition.json
	aicli update infraenv $(cluster-name) --paramfile discovery-update.yaml

serviceinfo:
	echo "---" > .serviceinfo
	echo "service_info:" >> .serviceinfo
	echo "  commands:" >> .serviceinfo
	echo "    - command: "$(shell head -n 2 .secrets | tail -n 1 | awk '{print $$1}') >> .serviceinfo
	echo "      args:" >> .serviceinfo
	echo "        - "$(shell head -n 2 .secrets | tail -n 1 | awk '{print $$2}') >> .serviceinfo
	echo "      return_stdout: true" >> .serviceinfo
	echo "      return_stderr: true" >> .serviceinfo
	echo "    - command: /bin/bash" >> .serviceinfo
	echo "      args:" >> .serviceinfo
	echo "        - -c" >> .serviceinfo
	echo "        - \"$(shell tail -n 2 .secrets | head -n 1)\"" >> .serviceinfo
	echo "      return_stdout: true" >> .serviceinfo
	echo "      return_stderr: true" >> .serviceinfo
	echo "    - command: /bin/bash" >> .serviceinfo
	echo "      args:" >> .serviceinfo
	echo "        - -c" >> .serviceinfo
	echo "        - \"$(shell tail -n 1 .secrets)\"" >> .serviceinfo
	echo "      return_stdout: true" >> .serviceinfo
	echo "      return_stderr: true" >> .serviceinfo
	cat .serviceinfo && echo

download-iso:
	aicli download iso $(cluster-name)

show-iso-url:
	aicli info iso $(cluster-name)

clean:
	aicli delete infraenv fdo-test -y
	aicli delete cluster fdo-test -y
	rm -f .secrets discovery.ign.$(cluster-name) .serviceinfo

deps:
	sudo dnf install -y jq python3-pip
	sudo python3 -m pip install aicli
