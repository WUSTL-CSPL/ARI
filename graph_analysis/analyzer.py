import networkx as nx
import json
import matplotlib.pyplot as plt
import pygraphviz
from networkx.drawing.nx_agraph import graphviz_layout
import networkx.algorithms.approximation as approx
import networkx.algorithms.dag as dag
import networkx.algorithms.components as comps
import ld_helpers
import devices
from  pprint import pprint
import collections

from key_defs import *

import community as community_louvain

# This can be changed by commandline argument
MAX_DATA_REGIONS = 4

#Number of MPU regions reserved to set global permissions
NUM_DEFAULT_MPU_REGIONS = 4
CPTMT_LEAST_NUM = 30

IVCT_LARGEEST_NUM = 0

CTL_MERGE_THRESHOLD = 500

OTHER_WT_THRESHOLD = 100

CONTROL_EDGES = ['Callee','Indirect Call']

DATA_EDGES = [DATA_EDGE_TYPE, PERIPHERAL_EDGE_TYPE, ALIAS_EDGE_TYPE]

DEFAULT_NODE_ADDR = {'colorscheme':'set312'}

NODE_TYPE_ATTRS = {FUNCTION_TYPE:{},
                   "Indirect":{'shape':'diamond','color':'blue'},
                   GLOBAL_TYPE:{'shape':'box','color':'magenta'},
                   PERIPHERAL_NODE_TYPE:{'shape':'hexagon','color':'orange'},
                   }

EDGE_TYPE_ATTRS = {"Caller":{},
                   "Callee":{},
                   "Indirect Call":{'style':'dotted'},
                   "Data":{'color':'magenta'},
                   "Alias":{},
                   PERIPHERAL_EDGE_TYPE:{'color':'orange'},
                   }
'''
EDGE_TYPE_LUT = {'Callee':'control','Globals':'data','Asm_Calls':'control',
                 'Unknown':'unknown', 'Indirects':'indirect','Filename':'filename'}
NODE_TYPE_LUT = {'Function':('function','ellipse',[]),
                 'Asm_Calls':('asm_call','ellipse',[]),
                 'Globals':('data','box',['Filename']),
                 'Unknown':('unknown','pentagon',[]),
                 'Indirects':('indirect','diamond',['MayCall']),
                 'Filename':('filename','hexagon',[])}
'''

SYSCALL_COMP_REQUIREMENTS = {"_sbrk": ["malloc", "_sbrk_r"]}


#MAP: Filename to section id
map_filename_to_id = {}
map_flag = False
dic_weight = {}

dic_over_ivct = {}

def lowest_cost_data_merge(R,c_region):
    data_regions = nx.get_node_attributes(R,DATA_REGION_KEY).keys()
    preds = []
    for p in R.predecessors(c_region):
        if p in data_regions:
            preds.append(p)

    min_cost = (None,None,None)
    for i in range(len(preds)):
        src = preds[i]
        code_regions = set(R.successors(src))
        for j in range(i+1,len(preds)):
            dest = preds[j]
            code_regions.update(R.successors(dest))
            if min_cost[2] == None:
                min_cost = (src,dest,len(code_regions)-1)
            elif min_cost[2] > len(code_regions):
                min_cost = (src,dest,len(code_regions)-1)

            if min_cost[2] == 0:
                # print "Data min_cost", min_cost
                return min_cost

    # print "Data min_cost", min_cost
    return min_cost


def look_up_mpu_peripheral(R,T,n):
    return R.node[n][KEY_MPU_TREE_NAME]

def lowest_cost_peripheral_merge(R,T,c_region):
    peripheral_regions =[]
    for p in R.predecessors(c_region):
        if R.node[p][TYPE_KEY] == PERIPHERAL_REGION_KEY:
            peripheral_regions.append(p)

    required_pers = set()
    for p in peripheral_regions:
        required_pers.update(R.node[p][KEY_REQUIRED_PERIPHERALS])

    min_cost = (None,None,None)
    for i in range(len(peripheral_regions)):
        src = peripheral_regions[i]
        mpu_tree_src = look_up_mpu_peripheral(R,T,src)
        for j in range(i+1,len(peripheral_regions)):
            dest = peripheral_regions[j]
            mpu_tree_dest = look_up_mpu_peripheral(R,T,dest)
            if mpu_tree_src == None or mpu_tree_dest == None:
                continue

            covered_peripherals = devices.get_covered_peripherals(T,mpu_tree_src,mpu_tree_dest)
            
            if covered_peripherals == None:
                cost = None
            else:
                cost = len(covered_peripherals.difference(required_pers))

            if cost == None:
                pass
            elif min_cost[2] == None:
                min_cost = (src,dest,cost)
            elif min_cost[2] > cost:
                min_cost = (src,dest,cost)

            if min_cost[2] == 0:
                return min_cost
    return min_cost


def move_to_same_comp(R, functs):
    '''
        TODO:  Rename this function, hacked to force the keys in functs to be
        in and their list in default compartment
        Ensures all functions in functs are in the same compartment as their
        key.
        Inputs:
            R - Region graph
            functs - dictionary of lists, with key being function name and list
                     of functions that should be placed in same compartment as
                     the key
        TODO: Extend to use PDG, to update dependencies, for now assumes
              funct_lists are library functions and thus we don't know their
              dependencies
    '''

    code_regions = nx.get_node_attributes(R, CODE_REGION_KEY)

    for key, funct_list in functs.items():
        for n, attr in R.nodes(True):
            if CODE_REGION_KEY in attr:
                for f in funct_list:
                    if f in attr[OBJECTS_KEY]:
                        attr[OBJECTS_KEY].remove(f)

                if key in attr[OBJECTS_KEY]:
                    attr[OBJECTS_KEY].remove(key)


def make_implementable(R, T):
    '''
    Lowers the region graph to number of available MPU regions
        R: A region graph
        T: Device Tree describing MPU regions for peripherals
        This makes the the graph implementable by reducing the number of data
        and peripheral dependancies to below the available mpu threashold.
    '''
    remove_all_non_region_nodes(R)
    move_to_same_comp(R, SYSCALL_COMP_REQUIREMENTS)

    #code_regions = nx.get_node_attributes(R,CODE_REGION_KEY)

    for c_region,attrs in R.nodes(True):
        changed = True
        if attrs[TYPE_KEY] != CODE_REGION_KEY:
            continue
        
        while len(R.predecessors(c_region)) > MAX_DATA_REGIONS and changed:
            changed = False
            
            (d1, d2,d_cost) = lowest_cost_data_merge(R, c_region)
            (p1, p2, p_cost) = lowest_cost_peripheral_merge(R,T,c_region)
            if p_cost == None and d_cost == None:
                changed = False
            elif p_cost == None and d_cost!=None:
                R, changed = merge_data_region(R,d1,d2)
            elif p_cost != None and d_cost == None:
                changed = merge_peripheral_regions(R,T,c_region,p1,p2)
            else:
                if d_cost < p_cost:
                    R, changed = merge_data_region(R,d1,d2)
                    #R, changed = merge_regions(R,d1,d2)
                else:
                    changed = merge_peripheral_regions(R,T,c_region,p1,p2)

            if not changed:
                print "Unable to make implementable", c_region, R.predecessors(c_region)
                return R,False
    return R,True


def merge_data_region(R,d1,d2):
    changed = True
    d1_objs = R.node[d1][OBJECTS_KEY]
    d1_objs.extend(R.node[d2][OBJECTS_KEY])
    R = nx.contracted_nodes(R,d1,d2)
    return R, changed


def merge_regions(R,d1,d2):
    '''
        Merges Code or Data regions
    '''
    if R.node[d1][TYPE_KEY] != R.node[d2][TYPE_KEY]:
        raise TypeError("Trying to merge nodes of different types")

    if R.node[d1][TYPE_KEY] == PERIPHERAL_REGION_KEY:
        raise TypeError("Cannot merge peripherals with this method")

    changed = True
    d1_objs = R.node[d1][OBJECTS_KEY]
    d1_objs.extend(R.node[d2][OBJECTS_KEY])
    contract_nodes_no_copy(R,d1,d2)
    return R, changed


