hbase(main):001:0> create 'test', 'cf'
0 row(s) in 1.8790 seconds

hbase(main):002:0> list 'test'
TABLE
test
1 row(s) in 0.0140 seconds

hbase(main):003:0> put 'test', 'row1', 'cf:a', 'value1'
0 row(s) in 0.2820 seconds

hbase(main):004:0> put 'test', 'row2', 'cf:b', 'value2'
0 row(s) in 0.0200 seconds

hbase(main):005:0> put 'test', 'row3', 'cf:c', 'value3'
0 row(s) in 0.0110 seconds

hbase(main):006:0> scan 'test'
ROW                                                                 COLUMN+CELL
 row1                                                               column=cf:a, timestamp=1327191186018, value=value1
 row2                                                               column=cf:b, timestamp=1327191192269, value=value2
 row3                                                               column=cf:c, timestamp=1327191198788, value=value3
3 row(s) in 0.0500 seconds

hbase(main):006:0> scan 'test', { LIMIT => 2, STARTROW => 'row1'}
ROW                                                                 COLUMN+CELL
 row1                                                               column=cf:a, timestamp=1327191186018, value=value1
 row2                                                               column=cf:b, timestamp=1327191192269, value=value2
2 row(s) in 0.0500 seconds

hbase(main):007:0> get 'test', 'row1'
COLUMN                                                              CELL
 cf:a                                                               timestamp=1327191186018, value=value1
1 row(s) in 0.0130 seconds

hbase(main):008:0> disable 'test'
0 row(s) in 2.0470 seconds

hbase(main):009:0> drop 'test'
0 row(s) in 1.1700 seconds
