
echo -e "\n Executing cluster_local.sh...\n"
# ipath=../dataset/graph
# opath=../dataset/graph

# python3 /mnt/data/nfs/yusong/code/SumInc/expr2/sh/gen_inc2.py /mnt/data/nfs/yusong/dataset/large/soc-twitter/soc-twitter.e 0.0001 -w=0 

name=google
# name=europe_osm
# name=web-uk-2005
percentage=0.0001 # 0.3000 0.4000
max_comm_size=5000
max_level=3
beta=0.80
# inc
ipath=/home/yusong/dataset/${name}/${percentage}/${name}.base
opath=/home/yusong/dataset/louvain_bin/${name}_${percentage}
# no-inc
# percentage=
# ipath=/home/yusong/dataset/${name}/${name}.e
# opath=/home/yusong/dataset/louvain_bin/${name}

echo ipath=${ipath}
echo opath=${opath}

rabbit_order_path=/home/yusong/code/rabbit_order/demo

# 聚类
cmd="${rabbit_order_path}/reorder ${ipath} -c -o ${opath}_node2comm_level "  # q=0: modularity, q=10: suminc
echo $cmd
eval $cmd

# --------------------------------------------------------------------------------------------------------------------
# 为SumInc提供超点数据
echo -e "\nGen supernode:"
getSpNode_path=/home/yusong/code/test/SumInc
echo ${getSpNode_path}/getSpNode.cc
g++ ${getSpNode_path}/getSpNode.cc -o ${getSpNode_path}/getSpNode
${getSpNode_path}/getSpNode ${name} ${percentage}


# --------------------------------------------------------------------------------------------------------------------
# ./matrix ${path}.tree -l ${level} > ${path}_X_level${level}
echo -e "\nStart compute:"
cmd="mpirun -n 1 /home/yusong/code/a_autoInc/SumInc/build/ingress -application pagerank -vfile /home/yusong/dataset/${name}/${name}.v -efile ${ipath} -directed=1 -cilk=true -termcheck_threshold 1 -app_concurrency 1 -compress=1 -portion=1 -min_node_num=5 -max_node_num=1003 -sssp_source=16651563 -compress_concurrency=1 -build_index_concurrency=52 -compress_type=2 -serialization_prefix /home/yusong/ser/one"  # 阈值1，提前收敛
echo $cmd
eval $cmd