def remove_all_non_region_nodes(R):
    '''
       This should be run after all desired nodes have been mapped to a region
       any unmapped Functions, or Globals will be put in the default always
       accessible regions.  Any unmapped peripherals will be inaccessable
    '''
    count =0
    for node,attrs in R.nodes(True):
        if (not attrs.has_key(TYPE_KEY)) or \
          (not attrs[TYPE_KEY] in [CODE_REGION_KEY,DATA_REGION_KEY,PERIPHERAL_REGION_KEY]):
            count +=1
            if attrs[TYPE_KEY] == PERIPHERAL_REGION_KEY:
                print "WARNING: Removing %s not added a region attrs:" % (node), attrs
            R.remove_node(node)
    code_nodes = nx.get_node_attributes(R,CODE_REGION_KEY).keys()

    #Remove control edges
    for c_node in code_nodes:
        for s in R.successors(c_node):
            R.remove_edge(c_node,s)

    return count


def merge_peripheral_regions(R,T,code_region,per1,per2):
    '''
    Merges peripheral by finding the parent node on the path between the
    nodes
    '''
    #print "Merging P:",per1,":",per2
    p1 = look_up_mpu_peripheral(R,T,per1)
    p2 = look_up_mpu_peripheral(R,T,per2)

    merged = False
    mpu_parent = devices.get_nearest_common_ancestor(T,p1,p2)

    if mpu_parent:
        merged = True
        required_pers = set()
        required_pers.update(R.node[per1][KEY_REQUIRED_PERIPHERALS])
        required_pers.update(R.node[per2][KEY_REQUIRED_PERIPHERALS])
        new_mpu_region,new_attrs = get_mpu_region(T,mpu_parent,code_region,required_pers)
        R.add_node(new_mpu_region,new_attrs)
        remove_covered_peripherals(R,T,code_region,new_mpu_region)

    return merged


def remove_covered_peripherals(R,T,code_region,mpu_region):
    '''
        Removes nodes in R, that are under the added mpu region
        This happens when merging two peripherals in the device tree captures
        other peripherals that the code_region also depends on.
    '''
    mpu_tree_name = R.node[mpu_region][KEY_MPU_TREE_NAME]
    mpu_attrs = R.node[mpu_region]
    #covered_pers = devices.get_covered_peripherals(T,mpu_tree_name)
    for region in R.predecessors(code_region):
        r_attrs = R.node[region]
        if r_attrs[TYPE_KEY] == PERIPHERAL_REGION_KEY:
            other_mpu_region_t_name = r_attrs[KEY_MPU_TREE_NAME]
            if devices.is_child(T,mpu_tree_name, other_mpu_region_t_name):
                mpu_attrs[KEY_REQUIRED_PERIPHERALS].update(r_attrs[KEY_REQUIRED_PERIPHERALS])
                R.add_node(mpu_region, mpu_attrs)
                R.add_edge(mpu_region, code_region)
                R.remove_node(region)


def merge_on_attr(G,attr=REGION_KEY):
    '''
    Merges all nodes that share the same attribute
    '''

    node_to_attr = nx.get_node_attributes(G,attr)
    attr_to_nodelist = {}  # {attr:[nodes,...]}
    for n, attr in node_to_attr.items():
        if not attr_to_nodelist.has_key(attr):
            attr_to_nodelist[attr] = []
        attr_to_nodelist[attr].append(n)

    M = G.copy()
    for attr,node_list in attr_to_nodelist.items():
        root_node =node_list[0]
        for n in node_list[1:]:
            M = nx.contracted_nodes(M,root_node,n,False)
    return M


def get_mpu_config(compartments):
    mpu_config = {}
    for key in compartments.keys():
        attrs = [100794405,319160355,100794387,0]+[0]*MAX_DATA_REGIONS
        addrs = [134217744,536870929,134742034,0]+[0]*MAX_DATA_REGIONS
        mpu_config[key]={"Attrs":attrs,"Addrs":addrs}
    return mpu_config


def get_compartment_description(R):
    '''
        This gets the compartment description which is given to 
        LLVM to apply during compilation
        Input:
            R(region graph): 
        Returns:
            description(dict):  A dictionary that is dumped to a
                                json file that describes the compartments
                                to be made by the compiler
    '''
    #code_regions = nx.get_node_attributes(R,CODE_REGION_KEY)
    #data_regions = nx.get_node_attributes(R,DATA_REGION_KEY)

    description = {POLICY_KEY_REGIONS:{},
              POLICY_KEY_COMPARTMENTS:{},
              POLICY_KEY_MPU_CONFIG:{},
              POLICY_NUM_MPU_REGIONS:NUM_DEFAULT_MPU_REGIONS + MAX_DATA_REGIONS}

    for node,attrs in R.nodes(True):
        if attrs[TYPE_KEY] in [CODE_REGION_KEY,DATA_REGION_KEY]:
            add_region_to_comp_desc(R,node,description)
        if attrs[TYPE_KEY] == CODE_REGION_KEY:
            add_compartment_to_comp_desc(R,node,description)

    mpu_config = get_mpu_config(description[POLICY_KEY_COMPARTMENTS])
    add_default_mpu_config(mpu_config)
    description[POLICY_KEY_MPU_CONFIG] = mpu_config

    return description


def add_default_mpu_config(mpu_config):
    '''
        Default MPU configuration, mostly place holders as
    '''
    default_conf ={
      "Attrs":[100794405,319160355,319094807,319094807].extend([0] * MAX_DATA_REGIONS),
      "Addrs":[134217744,536870929,3758153746,3758153747].extend([0] * MAX_DATA_REGIONS)
    }
    mpu_config["__hexbox_default"] = default_conf


def add_region_to_comp_desc(R,r_node,comp_desc):
    r_node_to_comp_lut = {CODE_REGION_KEY:"Code",DATA_REGION_KEY:"Data","Size":0,"Align":1}
    r_type =R.node[r_node][TYPE_KEY]
    policy_r_type = r_node_to_comp_lut[r_type]
    # print r_node
    # print ("--------")
    # print OBJECTS_KEY
    region = {POLICY_REGION_KEY_OBJECTS: R.node[r_node][OBJECTS_KEY],
              POLICY_REGION_KEY_TYPE: policy_r_type,
              "Size":0,
              "Align":1}
    comp_desc[POLICY_KEY_REGIONS][r_node]=region


def add_compartment_to_comp_desc(R,code_region,comp_desc):
    peripheral_regions = set()
    data_regions = set()
    for p in R.predecessors(code_region):
        if R.node[p][TYPE_KEY] == DATA_REGION_KEY:
            data_regions.add(p)
        elif R.node[p][TYPE_KEY] == PERIPHERAL_REGION_KEY:
            per = ( R.node[p][BASE_ADDR_KEY],
                    R.node[p][PWR2_SIZE_KEY],
                    R.node[p][PRIV_KEY])
            peripheral_regions.add(per)
    pers_dicts =[]
    priv = False
    for per in peripheral_regions:
        pers_dicts.append({"Addr":per[0],"Size":per[1]})
        priv |= per[2]
    compartment = {"Data":list(data_regions),"Peripherals":pers_dicts,"Priv":priv}
    comp_desc[POLICY_KEY_COMPARTMENTS][code_region] = compartment


def add_region_node(R,name,r_type,r_id=0,objects=None,attrs=None,merge=None,name_attr=None):
    if not hasattr(objects,'__iter__'):
        #objects = [objects]
        pass
    region_attrs = {r_type:r_id, TYPE_KEY:r_type}
    if name_attr:
        region_attrs[NAME_KEY]=name_attr
    if objects:
        region_attrs[OBJECTS_KEY]=objects
    if attrs:
        region_attrs[ATTR_KEY]=attrs
    if merge:
        region_attrs[MERGE_KEY]=merge
    R.add_node(name,region_attrs)


def make_peripheral_regions(R,T):
    '''
        R : Region Graph
        T : Peripheral Tree, maps peripherals to mpu regions
        Converts all peripherals to mpu_regions on the peripheral tree,
        each peripheral is mapped to a unique mpu_region per code region.
        IE mpu_region is not shared between code regions
    '''
    for node, attrs in R.nodes(True):
        if attrs[TYPE_KEY] == PERIPHERAL_NODE_TYPE:
            periph = node
            for code_region in R.successors(periph):
                r_type = PERIPHERAL_REGION_KEY
                per_tree_name = attrs[NAME_KEY]
                mpu_tree_name = T.predecessors(per_tree_name)[0]
                mpu_name,mpu_attrs = get_mpu_region(T,mpu_tree_name,
                                                    code_region,[per_tree_name])
                R.add_node(mpu_name,mpu_attrs)
                R.add_edge(mpu_name,code_region)
            R.remove_node(periph)


