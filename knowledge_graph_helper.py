import networkx as nx
from pyvis.network import Network
from loguru import logger
from iroha_helper import *
import json
from super_helper import *

def build_knowledge_graph(search_results):
    """
    Build a knowledge graph from the search results and their relationships.
    """
    # Initialize a graph
    G = nx.DiGraph()

    logger.info("Starting knowledge graph creation.")

    # Iterate through search results to populate the graph
    for result_dict in search_results:
        project_id = result_dict['project_id']
        file_cid = result_dict['file_cid']
        metadata_cid = result_dict['metadata_cid']

        # Add project node
        G.add_node(project_id, label="Project", shape="ellipse", color="blue")
        logger.debug(f"Added project node: {project_id}")

        # Add file CID node
        G.add_node(file_cid, label="File CID", shape="circle", color="green")
        logger.debug(f"Added file CID node: {file_cid}")

        # Add metadata CID node
        G.add_node(metadata_cid, label="Metadata CID", shape="circle", color="orange")
        logger.debug(f"Added metadata CID node: {metadata_cid}")

        # Link project to file CID
        G.add_edge(project_id, file_cid, label="contains")
        logger.debug(f"Added edge: {project_id} -> {file_cid}")

        # Link file CID to metadata CID
        G.add_edge(file_cid, metadata_cid, label="describes")
        logger.debug(f"Added edge: {file_cid} -> {metadata_cid}")

        # Fetch additional details
        project_details = get_account_detail(project_id)
        blockchain_data = json.loads(project_details)
        validation_result = fetch_project_details(file_cid, blockchain_data)

        if validation_result["is_valid"]:
            project_metadata_cid = validation_result["project_metadata_cid"]
            linked_user = validation_result["linked_user"]

            # Add project metadata CID node
            if project_metadata_cid:
                G.add_node(project_metadata_cid, label="Project Metadata CID", shape="hexagon", color="purple")
                G.add_edge(project_id, project_metadata_cid, label="metadata")
                logger.debug(f"Added edge: {project_id} -> {project_metadata_cid}")

            # Add linked user node
            if linked_user:
                G.add_node(linked_user, label="User", shape="diamond", color="red")
                G.add_edge(linked_user, project_id, label="owns")
                logger.debug(f"Added edge: {linked_user} -> {project_id}")

    logger.info("Knowledge graph creation complete.")
    return G


def visualize_knowledge_graph(G, output_file="knowledge_graph.html"):
    """
    Visualize the knowledge graph using pyvis and save it to an HTML file.
    """
    # Create a PyVis network
    net = Network(notebook=True, directed=True)

    # Populate PyVis network with nodes and edges from NetworkX graph
    for node, data in G.nodes(data=True):
        net.add_node(node, label=data.get("label", node), shape=data.get("shape", "dot"), color=data.get("color", "blue"))

    for source, target, data in G.edges(data=True):
        net.add_edge(source, target, label=data.get("label", ""))

    logger.info("Visualizing the knowledge graph.")
    net.show(output_file)
    logger.info(f"Knowledge graph saved to {output_file}.")


import networkx as nx
from pyvis.network import Network
from loguru import logger
import json


def create_knowledge_graph(search_results, project_details_map, user_details_map):
    logger.info("Creating the knowledge graph...")
    G = nx.MultiDiGraph()

    # Add nodes and relationships
    for result in search_results:
        project_id = result['project_id']
        file_cid = result['file_cid']
        metadata_cid = result['metadata_cid']

        # Project node
        G.add_node(project_id, label=project_id, color="blue", shape="ellipse")
        
        # File CID node
        G.add_node(file_cid, label="File CID", color="green", shape="ellipse")
        G.add_edge(project_id, file_cid, label="contains", color="blue")
        
        # Metadata CID node
        G.add_node(metadata_cid, label="Metadata CID", color="orange", shape="ellipse")
        G.add_edge(file_cid, metadata_cid, label="describes", color="green")
        
        # Project details
        project_details = project_details_map.get(project_id, {})
        user_id = project_details.get("linked_user", "Unknown User")
        G.add_node(user_id, label="User", color="red", shape="diamond")
        G.add_edge(user_id, project_id, label="owns", color="red")
        
        # Project Metadata CID node
        project_metadata_cid = project_details.get("project_metadata_cid")
        if project_metadata_cid:
            G.add_node(project_metadata_cid, label="Project Metadata CID", color="purple", shape="hexagon")
            G.add_edge(project_id, project_metadata_cid, label="metadata", color="purple")
        
        # Additional relationships from metadata
        for keyword in project_details.get("keywords", []):
            G.add_node(keyword, label=keyword, color="purple", shape="circle")
            G.add_edge(project_id, keyword, label="Has Keyword", color="purple")
        
        for location in project_details.get("locations", []):
            G.add_node(location, label=location, color="orange", shape="circle")
            G.add_edge(project_id, location, label="Located In", color="orange")

        # Funding agency (example from expanded relationships)
        funding_agency = project_details.get("funding_agency", "Unknown Agency")
        G.add_node(funding_agency, label="Funding Agency", color="pink", shape="triangle")
        G.add_edge(project_id, funding_agency, label="Funded By", color="pink")

    return G


