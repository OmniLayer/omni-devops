#!/usr/bin/env groovy
@Grab(group='com.amazonaws', module='aws-java-sdk', version='1.8.7')
import com.amazonaws.services.ec2.AmazonEC2Client
import com.amazonaws.auth.profile.ProfileCredentialsProvider
import com.amazonaws.auth.EnvironmentVariableCredentialsProvider
import com.amazonaws.services.ec2.model.DescribeInstancesRequest
import com.amazonaws.services.ec2.model.AssociateAddressRequest
import com.amazonaws.regions.Region
import com.amazonaws.regions.Regions
import groovy.json.JsonSlurper

def credentials = new EnvironmentVariableCredentialsProvider().getCredentials()

if (args.size() != 2) { println "Usage: associateAddress.groovy <machineName> <address>" ; System.exit(-1) }
def machineName = args[0]
def address = args[1]
def json = "vagrant awsinfo -p -m ${machineName}".execute().text
def info = new JsonSlurper().parseText(json)
def instanceId = info.instance_id

//"ec2-associate-address -i ${instanceId} ${address} --region us-west-2".execute().waitForProcessOutput(System.out, System.err)


println "Creating ec2 client..."
def ec2 = new AmazonEC2Client(credentials)
ec2.region = Region.getRegion(Regions.US_WEST_2)

println "Creating and sending AssociateAddressRequest..."
def req = new AssociateAddressRequest(instanceId, address)
def result = ec2.associateAddress(req)

println "Result: ${result}"