def get_mpu_region(T,tree_node,code_region,required_pers):

    mpu_attrs = T.node[tree_node]
    if not mpu_attrs.has_key(KEY_REQUIRED_PERIPHERALS):
        mpu_attrs[KEY_REQUIRED_PERIPHERALS] = set()
    mpu_attrs[KEY_REQUIRED_PERIPHERALS].update(required_pers)
    mpu_attrs[KEY_MPU_TREE_NAME] = tree_node
    mpu_name = tree_node+"_"+code_region
    return mpu_name, mpu_attrs


def optimize_filename_groupings(G,filename_to_code_nodes):
    '''
        Inputs:
            move -  boolean to determine if relocations actually happen
    '''
    node_to_filenames = nx.get_node_attributes(G,FILENAME_TYPE)
    for n,attrs in G.nodes(True):
        if attrs[TYPE_KEY] != FUNCTION_TYPE or \
            not node_to_filenames.has_key(n):
            continue
        filename = node_to_filenames[n]
        new_filename = filename
        max_connect = 0
        neighbors = set(nx.all_neighbors(G,n))
        for fname, comp in filename_to_code_nodes.items():
            comp_set = set(comp)
            con = len(neighbors.intersection(comp_set))
            if (con > max_connect):
                new_filename = fname
        filename_to_code_nodes[filename].remove(n)
        filename_to_code_nodes[new_filename].append(n)
        if len(filename_to_code_nodes[filename]) == 0:
            filename_to_code_nodes.pop(filename,None)


def get_peripheral_nodes(G):
    p = filter(lambda (n, d): d['Type'] == PERIPHERAL_NODE_TYPE, G.nodes(data=True))
    return p


def make_region_graph(G,T):
    R = G.copy()
    # make_peripheral_regions(R,T)
    contract_nodes =[]
    type2count = collections.defaultdict(int)
    for n, attrs in G.nodes(True):
        ty = attrs[TYPE_KEY]
        if ty == FUNCTION_TYPE:
            reg_id = type2count[CODE_REGION_KEY]
            type2count[CODE_REGION_KEY] += 1
            reg_name = CODE_REGION_KEY +'%i_' % reg_id
            reg_ty = CODE_REGION_KEY
            add_region_node(R,reg_name,reg_ty,reg_id,[n])
            contract_nodes.append( (reg_name, n) )
        elif ty == GLOBAL_TYPE:
            reg_ty = DATA_REGION_KEY
            reg_id = type2count[DATA_REGION_KEY]
            type2count[DATA_REGION_KEY] += 1
            reg_name = DATA_REGION_KEY +'%i_' % reg_id
            add_region_node(R,reg_name,reg_ty,reg_id,[n])
            contract_nodes.append( (reg_name,n) )
    for (u,v) in contract_nodes:
        contract_nodes_no_copy(R,u,v)
    return R


def partition_by_peripheral(G,T):
    '''
        Forms initial set of compartments by peripheral.
    '''
    R = make_region_graph(G,T)
    print "Partitioning by Peripheral"
    worklist = collections.deque()
    for n, attrs in R.nodes(True):
        print n, attrs
        if attrs[TYPE_KEY]  == PERIPHERAL_REGION_KEY:
            print "Found Peripheral"
            for p in R.successors(n):
                if not p in worklist:
                    print "Adding Predecessor"
                    worklist.append(p)

    # Add all neighboring code regions that are only adjacent to only a
    # single region dependent on a peripheral region
    updated = True
    round_num = 0
    while updated:
        updated = False
        print "Round Number", round_num
        round_num += 1
        potential_merges = collections.defaultdict(set)
        for code_region in worklist:

            dep_per = get_dependent_peripherals(R, code_region)
            all_neighbors = R.predecessors(code_region)
            all_neighbors.extend(R.successors(code_region))
            for n in all_neighbors:
                if n == code_region:
                    continue
                if R.node[n][TYPE_KEY] == CODE_REGION_KEY:
                    n_dep_per = get_dependent_peripherals(R, n)
                    if dep_per == n_dep_per or len(n_dep_per)== 0:
                        print 'Potential Merges: ', code_region, " ", n
                        potential_merges[n].add(code_region)

        # Merge code regions which only have one potential merge code region
        worklist = collections.deque()
        for key, merges in potential_merges.items():
            if len(merges) == 1:
                updated = True
                region = merges.pop()
                if key in R.nodes() and region in R.nodes():
                    merge_regions(R, region, key)
                    worklist.append(region)
                    if key in worklist:
                        worklist.remove(key)

    nx.drawing.nx_pydot.write_dot(R,"by_peripheral_before-final.dot")
    # Merge all areas not dependent on a peripheral
    no_peripheral_regions = []
    for n, attrs in R.nodes(True):
        if attrs[TYPE_KEY] == CODE_REGION_KEY:
            has_peripheral = False
            for s in R.predecessors(n):
                if R.node[s][TYPE_KEY] == PERIPHERAL_REGION_KEY:
                    has_peripheral = True
                    break;
            if not has_peripheral:
                no_peripheral_regions.append(n)
    if len(no_peripheral_regions) > 1:
        code_region = no_peripheral_regions[0]
        for n in no_peripheral_regions[1:]:
            merge_regions(R,code_region,n)

    nx.drawing.nx_pydot.write_dot(R,"by_peripheral_before_lowering.dot")
    R, is_implementable = make_implementable(R,T)
    nx.drawing.nx_pydot.write_dot(R,"by_peripheral_merged.dot")
    if is_implementable:
        return get_compartment_description(R)
    else:
        print "Cannot implement when grouping by peripheral"
        quit(-1)


def get_dependent_peripherals(R, n):
    peripherals = set()
    for s in R.predecessors(n):
        if R.node[s][TYPE_KEY] == PERIPHERAL_REGION_KEY:
            peripherals.update( R.node[s][KEY_REQUIRED_PERIPHERALS])
    return peripherals



def partition_by_filename_no_optimization(G,T):
    return partition_by_filename(G,T,False)




def partition_by_filename_org(G,T,opt=True):
    '''
        Puts all functions from same file in the same region
        Inputs:
            G(PDG):  The program dependency graph
            T(nx.Digraph):  The device description of peripherals as Tree
            opt(bool):      Apply optimizations if True
        Returns:
            (dict):     A compartment description that is given to LLVM
                        as a json file
    '''

    filename_to_code_nodes = collections.defaultdict(list)
    filename_to_data_nodes = collections.defaultdict(list)

    print "Merging By filename, Opt: ", opt
    Region_Graph = G.copy()
    for (node,attrs) in Region_Graph.nodes(True):

        if attrs.has_key(FILENAME_TYPE):
            filename = attrs[FILENAME_TYPE]
            if attrs[TYPE_KEY] == FUNCTION_TYPE:
                # print "functions"
                filename_to_code_nodes[filename].append(node)
            elif attrs[TYPE_KEY] == GLOBAL_TYPE:
                # print "global data"
                filename_to_data_nodes[filename].append(node)
        #add nodes which has no filename into a separate node
        else:
            if attrs[TYPE_KEY] == FUNCTION_TYPE:
                # print("no filename function")
                filename_to_code_nodes["other"].append(node)
            elif attrs[TYPE_KEY] == GLOBAL_TYPE:
                #check whether functions using this global variable are all the same compartment
                # if node.has_key("Connections"):
                #     print("connections" + node["Connections"])

                # print("connections " + str(connections))

                #if yes, assign this global data to the section with the same compartment ID
                #if no, assign this global data to shared data compartment
                
                # print("no filename global")
                filename_to_data_nodes["other"].append(node)

    print(filename_to_code_nodes)
    print("0-------------------0")
    print(filename_to_data_nodes)

    if opt:
        optimize_filename_groupings(G,filename_to_code_nodes)

    # make_peripheral_regions(Region_Graph,T)
    Region_Graph = build_regions_from_dict(Region_Graph,filename_to_code_nodes,CODE_REGION_KEY)
    Region_Graph = build_regions_from_dict(Region_Graph,filename_to_data_nodes,DATA_REGION_KEY)

    Region_Graph, is_implementable = make_implementable(Region_Graph,T)
    is_implementable = True
    nx.drawing.nx_pydot.write_dot(Region_Graph,"by_filename_code_merged.dot")
    if is_implementable:
        return get_compartment_description(Region_Graph)
    else:
        print "Cannot implement when grouping by filename"
        quit(-1)



