ec2-describe-formatting
=======================

Perl script to format EC2, RDS, IAM and S3 command line tools output for describe functions

Formats output from ec2-describe-* functions to a human readable, tabular key-value output as shown below:


          INSTANCE
          --------
          instanceID => i-79fbcb2d
               amiID => ami-889a433b
           publicDNS => ec2-57-23-222-95.ap-southeast-1.compute.amazonaws.com
          privateDNS => ip-10-0-0-52.ap-southeast-1.compute.internal
       instanceState => running
             keyName => ec2-keypair
      amiLaunchIndex => 0
        productCodes => m1.small
        instanceType => 2013-08-30T01:16:19+0000
          launchTime => ap-southeast-1b
    availabilityZone => aki-fe1354ac
            kernelID => monitoring-disabled
           ramDiskID => 57.23.222.95
            platform => 10.0.0.52
     monitoringState => vpc-0d5c0363
            publicIP => subnet-027d742b
           privateIP => ebs
               vpcID => paravirtual
         vpcSubnetID => xen
          rootDevice => sg-38cd3aed
       spotInstReqID => default
     instanceLicense => false

Usage:

$ ec2-describe-instances --show-empty-fields | perl -x /path-to-file/ec2-describe-formatter.pl
