buildbase:
	docker build -f /workspace/.devcontainer/Dockerfile-base --rm --no-cache -t centos7-sshd .
deploy:
	ansible-playbook /workspace/deploy/deploy_citus_server.yml -i /workspace/deploy/vagrant_hosts \
	--ask-pass --user=super --ask-sudo-pass
