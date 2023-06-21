import networkx as nx
import matplotlib.pyplot as plt

# MultiGraph:nx.drawing.nx_pydot.read_dot("../navio2_callgraph.dot")
# MG = nx.drawing.nx_pydot.read_dot("../navio2_callgraph.dot")
# G = nx.Graph(nx.drawing.nx_pydot.read_dot("../navio2_callgraph.dot"))
MG = nx.readwrite.gpickle.read_gpickle("navio2_callgraph.gpickle")
DG = nx.DiGraph(MG)
# nx.draw(G, with_labels=True, font_weight='bold')
# plt.show()

