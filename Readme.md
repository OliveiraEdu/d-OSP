# Open Science Platform

## Introduction

This artifact demonstrates the creation and management of user accounts, project accounts, and linked accounts using IPFS and Iroha.


This is the repository for the project Open Science, on its final form the project will deliver a sample DApp based on:

- Hyperledger Iroha 1
- Hyperledger Burrow
- Smart contracts
- IPFS

---

## Components

### Iroha 1 Python SDK

This notebook uses [Iroha 1 Python Library ](https://pypi.org/project/iroha/)


### Smart Contracts

The integration of smart contracts into Iroha 1 is executed by Hyperledger Burrow. For additional information refer to [Iroha Smart Contracts Integration](https://iroha.readthedocs.io/en/develop/integrations/burrow.html?highlight=contract). Use this docker image `hyperledger/iroha-burrow:pr-3960`, see below.


### IPFS

This project uses [Python IPFS HTTP Client](https://github.com/ipfs-shipyard/py-ipfs-http-client)


---
## Requirements

Docker images:

- new_jupyter_lab (see `docker/Dockerfile`)

- [Iroha 1](https://iroha.readthedocs.io/en/develop/overview.html)

- [IPFS Kubo](https://blog.ipfs.tech/1-run-ipfs-on-docker/) 

* All containers must be attached to the iroha network.

* Clone the Iroha 1 repo:

```bash
git clone https://github.com/iroha
```


* Create local directories at your docker host:

```bash
mkdir ipfs_repo ipfs_repo/staging ipfs_repo/data
```

  
## Setup


2.1 - Jupyter Notebooks

```bash
docker run -it -p 10.0.0.100:10000:8888 --network=iroha-network new_jupyter_lab
```

2.2 IPFS Node

```bash
docker run -d --name ipfs_node -v ~/ipfs_repo/staging:/export -v ~/ipfs_repo/data:/data/ipfs -p 4001:4001 -p 8080:8080 -p 5001:5001 --network iroha-network ipfs/go-ipfs:v0.4.23
```

2.3 Iroha Network

```bash
docker run --name iroha -d -p 50051:50051 -p 7001:7001 -v $(pwd)/iroha/example:/opt/iroha_data -v blockstore:/tmp/block_store --network=iroha-network --restart always -e KEY='node0' hyperledger/iroha-burrow:pr-3960
```

2.4 - IP Address and related connections parameters

For iroha and IPFS, check and edit `config.json` according to the networking settings for your environment.


----

## Test the Platform

|Step|Description|Outcome|
|---|-----------|----|
|1|[User Account Creation](http://s:10000/lab/tree/1%20-%20Artifact%20-%20User%20Account%20Creation.ipynb)| Creates an user account|
|2|[Project Account Creation](http://s:10000/lab/tree/2%20-%20Artifact%20-%20Project%20Account%20Creation.ipynb)| Creates a project account|
|3|[Cross Linking User and Project accounts](http://s:10000/lab/tree/3%20-%20Artifact%20-%20Project%20%20Cross%20Link%20Account%20and%20Project%20Account.ipynb)| Sets a bi-directional link between an user account and a project account|
|4|[Querying linked accounts](http://s:10000/lab/tree/Artifact%20-%20Querying%20Linked%20Account%20and%20Project%20accounts.ipynb)| Querying Linked Account and Project accounts|

### Summary

This artifact demonstrates the creation and management of user accounts, project accounts, and linked accounts using IPFS and Iroha. The sequence diagram shows the steps involved in creating and linking these accounts.

[1]: http://s:10000/lab/tree/1%20-%20Artifact%20-%20User%20Account%20Creation.ipynb
[2]: http://s:10000/lab/tree/2%20-%20Artifact%20-%20Project%20Account%20Creation.ipynb
[3]: http://s:10000/lab/tree/3%20-%20Artifact%20-%20Project%20%20Cross%20Link%20Account%20and%20Project%20Account.ipynb

---
## Caveats and Workarounds

### Genesis Block

The default Genesis block for Iroha 1 docker image `admin@test` does not have the proper permission to creat smart contracts, therefore it is necessary to add the permission for the `admin@test` account editing the `genesis.block`file as instructed below.


#### How to run a specific genesis-block, to add/change permissions

- The genesis block file is read from the local iroha/example/genesis_block file. 

- This is the modified block, with the admin role permission set root.

- After that you only need to execute docker run with the proper parameters of the iroha container.

```genesis_block
                       {
                          "createRole":{
                             "roleName":"admin",
                             "permissions":[
                                "root"                             
                             ]
                          }
                       },

```

---


## Future Improvements

### New features

- Improve function `upload_file_to_ipfs` to get the original file name and store it on `file_n_metadata` JSON automatically - Done

### Monitoring

Use Prometheus for monitoring basic metrics.

### Document functions and generate documentation

- Check functions and maybe breakdown them further for [better maintainability](https://www.linkedin.com/posts/khuyen-tran-1401_productionreadydatascience-datascience-cleancode-activity-7236085519871307776-WLDK/?utm_source=share&utm_medium=member_android)

- Use a standard Jupyter Notebook docker image from [Jupyter Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)

### Smart Contracts

- Publish smart contracts in IPFS