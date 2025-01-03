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


