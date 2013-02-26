
* removed the overall `:java_heap_size_max` setting, in favor of moderate JT and NN (1GB) and modest DN and TT (384MB).
  - removed the secondarynn heap size, as you should never set it differently than the namenode heap.


## Hadoop Cookbook 3.0.4

* Added `fake_topology` recipe -- hadoop topology script to bin nodes into artificial racks based on cluster/facet/index
