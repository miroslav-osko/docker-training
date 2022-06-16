# create Docker network
docker network create myteamcity-network

# install TeamCity server
docker run --name myteamcity `
    -v c:/Workspace/teamcity/data:/data/teamcity_server/datadir `
    -v c:/Workspace/teamcity/logs:/opt/teamcity/logs `
    -p 8111:8111 `
    --restart always `
	-d `
	--network myteamcity-network `
    jetbrains/teamcity-server
	
# option 1 - doesn't work well with Docker Wrapper
# docker run --name myteamcity-agent1 `
    # -e SERVER_URL=http://myteamcity:8111/ `
	# -e DOCKER_IN_DOCKER=start `
	# -u 0 `
    # -v c:/Workspace/teamcity/agent1:/data/teamcity_agent/conf `
	# -v /var/run/docker.sock:/var/run/docker.sock `
    # -v c:/Workspace/teamcity/data/work:/opt/buildagent/work `
    # -v c:/Workspace/teamcity/data/temp:/opt/buildagent/temp `
    # -v c:/Workspace/teamcity/data/tools:/opt/buildagent/tools `
    # -v c:/Workspace/teamcity/data/plugins:/opt/buildagent/plugins `
    # -v c:/Workspace/teamcity/data/system:/opt/buildagent/system `
	# --network myteamcity-network `
	# -d `
    # jetbrains/teamcity-agent
	
# option 2 - Docker host inside the container
docker run --name myteamcity-agent1 `
    -e SERVER_URL=http://myteamcity:8111/ `
	-v c:/Workspace/teamcity/agent1:/data/teamcity_agent/conf `
	-v myteamcity-agentvolume1:/var/lib/docker `
    --privileged -e DOCKER_IN_DOCKER=start `
	--network myteamcity-network `
	-d `
    jetbrains/teamcity-agent:2022.04.1-linux-sudo


# run this in the agent to install kubectl and helm
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash