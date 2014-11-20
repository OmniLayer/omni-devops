#!/usr/bin/env groovy
@Grab(group='com.amazonaws', module='aws-java-sdk', version='1.8.7')
import com.amazonaws.services.rds.AmazonRDSClient
import com.amazonaws.auth.EnvironmentVariableCredentialsProvider
import com.amazonaws.services.rds.model.DescribeDBInstancesRequest
import com.amazonaws.regions.Region
import com.amazonaws.regions.Regions

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

def credentials = new EnvironmentVariableCredentialsProvider().getCredentials()
println "Creating RDS client..."
def rds = new AmazonRDSClient(credentials)
rds.region = Region.getRegion(Regions.US_WEST_2)

println "Waiting for instance ${instanceId} to be 'available'..."
String instanceStatus
while (true) {
    instanceStatus = getStatus(rds, instanceId)
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

String getStatus(def rds, String instanceId) {
    def req = new DescribeDBInstancesRequest().withDBInstanceIdentifier(instanceId)
    def instance = rds.describeDBInstances(req).getDBInstances()[0]
    def status = instance.getDBInstanceStatus()
}