def visualize_knowledge_graph(G, output_html="knowledge_graph.html"):
    logger.info("Visualizing the knowledge graph...")
    net = Network(height="750px", width="100%", directed=True, notebook=False)

    for node, attrs in G.nodes(data=True):
        net.add_node(node, **attrs)

    for source, target, attrs in G.edges(data=True):
        net.add_edge(source, target, label=attrs["label"], color=attrs["color"])

    net.show(output_html)
    logger.info(f"Knowledge graph saved as {output_html}")


import networkx as nx
from pyvis.network import Network
from loguru import logger
from ipfs_functions import *

def build_knowledge_graph(search_results, index, graph_output_path="knowledge_graph.html"):
    """
    Builds and visualizes a knowledge graph based on search results and metadata.

    Args:
        search_results (list): List of dictionaries containing search results.
        index (Whoosh Index): The Whoosh index for keyword searches.
        graph_output_path (str): Path to save the HTML visualization of the graph.
    """
    # Initialize a directed graph
    graph = nx.DiGraph()

    # Process each search result
    for result_dict in search_results:
        project_id = result_dict.get("project_id")
        file_cid = result_dict.get("file_cid")
        metadata_cid = result_dict.get("metadata_cid")

        if not project_id or not file_cid or not metadata_cid:
            logger.error(f"Missing required data in result: {result_dict}")
            continue

        # Fetch project details from the blockchain
        project_details = get_account_detail(project_id)
        if not project_details:
            logger.error(f"No project details found for Project ID: {project_id}.")
            continue

        try:
            blockchain_data = json.loads(project_details)
        except json.JSONDecodeError as e:
            logger.error(f"Error decoding project details JSON for {project_id}: {e}")
            continue

        # Validate File CID
        validation_result = fetch_project_details(file_cid, blockchain_data)
        if not validation_result["is_valid"]:
            logger.warning(f"Invalid File CID for Project ID: {project_id}. Skipping metadata processing.")
            continue

        project_metadata_cid = validation_result.get("project_metadata_cid")
        linked_user = validation_result.get("linked_user")

        # Add project node
        graph.add_node(project_id, label=f"Project: {project_id}", color="blue", shape="ellipse")

        # Add file node
        graph.add_node(file_cid, label=f"File: {file_cid}", color="orange", shape="box")
        graph.add_edge(project_id, file_cid, label="Has File")

        # Add metadata node if present
        if project_metadata_cid:
            project_metadata = download_json_from_ipfs(project_metadata_cid)
            graph.add_node(metadata_cid, label=f"Metadata: {metadata_cid}", color="green", shape="box")
            graph.add_edge(file_cid, metadata_cid, label="Has Metadata")

        # Process linked user
        if linked_user:
            user_details = get_account_detail(linked_user)
            try:
                user_details = json.loads(user_details)
            except json.JSONDecodeError as e:
                logger.error(f"Error decoding user details JSON for {linked_user}: {e}")
                continue

            user_json_ld_cid = user_details.get("admin@test", {}).get("user_json_ld_cid", None)
            if user_json_ld_cid:
                user_metadata = download_json_from_ipfs(user_json_ld_cid)
                graph.add_node(linked_user, label=f"User: {linked_user}", color="red", shape="diamond")
                graph.add_edge(project_id, linked_user, label="Owner")

    # Visualize the graph
    net = Network(notebook=False, height="750px", width="100%", directed=True)
    net.from_nx(graph)
    net.show(graph_output_path)

    logger.info(f"Knowledge graph generated and saved to {graph_output_path}.")

def build_simple_graph_representation(search_results):
    nodes = set()
    relationships = []

    for result in search_results:  # Iterate over each dictionary in the list
        project_id = result.get('project_id')
        file_cid = result.get('file_cid')
        metadata_cid = result.get('metadata_cid')
        keywords = result.get('keywords', [])
        location = result.get('location')
        owner = result.get('owner')
        has_file = result.get('has_file')

        # Add nodes
        if project_id:
            nodes.add(project_id)
        if owner:
            nodes.add(owner)
            relationships.append(f"{owner} --[Owner]--> {project_id}")
        if location:
            nodes.add(location)
            relationships.append(f"{project_id} --[Located In]--> {location}")
        for keyword in keywords:
            nodes.add(keyword)
            relationships.append(f"{project_id} --[Has Keyword]--> {keyword}")
        if has_file:
            nodes.add(has_file)
            relationships.append(f"{has_file} --[Has File]--> {project_id}")


