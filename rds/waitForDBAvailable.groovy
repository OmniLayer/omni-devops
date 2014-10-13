#!/usr/bin/env groovy
Integer sleepMillis = 60*1000       // 1 minute
Integer timeOut = 60*sleepMillis    // 1 hour
Integer timeWaited = 0
String instanceId

if (args.size() == 0) {
    instanceId = System.getenv("OMNI_DB_INSTANCE")
    if (instanceId == null) {
        println "OMNI_DB_INSTANCE env var must be defined or instanceId specified as command argument"
    }
} else if (args.size() == 1) {
    instanceId = args[0]
} else {
    println "Usage: waitForDBAvailable.groovy [instanceId]"
    System.exit(-1)
}
println "Waiting for instance ${instanceId} to be 'available'..."
String instanceStatus
while (true) {
    instanceStatus = getStatus(instanceId)
    println "Status is: ${instanceStatus}"
    if (instanceStatus == 'available') {
        break
    } else if (timeWaited > timeOut ) {
        println "Timeout"
        System.exit(-1)
    }
    sleep sleepMillis
    timeWaited += sleepMillis
}

String getStatus(String instanceId) {
    String command="rds-describe-db-instances ${instanceId} --show-xml"
    String xml = command.execute().text
    def DescribeDBInstancesResponse = new XmlParser().parseText(xml)
    def instance = DescribeDBInstancesResponse.DescribeDBInstancesResult.DBInstances.DBInstance[0]
    if (instance == null) throw new Exception("No DB instance exists for id '${instanceId}'")
    String status = DescribeDBInstancesResponse.DescribeDBInstancesResult.DBInstances.DBInstance[0].DBInstanceStatus.text()
    return status
}
