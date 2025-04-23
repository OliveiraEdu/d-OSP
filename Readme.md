# d-OSP: Decentralized Open Science Platform


# 1 This Repository

This is the repository for my Master's dissertation project, it delivers a sample dApp running on Jupyter Notebooks based on:

- Hyperledger Iroha 1
- Hyperledger Burrow
- Smart contracts
- IPFS


## 1.1 Introduction

This artifact demonstrates the creation and management of user accounts, project accounts, and linked accounts using IPFS and Iroha.
d-OSP is a infrastructure that integrates blockchain, IPFS, and smart contracts to improve research reproducibility. By leveraging immutable records and decentralized storage, the platform ensures transparent and verifiable research data management. Additionally, extended services are incorporated to facilitate file indexing, metadata extraction, and search functionality. The proposed platform aligns with Open Science principles by providing verifiable and persistently traceable access to research data. 


## 1.2 Components

### 1.2.1 Iroha 1 Python SDK

This notebook uses the [Iroha 1 Python Library ](https://pypi.org/project/iroha/)


### 1.2.2 Smart Contracts

The integration of smart contracts into Iroha 1 is executed by Hyperledger Burrow. For additional information refer to [Iroha Smart Contracts Integration](https://iroha.readthedocs.io/en/develop/integrations/burrow.html?highlight=contract). Use this docker image `hyperledger/iroha-burrow:pr-3960`, see below.


### 1.2.3 IPFS

This project uses [Python IPFS HTTP Client](https://github.com/ipfs-shipyard/py-ipfs-http-client)


## 1.3 Requirements

1.3.1 A host running Docker engine.

1.3.2 Docker images:

- new_jupyter_lab (see `OpenScience/docker/Dockerfile`)

- [Iroha 1](https://iroha.readthedocs.io/en/develop/overview.html)

- [IPFS Kubo](https://blog.ipfs.tech/1-run-ipfs-on-docker/) 

* All containers must be attached to the iroha network.

---

## 2  Setup Instructions


2.1  Clone the Iroha 1 repo:

```bash

cd ~/

git clone https://github.com/iroha

cd iroha

docker network create iroha-network

docker volume create blockstore

git checkout 0d22d117863560c5330299bea592360fd8252941

```

2.2 Editing the `genesis.block` file

Genesis Block

The default Genesis block for Iroha 1 docker image `admin@test` does not have the proper permission to creat smart contracts, therefore it is necessary to add the permission for the `admin@test` account editing the `genesis.block`file as instructed below.


How to run a specific genesis-block, to add/change permissions for the admin

- Open `iroha/example/genesis_block` file and locate the following block:

```genesis_block
"createRole":{
                             "roleName":"admin",
                             "permissions":[
                                "can_add_peer",
                                "can_add_signatory",
                                "can_create_account",
                                "can_create_domain",
                                "can_get_all_acc_ast",
                                "can_get_all_acc_ast_txs",
                                "can_get_all_acc_detail",
                                "can_get_all_acc_txs",
                                "can_get_all_accounts",
                                "can_get_all_signatories",
                                "can_get_all_txs",
                                "can_get_blocks",
                                "can_get_roles",
                                "can_read_assets",
                                "can_remove_signatory",
                                "can_set_quorum"
                             ]
                          }
```

- Edit it with the admin role permission set root like this:


```genesis_block
                       
                       {
                          "createRole":{
                             "roleName":"admin",
                             "permissions":[
                                "root",
                             ]
                          }
                       
```


2.3 Create local directories at your docker host:

```bash
mkdir ~/ipfs_repo ~/ipfs_repo/staging ~/ipfs_repo/data
```


2.4 Clone the OpenScience repository

```bash
cd ~/

git clone http://github.com/OliveiraEdu/OpenScience
```

2.5 Building the docker imngage

```bash
cd ~/OpenScience/docker
docker build --no-cache -t new_jupyter_lab .
```

2.6 Runnning the docker container
```bash
docker run -it -p 10000:8888 --network=iroha-network new_jupyter_lab
```

2.7 IPFS Node

```bash
docker run -d --name ipfs_node -v ~/ipfs_repo/staging:/export -v ~/ipfs_repo/data:/data/ipfs -p 4001:4001 -p 8080:8080 -p 5001:5001 --network iroha-network ipfs/go-ipfs:v0.4.23
```

2.8 Postgress
```bash
docker run --name some-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 --network=iroha-network -d postgres:9.5 -c 'max_prepared_transactions=100'
```

2.9 Iroha Network

```bash
docker run --name iroha -d -p 50051:50051 -p 7001:7001 -v $(pwd)/iroha/example:/opt/iroha_data -v blockstore:/tmp/block_store --network=iroha-network --restart always -e KEY='node0' hyperledger/iroha-burrow:pr-3960
```

2.10 - IP Address and related connections parameters

For iroha and IPFS, go to the Jupyter, check and edit `config.json` according to the networking settings for your environment.

```json
{
    "IROHA_HOST_ADDR": "10.0.0.100",
    "IROHA_PORT": "50051",
    "ADMIN_ACCOUNT_ID": "admin@test",
    "ADMIN_PRIVATE_KEY": "f101537e319568c765b2cc89698325604991dca57b9716b58016b253506cab70",
    "IPFS_ADDRESS": "10.0.0.100",
    "IPFS_PORT": 5001
}
```

----

## 3 Testing the Platform

#### Before the first run:

1 - Go to the logs directory and delete all JSON files.

2 - Go to the Notebook `5 - Artifact - Indexing and Searching.ipynb`  Step 3, uncomment, execute and 
leave it commented again. This will create the Woosh index and make it available for the next runs.

#### Use the following notebooks in sequence to run the tests on the platform.

|Execute this notebook|Get this outcome|
|---|-----------|
|`1 - Artifact - Contract Deployment.ipynb`| Deploy Contracts for account creation and details settings.
|`2 - Artifact - User Account Creation.ipynb`| Create a random unique user account and set synthetic attributes.
|`3 - Artifact - Project Account Creation.ipynb`| Create a random  unique project account and set synthetic attributes.
|`4 -  Artifact - Cross Link Account and Project Account.ipynb`| Sets the details of the user and project accounts on bi-directional link between them.
|`5 - Artifact -  Indexing and Searching.ipynb`| Build the metadata extractor, index and search engine. Uploads files, extracts and indexes metadata. Search, validates and downloads files. 
|`6 -  Provenance.ipynb`| Execute this to record the provenance of the current transactions over time.
|`7 - Iroha 1 Blockchain Tools.ipynb`| Execute this to get realtime output from the Iroha 1 server about blocks and transactions.

### 4 Summary

This artifact demonstrates the creation and management of user accounts, project accounts, and linked accounts using IPFS and Iroha. 


## 5 Caveats and Workarounds

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


## 6 Future Improvements

### New features

- Improve function `upload_file_to_ipfs` to get the original file name and store it on `file_n_metadata` JSON automatically - Done

### Monitoring

- Use Prometheus for monitoring basic metrics.

### Document functions and generate documentation

- Check functions and maybe breakdown them further for [better maintainability](https://www.linkedin.com/posts/khuyen-tran-1401_productionreadydatascience-datascience-cleancode-activity-7236085519871307776-WLDK/?utm_source=share&utm_medium=member_android) - Done

- Use a vanilla Jupyter Notebook docker image from [Jupyter Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)

### Smart Contracts

- Publish smart contracts in IPFS

### CSV versus JSON

- Replace CSV usage by JSON and store them in IPFS - Done

### RBAC (Role Based Access Control)

- The project owner can designate the role of the other collaborators in RBAC

### Search Engine
- Include projects metadata for indexing - Done
- Consider a knowledge graph for search results (Consider Ontologies like FOAF and Dublin Core) - Partially done, User and Project accounts are registered as metadata formatted in FOAF e DC - Pending Knowledge Graph

- Include user_account and project_acccount, affiliation, full name, role as indexed criterias for searching

### Outputs
- Standardize on Logger whenever is possible - Done

### Entity Relationships Model
- A user should be able to own n projects

- On project details improve the data structute for storing file CID and file metadata CID - Done

### Provenance
- Implementing a git like version control system for provenance - Done (although following a distinct approach for provenance of the blockchain transasctions only)

### Project Details
- Optimize file and file metadata entries - Done

### Python code level improvements
- Improve exiting on exceptions