def partition_by_customised_policy(G,T,opt=True):
    '''
        Puts all functions from same file in the same region
        Inputs:
            G(PDG):  The program dependency graph
            T(nx.Digraph):  The device description of peripherals as Tree
            opt(bool):      Apply optimizations if True
        Returns:
            (dict):     A compartment description that is given to LLVM
                        as a json file
    '''
    filename_to_code_nodes = collections.defaultdict(list)
    filename_to_data_nodes = collections.defaultdict(list)

    Region_Graph = G.copy()

    # iterate node in program dependency graph
    # each node is a function or variable
    # 
    for (node,attrs) in Region_Graph.nodes(True):
        ###################### implement your compartment policy start from here ########################
        # filename_to_code_nodes is dictionary used to store function names in each compartment, key is compartment id, value is functions list
        # filename_to_data_nodes is dictionary used to store variables in each compartment, key is compartment id, value is variables list
        # attrs is attribute of each node, includeing FUNCTION_TYPE, FILENAME_TYPE, CONTROLLER_TYPE, and GLOBAL_TYPE
        # means the node is a function, the filename of file containing the node, the controller name of the node, the node is a global variable
        # below is a filename-based compartment policy, filename is compartment id
        if attrs.has_key(FILENAME_TYPE):
            # partition application using filename
            filename = attrs[FILENAME_TYPE]
            # if node is function
            if attrs[TYPE_KEY] == FUNCTION_TYPE:
                # add function into compartment with its filename as ID
                filename_to_code_nodes[filename].append(node)
            # if node is variable
            elif attrs[TYPE_KEY] == GLOBAL_TYPE:
                # add function into compartment with its filename as ID                
                filename_to_data_nodes[filename].append(node)
        #add nodes which has no filename into a separate node
        else:
            if attrs[TYPE_KEY] == FUNCTION_TYPE:
                filename_to_code_nodes["other"].append(node)
            elif attrs[TYPE_KEY] == GLOBAL_TYPE:  
                filename_to_data_nodes["other"].append(node)
        ######################finish implement your compartment policy here ########################
    if opt:
        optimize_filename_groupings(G,filename_to_code_nodes)
    Region_Graph = build_regions_from_dict(Region_Graph,filename_to_code_nodes,CODE_REGION_KEY)
    Region_Graph = build_regions_from_dict(Region_Graph,filename_to_data_nodes,DATA_REGION_KEY)
    Region_Graph, is_implementable = make_implementable(Region_Graph,T)
    is_implementable = True
    nx.drawing.nx_pydot.write_dot(Region_Graph,"by_filename_code_merged.dot")
    if is_implementable:
        return get_compartment_description(Region_Graph)
    else:
        print "Cannot implement when grouping by filename"
        quit(-1)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

def data_compartment_puting(Region_Graph, filename, filename_to_data_nodes, node):
    # print (Region_Graph.node[node])
    # print(Region_Graph.node[node]["Filename"])

    # print(node + ":")
    # print (Region_Graph.neighbors(node))
    #check whether functions using this global variable are all the same compartment
    use_site_dic = {}
    flag_shared = False
    belong_compartment = None
    for use_site in Region_Graph.neighbors(node):

        # print Region_Graph.node[use_site]
        if(node == "global_data"):
            # print("~~~meet global_data~~~")
            pass
        if not use_site_dic.has_key(Region_Graph.node[use_site]["Filename"]):
            # flag_shared = True
            use_site_dic[Region_Graph.node[use_site]["Filename"]] = 0
            if belong_compartment == None:
                belong_compartment = Region_Graph.node[use_site]["Filename"]
            # break
        else:
            # print("------addtion------")
            use_site_dic[Region_Graph.node[use_site]["Filename"]] += 1

    #if no, assign this global data to shared data compartment
    if len(use_site_dic) > 1:
        # print("+++++++share_data++++++++")
        filename_to_data_nodes["share_data"].append(node)
    #if yes, assign this global data to the section with the same compartment ID
    elif len(use_site_dic) == 1:
        # print("len == 1")
        filename_to_data_nodes[belong_compartment].append(node)
    elif len(use_site_dic) == 0:
        # print("len==0")
        filename_to_data_nodes[filename].append(node)    



def data_compartment_puting_ctl(Region_Graph, controller, controller_to_data_nodes, node):
    # print (Region_Graph.node[node])
    # print(Region_Graph.node[node]["Filename"])

    # print(node + ":")
    # print (Region_Graph.neighbors(node))
    #check whether functions using this global variable are all the same compartment
    use_site_dic = {}
    flag_shared = False
    belong_compartment = None
    for use_site in Region_Graph.neighbors(node):

        use_site_controller = "other"

        # print Region_Graph.node[use_site]
        if(node == "global_data"):
            # print("~~~meet global_data~~~")
            pass

        # print Region_Graph.node[use_site].has_key("Controller")
        # get controller attribute of each neighbor
        if Region_Graph.node[use_site].has_key("Controller"):
            use_site_controller = Region_Graph.node[use_site]["Controller"]

        #filename shoule be controller
        if not use_site_dic.has_key(use_site_controller):
            # flag_shared = True
            use_site_dic[use_site_controller] = 0
            if belong_compartment == None:
                belong_compartment = use_site_controller
            # break
        else:
            # print("------addtion------")
            use_site_dic[use_site_controller] += 1        


        # #filename shoule be controller
        # if not use_site_dic.has_key(Region_Graph.node[use_site]["Filename"]):
        #     # flag_shared = True
        #     use_site_dic[Region_Graph.node[use_site]["Filename"]] = 0
        #     if belong_compartment == None:
        #         belong_compartment = Region_Graph.node[use_site]["Filename"]
        #     # break
        # else:
        #     # print("------addtion------")
        #     use_site_dic[Region_Graph.node[use_site]["Filename"]] += 1

    #if no, assign this global data to shared data compartment
    if len(use_site_dic) > 1:
        # print("++++++++share_data++++++++")
        controller_to_data_nodes["share_data"].append(node)
    #if yes, assign this global data to the section with the same compartment ID
    elif len(use_site_dic) == 1:
        # print("len == 1")
        controller_to_data_nodes[belong_compartment].append(node)
    elif len(use_site_dic) == 0:
        # print("len==0")
        controller_to_data_nodes[controller].append(node) 




def partition_by_filename(G,T,opt=True):
    '''
        Puts all functions from same file in the same region
        Inputs:
            G(PDG):  The program dependency graph
            T(nx.Digraph):  The device description of peripherals as Tree
            opt(bool):      Apply optimizations if True
        Returns:
            (dict):     A compartment description that is given to LLVM
                        as a json file
    '''

    filename_to_code_nodes = collections.defaultdict(list)
    filename_to_data_nodes = collections.defaultdict(list)

    print "Merging By filename, Opt: ", opt
    Region_Graph = G.copy()


    for (node,attrs) in Region_Graph.nodes(True):
        if attrs.has_key(FILENAME_TYPE):
            filename = attrs[FILENAME_TYPE]
            if attrs[TYPE_KEY] == FUNCTION_TYPE:
                filename_to_code_nodes[filename].append(node)
            elif attrs[TYPE_KEY] == GLOBAL_TYPE:               
                data_compartment_puting(Region_Graph, filename, filename_to_data_nodes, node)                

        #add nodes which has no filename into a separate node
        else:
            if attrs[TYPE_KEY] == FUNCTION_TYPE:
                # print("no filename function")
                filename_to_code_nodes["other"].append(node)
            elif attrs[TYPE_KEY] == GLOBAL_TYPE:
                data_compartment_puting(Region_Graph, "other", filename_to_data_nodes, node)                
                # filename_to_data_nodes["other"].append(node)


    # print(filename_to_code_nodes)
    # print("0-------------------0")
    # print(filename_to_data_nodes)



    if opt:
        optimize_filename_groupings(G,filename_to_code_nodes)

    # make_peripheral_regions(Region_Graph,T)
    # CODE_REGION_KEY = ".CODE_REGION_"
    # DATA_REGION_KEY = ".DATA_REGION_"
    Region_Graph = build_regions_from_dict(Region_Graph,filename_to_code_nodes,CODE_REGION_KEY)
    # Region_Graph = build_regions_from_dict(Region_Graph,filename_to_data_nodes,DATA_REGION_KEY)

    Region_Graph = AMI_build_data_regions_from_dict(Region_Graph,filename_to_data_nodes,DATA_REGION_KEY)

    # to_be_debug
    # Region_Graph, is_implementable = make_implementable(Region_Graph,T)
    is_implementable = True
    nx.drawing.nx_pydot.write_dot(Region_Graph,"by_filename_code_merged.dot")
    if is_implementable:
        return get_compartment_description(Region_Graph)
    else:
        print "Cannot implement when grouping by filename"
        quit(-1)

