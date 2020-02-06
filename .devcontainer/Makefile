this_container=$(shell docker ps --filter "name=${CONTAINERNAME}" -aq)
devcontainers=$(shell docker ps --filter "name=devcontainer" -aq | grep -v ${this_container})

buildbase:
	docker build -f /workspace/.devcontainer/Dockerfile-base --rm --no-cache -t centos7-sshd .
deploy:
	ansible-playbook /workspace/deploy/deploy_citus_server.yml -i /workspace/deploy/vagrant_hosts \
	--ask-pass --user=super --ask-sudo-pass

container:
	@echo ${this_container}
rebuild:
	docker rm -f $(devcontainers) $(this_container)
removeall:
	docker rm -f $(devcontainers)