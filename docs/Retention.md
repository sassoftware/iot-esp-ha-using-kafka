Kafka Retention and ESP Recovery
------------------------------

This section would discuss the relationship between ESP recovery and Kafka Retention.
The recovery refers here is to recovery failed ESP to the same state as active ESP.
The role of message bus, Kafka for our case, would provide transaction history for recovered ESP to replay the transactions and reach the same state as active server.
There is default Retention setting at Kafak.  This would impact ESP recovery if ESP is running longer than retention set at Kafka.

It could also shorten ESP recovery time by setting retention policy at Kafka.




### How Kafka Retention Works


A message sent to a Kafka cluster is appended to the end of one of the
logs. The message remains in the topic for a configurable period or
until a configurable size is reached until the specified retention for
the topic exceeds. The message stays in the log, even if the message has
been consumed.

Apache Kafka uses Log data structure to manage its messages. Log data
structure is basically an ordered set of Segments whereas a Segment is a
collection of messages. Apache Kafka provides retention at Segment level
instead of at Message level. Hence, Kafka keeps on removing Segments
from its end as these violate retention policies.

![](./images/media_segment.png)


Apache Kafka provides two types of Retention Policies.


* Time Based Retention: Once the configured retention time has been reached for Segment, it is
marked for deletion or compaction depending on configured cleanup
policy. Default retention period for Segments is 7 days.


*  Size Based Retention: In this policy, we configure the maximum size of a Log data structure
for a Topic partition. Once Log size reaches this size, it starts
removing Segments from its end. This policy is not popular as this does
not provide good visibility about message expiry. However, it can come
handy in a scenario where we need to control the size of a Log due to
limited disk space.

Low-throughput topics could retain messages longer than expected if you
don't account for the segment-level retention period.

Kafka stores data for each partition on a log, and logs are further
divided into log segments. Kafka determines how long to store data based
on topic-level and segment-level log retention periods. This makes it
tricky to track, on a granular level, how long messages are actually
stored on the broker.

Kafka's approach to segment-level retention

Kafka closes a segment and opens a new one when one of two things
happens (whichever comes first):

*  the segment reaches a maximum size (as determined by segment.bytes)
*  the segment-level retention period has passed (based on segment.ms)


Furthermore, Kafka cannot close a segment while the segment is still
"active," or currently accepting updates. Even after Kafka closes a
segment, it may not expire/delete the segment's messages right away.
Depending on the version you're running, Kafka determines when it can
start expiring messages by adding the segment-level retention period to
either:

-   the last time the segment was modified (prior to v. 0.10.1.0)
-   the timestamp of the last (most recent) message on that segment
    (starting in version 0.10.1.0)

On a high-volume topic, segments tend to get rolled out more frequently,
since they receive enough traffic to reach the default segment size
limit (1 GB) before the end of the segment-level retention period. On a
low-throughput topic, this is usually not the case.

We revised some settings on our low-throughput topics to ensure that
Kafka could roll out new segments more frequently, and to maintain more
control over segment-level data retention. Here are our recommendations
for low-throughput topics, based on what we learned from this
experience:

-   Reduce segment.ms to a value that's less than the topic-level
    retention period (retention.ms), to ensure that we could roll out segments
    more frequently.

### How to Set Kafka Retention 
ESP failover recovery is to replay the history to sync recovered ESP back to the same state as active ESP

We could set Kafka Retention same or slightly larger than retention used by ESP projects.
It would 
* Shorten recovery time
* This could guarantee the recovered ESP project would reach the same state as active ESP Project

When setting Kafka Retetion, it should 
* At topic level due that different retention used by different ESP projects
* At the topics used by publisher connector

To set Retention at Topic level would require to set below setting
* `retention.ms`: This configuration controls the maximum time in mini-second to retain a log before discarding old log segments to free up space if we are using the "delete" retention policy. This represents an SLA on how soon consumers must read their data. If set to -1, no time limit is applied.

* `segment.ms`: This configuration controls the period of time after which Kafka will force the log to roll even if the segment file isn't full to ensure that retention can delete or compact old data.

Using below commmand to set topic level retention
Example: Assuming the topic name is as below
esp61-1.ap-viya-esp.sashq-r.openstack.sas.com_55582.kafkaTest.cq1.Source1.I 

`bin/kafka-configs.sh --zookeeper localhost:2181  --entity-type topics --entity-name esp61-1.ap-viya-esp.sashq-r.openstack.sas.com_55582.kafkaTest.cq1.Source1.I --alter --add-config retention.ms=60000`

`bin/kafka-configs.sh --zookeeper localhost:2181  --entity-type topics --entity-name esp61-1.ap-viya-esp.sashq-r.openstack.sas.com_55582.kafkaTest.cq1.Source1.I --alter --add-config segment.ms=30000`

You could use below command to check topic setting to see whether retention policy is set correctly
```sh
$ bin/kafka-topics.sh --describe --zookeeper localhost:2181  --topic esp61-1.ap-viya-esp.sashq-r.openstack.sas.com_55582.kafkaTest.cq1.Source1.I
Topic:esp61-1.ap-viya-esp.sashq-r.openstack.sas.com_55582.kafkaTest.cq1.Source1.I       PartitionCount:1        ReplicationFactor:3     Configs:retention.ms=60000,segment.ms=30000
        Topic: esp61-1.ap-viya-esp.sashq-r.openstack.sas.com_55582.kafkaTest.cq1.Source1.I      Partition: 0    Leader: 2       Replicas: 2,1,3 Isr: 2,1,3
```

It also needs to set `log.retention.check.interval.ms` at borker level and set this at server property files. The value should be less than the value of retention policy set at Kafka Topic

* `log.retention.check.interval.ms`: 
The frequency in milliseconds that the log cleaner checks whether any log is eligible for deletion. Default is 5 minutes.



### Sequence numbering of Messages

ESP Engine creates sequence numebring of messages and this sequence number is managed by the event stream processor’s connectors for the following purposes:
* detecting duplicates
* detecting gaps
* determining where to resume sending from after a fail-over

When redundant engines receive identical input, this ID is guaranteed to be identical for an event block that is generated by different engines in a failover cluster.

What would happen if recovered ESP project consume less messages than active ESP project?
For example: 

*  ESP project runs longer than the retention policy set for Kafka Topics:  
Kafka does not hold whole messages consumed by active ESP projects due that Kafka deletes messages based on retention policy
Message ID would be out of sync under this situation even the recovered ESP project could reach the same state of active ESP project with partial messages 

### useoffsetmesgid option

If the recovered ESP would consuem less messages as active ESP, then it would need to useoffsetmsgid option when configure connector.
This would use Kakfa offset as sequence number of messages instead generating the sequence number by ESP.
This would allow a recovered ESP to sync back up with other ESPs even if the topic does not contain all messages consumed by other ESPs based on below assumption


*  the messages that are there must still be identical. 
*  the ESP model must be able to reach the same state with the reduced set of messages. 
*  ESP project would need to set retention policy so that it could reach the same state even without replay all events consumed by active ESP project

![](./images/media_useoffset.png)