def score_node_region(node_name, region, controller_to_code_nodes):
    score = 0
    for src_fun_name in dic_over_ivct.keys():
        if node_name == src_fun_name:
            for des_fun_name in dic_over_ivct[src_fun_name]:
                for func_in_region in controller_to_code_nodes[region]:
                    if des_fun_name == func_in_region:
                        score += int(dic_weight[src_fun_name][des_fun_name])

    for src_fun_name in dic_over_ivct.keys():
        for func_in_region in controller_to_code_nodes[region]:
            if func_in_region == src_fun_name:
                for des_fun_name in dic_over_ivct[src_fun_name]:
                    if node_name == des_fun_name:
                        score += int(dic_weight[src_fun_name][des_fun_name])

    return score

def partition_by_controller(G, T):


    # print("jinwen enters partition_by_controller")
    '''
        Puts all functions used by the same controller into the same region
        Inputs:
            G(PDG):  The program dependency graph
            T(nx.Digraph):  The device description of peripherals as Tree
        Returns:
            (dict):     A compartment description that is given to LLVM
                        as a json file
    '''    
    controller_to_code_nodes = collections.defaultdict(list)
    controller_to_data_nodes = collections.defaultdict(list)
    Region_Graph = G.copy()

    dic_fun_controller = {}
    

    # print("jinwen checkpoint1")
    #group function and globale variables of the same controller together
    for (node,attrs) in Region_Graph.nodes(True):
        if attrs.has_key(CONTROLLER_TYPE):
            controller = attrs[CONTROLLER_TYPE]
            # print controller
            if attrs[TYPE_KEY] == FUNCTION_TYPE:
                controller_to_code_nodes[controller].append(node)
                dic_fun_controller[node] = controller
            elif attrs[TYPE_KEY] == GLOBAL_TYPE:
                data_compartment_puting_ctl(Region_Graph, controller, controller_to_data_nodes, node)                
                # controller_to_data_nodes[controller].append(node)
        #debug codes
        else:
            if attrs[TYPE_KEY] == FUNCTION_TYPE:
                controller_to_code_nodes["other"].append(node)
                dic_fun_controller[node] = "other"
            elif attrs[TYPE_KEY] == GLOBAL_TYPE:
                data_compartment_puting_ctl(Region_Graph, "other", controller_to_data_nodes, node)                
                # controller_to_data_nodes["other"].append(node)

    #dic_weight[fun_wt_list[0]] = {fun_wt_list[1]: fun_wt_list[2]}
    #dic_over_ivct[fun_wt_list[0]] = [fun_wt_list[1]]

    # print dic_fun_controller.values()
#======================================================================================================
#assign functions in other to each controller

    # print("jinwen checkpoint2")
    # curr_cnt = 0
    # for func_name_node in controller_to_code_nodes["other"]:
    #     print("currr_cnt:%d", curr_cnt)
    #     curr_cnt += 1
    #     max_score = -1
    #     cpt_id = 0
    #     for region in controller_to_code_nodes:
    #         if region == "other":
    #             continue
    #         curr_score = score_node_region(func_name_node, region, controller_to_code_nodes)
    #         if curr_score > max_score:
    #             max_score = curr_score
    #             cpt_id = region

    #     if max_score == -1:
    #         continue
    #     # print func_name_node + " assigned " + str(total_cnt) + "/" + str(len(controller_to_code_nodes["other"]))
    #     controller_to_code_nodes[cpt_id].append(func_name_node)
    #     controller_to_code_nodes["other"].remove(func_name_node)


#======================================================================================================
#partition control and merge
    #OTHER_WT_THRESHOLD

    # to_be_merge_funcs = []

    # for src_fun_name in dic_over_ivct.keys():
    #     for des_fun_name in dic_over_ivct[src_fun_name]:
    #         if src_fun_name in controller_to_code_nodes["other"] and des_fun_name in controller_to_code_nodes["other"]:
    #             if not src_fun_name in to_be_merge_funcs:
    #                 to_be_merge_funcs.append(src_fun_name)
    #             if not des_fun_name in to_be_merge_funcs:
    #                 to_be_merge_funcs.append(des_fun_name)

    # # print len(controller_to_code_nodes["other"])

    # # for func in to_be_merge_funcs:
    # #     controller_to_code_nodes["other"].remove(func)


    # max_score = -1
    # corr_region_id = 0
    # for region_key in controller_to_code_nodes.keys():
    #     if region_key == "other":
    #         continue
    #     #src in controll_to_code_nodes
    #     curr_score = 0
    #     for func_in_region in controller_to_code_nodes[region_key]:
    #         for src_fun_name in dic_over_ivct.keys():
    #             if func_in_region == src_fun_name:
    #                 for des_fun_name in dic_over_ivct[src_fun_name]:
    #                     for func_in_to_merge in to_be_merge_funcs:
    #                         if des_fun_name == func_in_to_merge:
    #                             curr_score += int(dic_weight[src_fun_name][des_fun_name])

    #     for func_in_to_merge in to_be_merge_funcs:
    #         for src_fun_name in dic_over_ivct.keys():
    #             if func_in_to_merge == src_fun_name:
    #                 for des_fun_name in dic_over_ivct[src_fun_name]:
    #                     for func_in_region in controller_to_code_nodes[region_key]:
    #                         if des_fun_name == func_in_region:
    #                             curr_score += int(dic_weight[src_fun_name][des_fun_name])

    #     if curr_score > max_score:
    #         max_score = curr_score
    #         corr_region_id = region_key

    # # print max_score
    # # print corr_region_id

    # cnt_to_move = 0
    # for func in to_be_merge_funcs:
    #     controller_to_code_nodes[corr_region_id].append(func)
    #     controller_to_code_nodes["other"].remove(func)

    # print "merge " + str(len(to_be_merge_funcs)) + " functions from other to " + corr_region_id

#======================================================================================================

    # mover function from other to controller compartment iteratively
    # for i in range(CTL_MERGE_THRESHOLD):
    #     print("iteration: " + str(i))
    #     print ("pre merge \"other\" size: " + str(len(controller_to_code_nodes["other"])))

    #     dic_to_moved = {}

    #     for src_fun_name in dic_over_ivct.keys():
    #         for des_fun_name in dic_over_ivct[src_fun_name]:
    #             # des_fun_name = dic_over_ivct[src_fun_name]
    #             if dic_fun_controller.has_key(src_fun_name) and dic_fun_controller.has_key(des_fun_name):
    #                 src_region_id = dic_fun_controller[src_fun_name]
    #                 des_region_id = dic_fun_controller[des_fun_name]
    #                 if src_region_id != des_region_id:
    #                     if src_region_id == "other" or des_region_id == "other":
    #                         if src_region_id ==  "other":
    #                             if not dic_to_moved.has_key(src_fun_name):
    #                                 dic_to_moved[src_fun_name] = des_region_id
    #                         else:
    #                             if not dic_to_moved.has_key(des_fun_name):
    #                                 dic_to_moved[des_fun_name] = src_region_id
    #             else:
    #                 continue

    #     for to_be_move_name in dic_to_moved.keys():
    #         controller_to_code_nodes["other"].remove(to_be_move_name)
    #         controller_to_code_nodes[dic_to_moved[to_be_move_name]].append(to_be_move_name)
    #         dic_fun_controller[to_be_move_name] = dic_to_moved[to_be_move_name]

    #     print ("after merge \"other\" size: " + str(len(controller_to_code_nodes["other"])))
    #     print ("----------------------------------")

