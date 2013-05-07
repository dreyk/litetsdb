litetsdb
========

LITETDSB is a vary simple, distributed, scalable database.
It's perfect for store large amount time series data like system logs, time measurements etc.

Litetsdb based on riak_core and has follow features:
- Save sequential data like time series.
- Batch Load operations.
- Range data scan.
- Data replication like riak_kv but more simple(no vector clock and other additional meta on you data),last write win.
- Range based partitioning.
- Use lebeldb as backend.
- Auto data expiration option.

Fore storing you data you must write you own bucket module in which you must define(for example https://github.com/dreyk/etsdb/blob/master/src/etsdb_tkb.erl)
- Partitioning function.
- Serialization and Unserialization function
- Scan data function.

In etsdb_tkb data partitioning by time interval all data that have the same Time div TimeRange will be stored in the same place. You can choose another strategy.

Wee use this database in production, for storing data like id(long)-time(long)-value(byte array). Average load - 1000 samples per sec in production. Benchmark(we use 3 node) show max throughput near 200000 per/sec,for example Cassandara in our benchmark have  throughput 250000 per/sec, but become unreachable after first minute. Litetsdb was more stable under high load.

If it's interesting. I will help you this configuration and testing.