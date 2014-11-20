#!/usr/bin/env groovy
@Grab(group='com.amazonaws', module='aws-java-sdk', version='1.8.7')
import com.amazonaws.services.rds.AmazonRDSClient
import com.amazonaws.auth.EnvironmentVariableCredentialsProvider
import com.amazonaws.regions.Region
import com.amazonaws.regions.Regions
import com.amazonaws.services.rds.model.CreateDBInstanceRequest

String instanceID = System.getenv("OMNI_DB_INSTANCE")
String securityGID = System.getenv("OMNI_DB_SEC_GID")
String username = System.getenv("PGUSER")
String password = System.getenv("PGPASSWORD")

def client = new RDSClient()
client.createDBInstance(instanceID, securityGID, username, password, true)

class RDSClient {
    private AmazonRDSClient rds

    public RDSClient() {
        def credentials = new EnvironmentVariableCredentialsProvider().getCredentials()
        println "Creating RDS client..."
        rds = new AmazonRDSClient(credentials)
        rds.region = Region.getRegion(Regions.US_WEST_2)
    }

    public createDBInstance(String instanceID, String securityGID, String username, String password, Boolean publicIP) {
        def req = new CreateDBInstanceRequest()
                .withDBInstanceIdentifier(instanceID)
                .withEngine("postgres")
                .withEngineVersion("9.3.3")
                .withDBInstanceClass("db.t2.micro")
                .withAllocatedStorage(5)
                .withPubliclyAccessible(publicIP)
                .withVpcSecurityGroupIds(securityGID)
                .withBackupRetentionPeriod(0)
                .withMasterUsername(username)
                .withMasterUserPassword(password)

        def result = rds.createDBInstance(req)
        println result
    }
}
