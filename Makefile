SHELL := bash
cluster-name=fdo-test

default: create

create:
	aicli create cluster --paramfile cluster.yaml $(cluster-name)
	aicli download discovery-ignition $(cluster-name)
	./extract-secrets.sh discovery.ign.$(cluster-name)
	aicli update infraenv $(cluster-name) --paramfile discovery-update.yaml

download-iso:
	aicli download iso $(cluster-name)

show-iso-url:
	aicli info iso $(cluster-name)

clean:
	aicli delete infraenv fdo-test -y
	aicli delete cluster fdo-test -y
	rm -f .secrets discovery.ign.$(cluster-name)