#======================================================================================================


    # print controller_to_code_nodes

    # print(len(controller_to_code_nodes))

    # print(len(controller_to_data_nodes))

    # print("jinwen checkpoint3")

    Region_Graph = build_regions_from_dict(Region_Graph, controller_to_code_nodes, CODE_REGION_KEY)
    # Region_Graph = build_regions_from_dict(Region_Graph, controller_to_data_nodes, DATA_REGION_KEY)
    Region_Graph = AMI_build_data_regions_from_dict(Region_Graph,controller_to_data_nodes,DATA_REGION_KEY)

    # Region_Graph, is_implementable = make_implementable(Region_Graph,T)
    is_implementable = True
    nx.drawing.nx_pydot.write_dot(Region_Graph, "by_controller_code_merged.dot")
    if is_implementable:
        return get_compartment_description(Region_Graph)
    else:
        print "Cannot implement when grouping by controller"
        quit(-1)




def partition_by_controller_org(G, T):
    '''
        Puts all functions used by the same controller into the same region
        Inputs:
            G(PDG):  The program dependency graph
            T(nx.Digraph):  The device description of peripherals as Tree
        Returns:
            (dict):     A compartment description that is given to LLVM
                        as a json file
    '''    
    controller_to_code_nodes = collections.defaultdict(list)
    controller_to_data_nodes = collections.defaultdict(list)
    Region_Graph = G.copy()
    
    #group function and globale variables of the same controller together
    for (node,attrs) in Region_Graph.nodes(True):
        if attrs.has_key(CONTROLLER_TYPE):
            controller = attrs[CONTROLLER_TYPE]
            if attrs[TYPE_KEY] == FUNCTION_TYPE:
                controller_to_code_nodes[controller].append(node)
            elif attrs[TYPE_KEY] == GLOBAL_TYPE:
                controller_to_data_nodes[controller].append(node)
        #debug codes
        else:
            if attrs[TYPE_KEY] == FUNCTION_TYPE:
                controller_to_code_nodes["other"].append(node)
            elif attrs[TYPE_KEY] == GLOBAL_TYPE:
                controller_to_data_nodes["other"].append(node)


    Region_Graph = build_regions_from_dict(Region_Graph, controller_to_code_nodes, CODE_REGION_KEY)
    Region_Graph = build_regions_from_dict(Region_Graph, controller_to_data_nodes, DATA_REGION_KEY)

    Region_Graph, is_implementable = make_implementable(Region_Graph,T)
    is_implementable = True
    nx.drawing.nx_pydot.write_dot(Region_Graph, "by_controller_code_merged.dot")
    if is_implementable:
        return get_compartment_description(Region_Graph)
    else:
        print "Cannot implement when grouping by controller"
        quit(-1)


def partition_by_sensor_actruator(G, T):
    '''
        Puts all functions used by the same controller into the same region
        Inputs:
            G(PDG):  The program dependency graph
            T(nx.Digraph):  The device description of peripherals as Tree
        Returns:
            (dict):     A compartment description that is given to LLVM
                        as a json file
    ''' 
    pass



def contract_nodes_no_copy(G,keep_node,node):
    '''
    same as nx.contract_nodes except doesn't copy the graph instead modifies.
    It contracts the nodes, by moving all edges
    of node, to keep_node, and then removing node

    '''
    for p in G.predecessors(node):
        G.add_edge(p,keep_node)
    for s in G.successors(node):
        G.add_edge(keep_node,s)
    G.remove_node(node)

#Region_Graph = build_regions_from_dict(Region_Graph,filename_to_data_nodes,DATA_REGION_KEY)
#filename_to_data:filename1, [data1, data2, ... ,datan]
#                 filename2, [data1, data2, ..., datan]

#MAP: Filename to section id
# map_filename_to_id = {}
# map_flag = False


def build_regions_from_dict(R,region_dict,r_type,r_id=1):
    # print region_dict
    # print region_dict.keys()
    global map_flag, map_filename_to_id

    for key, nodes in region_dict.items():
        region_name = r_type + str(r_id)+"_" 
        #building map from filename to compartment id during first invocation
        if not map_flag:
            map_filename_to_id[key] = r_id

        r_id += 1

        add_region_node(R,region_name,r_type,r_id,nodes,merge=key)
        for node in nodes:
            contract_nodes_no_copy(R,region_name,node)
            if R.has_node(node):
                R.remove_node(node)
                print "Removed: ", node

    #recording map from filename to compartment id finished
    map_flag = True
    return R

#Region_Graph = AMI_build_data_regions_from_dict(Region_Graph,filename_to_data_nodes,DATA_REGION_KEY)

def AMI_build_data_regions_from_dict(R,region_dict,r_type,r_id=0):

    global map_flag, map_filename_to_id

    # for key, nodes in region_dict.items():
    #     print (key)

    #shared_data canbe found by chekcing key
    for key, nodes in region_dict.items():

        # print (key)

        if not (key == "share_data"):
            # print map_filename_to_id
            region_name = r_type + str(map_filename_to_id[key])+"_" 
            add_region_node(R,region_name,r_type,map_filename_to_id[key],nodes,merge=key)

        else:
            #data region 0 is shared data
            region_name = r_type + str(0) +"_"
            add_region_node(R,region_name,r_type,0,nodes,merge=key)


        for node in nodes:
            contract_nodes_no_copy(R,region_name,node)
            if R.has_node(node):
                R.remove_node(node)
                print "Removed: ", node

    #recording map from filename to compartment id finished
    # print(map_filename_to_id)

    map_flag = True
    return R 

def AMI_build_data_regions_from_dict_best_partition(R,region_dict,r_type,r_id=0):

    # print region_dict.keys()
    global map_flag, map_filename_to_id

    for key, nodes in region_dict.items():
        region_name = r_type + str(r_id)+"_" 

        r_id += 1

        add_region_node(R,region_name,r_type,r_id,nodes,merge=key)

        for node in nodes:
            contract_nodes_no_copy(R,region_name,node)
            if R.has_node(node):
                R.remove_node(node)
                print "Removed: ", node

    #recording map from filename to compartment id finished
    map_flag = True
    return R




def add_nodes(G,json_data,node_types):
    for node_name,node in json_data.items():
        if node_name.startswith("llvm"):
            continue
        node_ty = node["Attr"]["Type"]
        if not node_ty in node_types:
            continue
        attrs = {}
        # print node_name
        # print node["Attr"]
        # print NODE_TYPE_ATTRS[node_ty]
        attrs.update(node["Attr"])
        attrs.update(NODE_TYPE_ATTRS[node_ty])
        # print attrs
        G.add_node(node_name,attrs)


def make_isr_comp(G):
    irq_region_name = IRQ_REGION_NAME
    irq_list = []
    for node, attrs in G.nodes(True):
        if attrs[TYPE_KEY] == FUNCTION_TYPE and node in devices.INTERRUPT_HANDLERS:
            irq_list.append(node)
    irq_attrs = {TYPE_KEY:CODE_REGION_KEY, OBJECTS_KEY:irq_list}
    G.add_node(irq_region_name,irq_attrs)
    for n in irq_list:
        # print "irq_list"
        contract_nodes_no_copy(G,irq_region_name,n)


