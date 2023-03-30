# Usage: reorder [-c] GRAPH_FILE
#   -c    Print community IDs instead of a new ordering
# If flag -c is given, this program runs in the clustering mode (described later); otherwise, it runs in the reordering mode.

make -j
./reorder ../dataset/test_graph 16 -o ./test.cc