def add_edges(G,json_data,edge_types):
    global dic_weight
    # print dic_weight
    '''
        Reads in edges from json data to PDG
        Inputs:
            G(nx.DiGraph):  PDG graph
            json_data(dict):      Dependencies found from LLVM analysis
            edge_type(list):    List of edge types to add to PDG
    '''
    for node_name,node in json_data.items():


        # #jinwen add
        # if G.node[node_name]["Attrs"] == GLOBAL_TYPE:
        #     continue


        if node_name.startswith("llvm"):
            continue
        if not node.has_key("Connections"):
            continue
        if not G.has_node(node_name):
            continue
        #print node_name
        for dest_name, con_info in node["Connections"].items():
            if not G.has_node(dest_name):
                continue
            if dest_name.startswith("llvm"):
                continue
            con_ty = con_info[TYPE_KEY]
            if not con_ty in edge_types:
                continue
            attr_dict = {}
            attr_dict.update(con_info)
            attr_dict.update(EDGE_TYPE_ATTRS[con_ty])
            #jinwen
            #add weight here
            # print node_name

            # if dic_weight.has_key(node_name):
            #     if dic_weight[node_name].has_key(dest_name):
            #         attr_dict["weight"] = int(dic_weight[node_name][dest_name])

            # for des, wt in dic_weight.items():
            #     print [des, wt] 
            # if dic_weight[node_name][0]

            # attr_dict["weight"] = 1
            # print attr_dict
            # G.add_edge(node_name, dest_name, attr_dict=attr_dict)
            if dic_weight.has_key(node_name):
                if dic_weight[node_name].has_key(dest_name):
                    G.add_edge(node_name, dest_name, attr_dict=attr_dict, weight = int(dic_weight[node_name][dest_name]))
            else:
                G.add_edge(node_name, dest_name, attr_dict=attr_dict, weight = 0)


def add_size_info(G,json_size_file):
    with open(json_size_file) as infile:
        data = json.load(infile)
        properties = {}
        for node_name,props in data.items():
            for key,value in props.items():
                if not properties.has_key(key):
                    properties[key] = {}
                properties[key][node_name] = value
        for p, nodes in properties.items():
            nx.set_node_attributes(G,p,nodes)


def remap_peripherals(G, device_desc):
    '''
      G: Dependancy Graph
      Device_desc: Description of peripherals on devices

      Takes constant address access output by compiler which is a heuristic of
      the peripherals accessed and identifies smallest MPU region that will 
      cover it from device description
    '''
    remove_nodes = []
    successors = {}
    predecessors = {}
    for (n, attrs) in G.nodes(True):
        # print n
        # print attrs
        # print "======================="
        if attrs[TYPE_KEY] == PERIPHERAL_NODE_TYPE:
            base_addr = attrs["Addr"]
            if base_addr == 0xFFFFFFFF:
                remove_nodes.append(n)
                continue
            size = attrs["DataSize"]
            new_node = devices.get_peripheral_dict(device_desc, base_addr, size)

            if new_node:
                node_name = ".periph."+new_node[NAME_KEY]
                #print "Adding Pnode", node_name, new_node
                G.add_node(node_name,new_node)
                if not successors.has_key(node_name):
                    successors[node_name]=[]
                if not predecessors.has_key(node_name):
                    predecessors[node_name]=[]
                successors[node_name].extend(G.successors(n))
                predecessors[node_name].extend(G.predecessors(n))
                remove_nodes.append(n)
            else:
                print "Failed to Remap", n, ": ", attrs

    G.remove_nodes_from(remove_nodes)
    for node, successor_list in successors.items():
        for successor in successor_list:
            G.add_edge(node, successor)

    for node, predecessor_list in predecessors.items():
        for predecessor in predecessor_list:
            G.add_edge(predecessor, node)


def build_graph(dependancy_json):
    '''
        Reads in the program dependancy graph from json file produced by the analysis
        pass of the compiler.  Then builds a networkx graph of Globals and
        functions
    '''
    with open(dependancy_json, 'rb') as infile:
        json_data = json.load(infile)
    PDG = nx.DiGraph()
    add_nodes(PDG,json_data,['Function','Global', PERIPHERAL_NODE_TYPE])
    add_edges(PDG,json_data,['Callee','Indirect Call','Data','Alias',PERIPHERAL_EDGE_TYPE])
    return PDG


def best_partition(G,T,opt=True):

    # print dic_over_ivct

    '''
        Puts all functions from same file in the same region
        Inputs:
            G(PDG):  The program dependency graph
            T(nx.Digraph):  The device description of peripherals as Tree
            opt(bool):      Apply optimizations if True
        Returns:
            (dict):     A compartment description that is given to LLVM
                        as a json file
    '''
    # dic_weight = {}
    # for line in open("/home/osboxes/Desktop/conattest/ardupilot/invocation_wt.txt"):
    #     fun_wt_list = line.strip().split(",")
    #     if G.node.has_key(fun_wt_list[0]):
    #         if not dic_weight.has_key(fun_wt_list[0]):
    #             dic_weight[fun_wt_list[0]] = [(fun_wt_list[1], fun_wt_list[2])]
    #         else:
    #             dic_weight[fun_wt_list[0]].append((fun_wt_list[1], fun_wt_list[2]))

    # print dic_weight

    Region_Graph = G.copy()
    idPDG = G.copy()
    partition_code_region = {}
    partition_data_region = {}

    idPDG = idPDG.to_undirected()

    partition = community_louvain.best_partition(idPDG,  weight='weight')

    # print len(partition)
    # for (node,attrs) in Region_Graph.nodes(True):
    #     if attrs.has_key(CONTROLLER_TYPE):
    #         controller = attrs[CONTROLLER_TYPE]
    #         if attrs[TYPE_KEY] == FUNCTION_TYPE:
    #             controller_to_code_nodes[controller].append(node)
    #         elif attrs[TYPE_KEY] == GLOBAL_TYPE:
    #             controller_to_data_nodes[controller].append(node)
    #     #debug codes
    #     else:
    #         if attrs[TYPE_KEY] == FUNCTION_TYPE:
    #             controller_to_code_nodes["other"].append(node)
    #         elif attrs[TYPE_KEY] == GLOBAL_TYPE:
    #             controller_to_data_nodes["other"].append(node)

    # print partition


    # for (node, attrs) in Region_Graph.nodes(True):
    #     if attrs[TYPE_KEY] == FUNCTION_TYPE:
    #         if not partition_code_region.has_key(partition[node]) 
    #         partition_code_region[partition[node]]
    #     elif attrs[TYPE_KEY] == GLOBAL_TYPE:


    for name in partition.keys():
        region_id = str(partition[name])
        # if name == "_ZN6Copter17update_auto_armedEv":
        #     # print ("----")
        if G.node[name]["Type"] == FUNCTION_TYPE:
            if not partition_code_region.has_key(region_id):
                partition_code_region[region_id] = [name]
            else:
                partition_code_region[region_id].append(name)

        elif G.node[name]["Type"] == GLOBAL_TYPE:
            if not partition_data_region.has_key(region_id):
                partition_data_region[region_id] = [name]
            else:
                partition_data_region[region_id].append(name)

    # print partition_code_region
    # print ("-----------------")
    # print partition_data_region
    # print partition_code_region.keys()

    print "pre weight-based merge:" + str(len(partition_code_region))

    cnt_to_be_merged = 0
    cnt_1 = 0
    cnt_2 = 0

    # if partition.has_key("_ZN6Copter5setupEv"):
    #     print "_____"

    # if partition.has_key(dic_over_ivct["_ZN6Copter5setupEv"]):
    #     print "++++"

    # print(dic_over_ivct["_ZN6Copter5setupEv"])

    # print(dic_over_ivct["_ZNK8HAL_SITL3runEiPKPcPN6AP_HAL3HAL9CallbacksE"])

    # print dic_over_ivct["_ZN7HALSITL9Scheduler10stop_clockEy"]

    # print partition

    # print dic_over_ivct["_ZNK8HAL_SITL3runEiPKPcPN6AP_HAL3HAL9CallbacksE"]

    for key in dic_over_ivct:
        if not partition.has_key(key):
            # print key + "\n"
            continue
        src_region_id = str(partition[key])
        
        for des_name_in_ivct in dic_over_ivct[key]:

            src_region_id = str(partition[key])

            if not partition.has_key(des_name_in_ivct):
                # print dic_over_ivct[key] + "\n"
                continue
            des_region_id = str(partition[des_name_in_ivct])
            # print str(src_region_id) + " " + str(des_region_id)
            if not src_region_id == des_region_id:
                # cnt_to_be_merged += 1
                if not partition_code_region.has_key(src_region_id) or not partition_code_region.has_key(des_region_id):
                    # print ("-------")
                    # print key
                    cnt_1 += 1
                    continue
                else:
                    cnt_2 += 1
                len_src = len(partition_code_region[src_region_id])
                len_des = len(partition_code_region[des_region_id])

                if len_src <= len_des:
                    for src_name in partition_code_region[src_region_id]:
                        # print partition[src_name]
                        partition_code_region[des_region_id].append(src_name)
                        #change region id and key relation ship in partion dic
                        partition[src_name] = int(des_region_id)
                        # print partition[src_name]
                    del partition_code_region[src_region_id]
                else:
                    for des_name in partition_code_region[des_region_id]:
                        # print partition[des_name]
                        partition_code_region[src_region_id].append(des_name)
                        #change region id and key relation ship in partion dic
                        partition[des_name] = int(src_region_id)
                        # print partition[des_name]
                    del partition_code_region[des_region_id]

    print "merge:" + str(cnt_2) + " not merge: " +str(cnt_1)
    print ("merge threshold: " + str(IVCT_LARGEEST_NUM))

    print "after weight-based merge:" + str(len(partition_code_region))


 
    total_cnt = 0
    to_be_merge = 0

    merge_flag = 0
    merge_id = 10000

    # print len(partition_code_region)
    # print len(partition_data_region)
    print "per comp_size-based merge:" + str(len(partition_code_region))

    stop_flag = 1


    while stop_flag:

        stop_flag = 0
        merge_flag = 0
        merge_id = 10000
        
        for key in partition_code_region.keys():
            total_cnt += 1
            if len(partition_code_region[key]) < CPTMT_LEAST_NUM:
                # total_cnt += 1
                if merge_flag == 0:
                    merge_flag = 1
                    merge_id = key
                    # if not partition_data_region.has_key(merge_id):
                    #     partition_data_region[merge_id] = []
                else:
                    for name_to_merge in partition_code_region[key]:
                        partition_code_region[merge_id].append(name_to_merge)
                    del partition_code_region[key]
                    stop_flag = 1
                    break
                    # if partition_data_region.has_key(key):
                    #     print key
                    #     for name_to_merge in partition_data_region[key]:
                    #         partition_data_region[merge_id].append(name_to_merge)
                    #     del partition_data_region[key]



        # print ("code pre-partition:" + str(total_cnt) + "merge threshold: " + str(CPTMT_LEAST_NUM))
        # print ("code after-partition: " + str(len(partition_code_region)))

    total_cnt = 0
    to_be_merge = 0

    merge_flag = 0
    merge_id = 10000


    stop_flag = 1

    while stop_flag:

        stop_flag = 0
        merge_flag = 0
        merge_id = 10000
        for key in partition_data_region.keys():
            total_cnt += 1
            if len(partition_data_region[key]) < CPTMT_LEAST_NUM:
                # total_cnt += 1
                if merge_flag == 0:
                    merge_flag = 1
                    merge_id = key
                    # if not partition_data_region.has_key(merge_id):
                    #     partition_data_region[merge_id] = []
                else:
                    for name_to_merge in partition_data_region[key]:
                        partition_data_region[merge_id].append(name_to_merge)
                    del partition_data_region[key]
                    stop_flag = 1
                    break
    print ("merge threshold: " + str(CPTMT_LEAST_NUM))
    print "after comp_size-based merge:" + str(len(partition_code_region))


    # print ("data pre-partition:" + str(total_cnt) + "merge threshold: " + str(CPTMT_LEAST_NUM))
    # print ("data after-partition: " + str(len(partition_code_region)))

    # print partition_code_region.keys()
    # print partition_data_region.keys()



    # make_peripheral_regions(Region_Graph,T)
    # CODE_REGION_KEY = ".CODE_REGION_"
    # DATA_REGION_KEY = ".DATA_REGION_"
    Region_Graph = build_regions_from_dict(Region_Graph,partition_code_region,CODE_REGION_KEY)
    # Region_Graph = build_regions_from_dict(Region_Graph,filename_to_data_nodes,DATA_REGION_KEY)

    Region_Graph = AMI_build_data_regions_from_dict_best_partition(Region_Graph,partition_data_region,DATA_REGION_KEY)

    # to_be_debug
    # Region_Graph, is_implementable = make_implementable(Region_Graph,T)
    is_implementable = True
    nx.drawing.nx_pydot.write_dot(Region_Graph,"by_best_partition_code_merged.dot")
    if is_implementable:
        return get_compartment_description(Region_Graph)
    else:
        print "Cannot implement when grouping by filename"
        quit(-1)    


if __name__ == '__main__':
    PARTITION_METHODS = {"filename":partition_by_filename,
                         'peripheral':partition_by_peripheral,
                         "filename-no-opt":partition_by_filename_no_optimization,
                         "controller":partition_by_controller,
                         "sensor/actrator":partition_by_sensor_actruator,
                         "best_partition":best_partition}
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-j','--json_graph',dest='json_graph',required=True,
                    help='Json file describing the Nodes of a graph from llvm')
    parser.add_argument('-s','--size',dest='size_file', help='JSON Size File')
    parser.add_argument('-o','--output',dest='outfile',
                        help='JSON file with layout of program, and\
                        allowed transitions of the program')
    parser.add_argument('-T','--linker_template',dest='linker_template',
                        help='Template Linker File')
    parser.add_argument('-L','--linker_output',dest='linker_output',
                        help='Output Linker Script, required with -T')
    parser.add_argument('-m','--method',dest='partion_method',
                        help=('Method for partitionin, valid options: '+str(PARTITION_METHODS.keys()))
                        )
    # parser.add_argument('-b','--board',dest='board',
    #                     help=('Target Board, valid options: '+str(devices.DEVICE_DEFS.keys())),
    #                     required = True
    #                     )
    
    parser.add_argument('-b','--board',dest='board',
                        help=('Target Board, valid options: '+str(devices.DEVICE_DEFS.keys()))
                        )    

    parser.add_argument('-n','--num_mpu_regions',dest='num_mpu_regions',
                        help=('Number of MPU regions on target'),
                        default=8, type=int
                        )

    args = parser.parse_args()
    # global MAX_DATA_REGIONS
    MAX_DATA_REGIONS = args.num_mpu_regions - NUM_DEFAULT_MPU_REGIONS

    if args.partion_method and not args.outfile:
        print "-o, --outfile: Required with -m(--method)"
        quit(-1)

    cnt_over_ivct = 0
    # global dic_weight
    for line in open("../ardupilot/invocation_wt.txt"):
        fun_wt_list = line.strip().split(",")
        # if PDG.node.has_key(fun_wt_list[0]):
        if not dic_weight.has_key(fun_wt_list[0]):
            dic_weight[fun_wt_list[0]] = {fun_wt_list[1]: fun_wt_list[2]}
            if int(fun_wt_list[2]) >= IVCT_LARGEEST_NUM:
                if not dic_over_ivct.has_key(fun_wt_list[0]):
                    dic_over_ivct[fun_wt_list[0]] = [fun_wt_list[1]]
                    cnt_over_ivct += 1
                else:  
                    dic_over_ivct[fun_wt_list[0]].append(fun_wt_list[1])
                    cnt_over_ivct += 1

        else:
            dic_weight[fun_wt_list[0]].update({fun_wt_list[1]: fun_wt_list[2]})
            if int(fun_wt_list[2]) >= IVCT_LARGEEST_NUM:
                if not dic_over_ivct.has_key(fun_wt_list[0]):
                    dic_over_ivct[fun_wt_list[0]] = [fun_wt_list[1]]
                    cnt_over_ivct += 1
                else:  
                    dic_over_ivct[fun_wt_list[0]].append(fun_wt_list[1])
                    cnt_over_ivct += 1

    # print dic_weight

    PDG = build_graph(args.json_graph)
    device_desc,T = devices.get_device_desc(args.board)

    if args.outfile and args.partion_method:
        # nx.drawing.nx_pydot.write_dot(PDG,"all_nodes.dot")
        # make_isr_comp(PDG) #empty for cortex-a (interrupt service routine) 
        remap_peripherals(PDG, device_desc) #empty for cortex-a
        comp_def = PARTITION_METHODS[args.partion_method](PDG,T)

        # print comp_def

        with open(args.outfile,'wb') as outfile:
            json.dump(comp_def, outfile, sort_keys=True,
                      indent=4, separators=(',', ': '))

        if args.linker_template and args.linker_output:
            # ld_helpers.make_linker_script(args.linker_template,
            #                               args.linker_output,
            #                               comp_def)

            ld_helpers.AMI_make_linker_script(args.linker_template,
                                          args.linker_output,
                                          comp_def)
