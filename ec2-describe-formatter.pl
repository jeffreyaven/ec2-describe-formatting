#!/usr/bin/env perl
#	Perl script to format output from rds-describe commands
#	Usage : 
#	ec2-describe-instances --region ap-southeast-1 --show-empty-fields | perl -x /home/ec2-user/scripts/ec2-general/ec2-describe-formatter.pl
#	ec2-describe-group --region ap-southeast-1 --show-empty-fields | perl -x /home/ec2-user/scripts/ec2-general/ec2-describe-formatter.pl
#	ec2-describe-instance-status --region ap-southeast-1 --show-empty-fields | perl -x /home/ec2-user/scripts/ec2-general/ec2-describe-formatter.pl
#	ec2-describe-network-interfaces --region ap-southeast-1 --show-empty-fields | perl -x /home/ec2-user/scripts/ec2-general/ec2-describe-formatter.pl
#	ec2-describe-subnets --region ap-southeast-1 --show-empty-fields | perl -x /home/ec2-user/scripts/ec2-general/ec2-describe-formatter.pl
#	ec2-describe-volumes --region ap-southeast-1 --show-empty-fields | perl -x /home/ec2-user/scripts/ec2-general/ec2-describe-formatter.pl
#	ec2-describe-images --region ap-southeast-1 --show-empty-fields --filter "name=Image Name" | perl -x /home/ec2-user/scripts/ec2-general/ec2-describe-formatter.pl
#	rds-describe-db-instances --region ap-southeast-1 --show-long | perl -x /home/ec2-user/scripts/ec2-general/ec2-describe-formatter.pl
#
#	Commands supported:
#	ec2-describe-instances
#	ec2-describe-group
#	ec2-describe-instance-status
#	ec2-describe-network-interfaces
#	ec2-describe-subnets
#	ec2-describe-volumes
#	ec2-describe-images
#	rds-describe-db-instances
#
#
#	Author : 		Jeffrey Aven, Aven Solutions Pty Ltd
#	Created:		20 Sep 2013
#	Last Modified:	20 Sep 2013
#
use Switch;

@dbinstance = ("DBInstanceId", "Created", "Class", "Engine", "Storage", "Iops", "Master Username", "Status", "Endpoint Address", "Port", "AZ", "SecAZ", "Backup Retention", "PendingBackupRetention", "PendingClass", "PendingCredentials", "PendingStorage", "PendingIops", "PendingMulti-AZ", "PendingVersion", "DB Name", "Maintenance Window", "Backup Window", "Latest Restorable Time", "Multi-AZ", "Version", "Auto Minor Vers Upgrade", "Read Replica Source ID", "License", "Character Set", "Publicly Accessible");
@secgroup = ("Name", "Status");
@paramgrp = ("Group Name", "Apply Status");
@optiongroup = ("Name", "Status");         
@reservation = ("ReservationId", "Owner", "Groups");
@instance = ("InstanceId", "AmiID", "PublicDNS", "PrivateDNS", "InstanceState", "KeyName", "AmiLaunchIndex", "ProductCodes", "InstanceType", "LaunchTime", "AvailabilityZone", "KernelId", "RamDiskId", "Platform", "MonitoringState", "PublicIp", "PrivateIp", "VpcID", "VpcSubnetId", "RootDevice", "InstanceLifecycle", "SpotInstReqId", "InstanceLicense", "ClustPlcmntGrp", "VirtType", "HypervisorType", "ClientToken", "SecurityGrpId", "Tenancy", "IsEBSOptimized", "ArnNameIAMRole");
@blockdevice = ("DeviceName", "VolumeId", "AttachTimestamp", "IsDeleteOnTerm", "VolumeType", "Iops");
@nic = ("NicId", "SubnetId", "VpcId", "Owner", "Status", "PrivateIp", "PrivateDns", "IsSourceDestChk");
@nicattachment = ("AttachmentId", "DeviceIndex", "Status", "AttachTimestamp", "IsDeleteOnTerm");
@nicassociation = ("PublicIp", "PublicIPowner", "PrivateIp");
@group = ("SecGroupId", "SecGroupName");
@privateipaddressext = ("PrivateIp", "PrivateDNS", "PublicDNS");	
@tag = ("ResourceType", "ResourceId", "Key", "Value");
@groupext = ("SecGroupId", "Owner", "SecGroupName", "SecGroupDesc", "VpcGroupId");
@permission = ("OwnerAcctId", "SecGrpName", "RuleType", "Protocol", "PortStart", "PortEnd", "FromOrTo", "Type", "SourceOrDest", "IngressOrEgress");
@instancestatus = ("InstanceId", "AvailabilityZone", "InstanceStateName", "InstanceStateCode", "InstanceStatus", "SystemStatus", "RetirementStatus", "RetirementDate");
@systemstatus = ("HostSystemStatusName", "HostSystemStatus", "ImpairmentDateTime");
@instancestatusex = ("InstanceStatusName", "InstanceStatus", "ImpairmentDateTime");
@event = ("EventType", "DateTimeOpen", "DateTimeClose", "EventDesc");
@networkinterface = ("NetworkInterfaceID", "Description", "SubnetID", "VpcID", "AvailabilityZone", "OwnerID", "RequesterID", "RequesterManaged", "Status", "MacAddress", "PrivateIpAddress", "PrivateDnsName", "SourceDestCheck");
@attachment = ("InstanceID", "AttachmentID", "Status", "Undefined");
@association = ("ElasticIPAddr", "OwnerID", "AssociationID", "PrivateIP", "PublicDNS");
@privateipaddress = ("PrivateIp", "PrivateDNS");
@subnet = ("SubnetID", "State", "VpcID", "CIDRBlock", "FreeAddressCount", "AvailabilityZone", "DefaultForAZ", "MapPublicIpOnLaunch");
@volume = ("VolumeId", "Size", "SnapshotId", "AvailabilityZone", "Status", "CreateTime", "VolumeType", "Iops");
@volattachment = ("VolumeID", "InstanceID", "Device", "Status", "AttachmentTS", "IsDeleteOnTerm");
@image = ("ImageID",  "Name", "Owner", "State", "Accessibility", "ProductCodes", "Architecture", "ImageType", "KernelId", "RamdiskId", "Platform", "RootDeviceType", "VirtualizationType", "Hypervisor");
@blockdevicemapping = ("DeviceType", "DeviceMapping", "DeviceName", "SnapshotID", "VolSize", "DeleteOnTerm", "VolType", "MaxIOPS");

$headerSep = "------------------------";
$fieldDelim	= " => ";

while (<STDIN>) {
	@currarray;
	$line = $_;
	$line =~ s/(^\s+)|(\s+$)//g;
	$line =~ s/\t/,/g;
	#print "$line\n";
	my @tokens = split(',', $line);
	my $tokensSize = @tokens;
	$grouplength = 0; 
	switch ($tokens[0]){
		case("DBINSTANCE") { @currarray = @dbinstance; }
		case("SECGROUP") { @currarray = @secgroup; }
		case("PARAMGRP") { @currarray = @paramgrp; }
		case("OPTIONGROUP") { @currarray = @optiongroup; }
		case("RESERVATION") { @currarray = @reservation; }
		case("INSTANCE") { @currarray = @instance; }
		case("BLOCKDEVICE") { @currarray = @blockdevice; }
		case("NIC") { @currarray = @nic; }
		case("NICATTACHMENT") { @currarray = @nicattachment; }
		case("NICASSOCIATION") { @currarray = @nicassociation; }
		case("GROUP") { @currarray = @group; }
		case("PRIVATEIPADDRESS") { @currarray = @privateipaddressext; }
		case("TAG") { @currarray = @tag; }
		case("PERMISSION") { @currarray = @permission; }	
		case("SYSTEMSTATUS") { @currarray = @systemstatus; }
		case("INSTANCESTATUS") { @currarray = @instancestatusex; }
		case("EVENT") { @currarray = @event; }	
		case("NETWORKINTERFACE") { @currarray = @networkinterface; }	
		case("ATTACHMENT") { @currarray = @attachment; }	
		case("ASSOCIATION") { @currarray = @association; }	
		case("SUBNET") { @currarray = @subnet; }
		case("VOLUME") { @currarray = @volume; }	
		case("IMAGE") { @currarray = @image; }
		case("BLOCKDEVICEMAPPING") { @currarray = @blockdevicemapping; }		
	}
	# Check Ambiguous Sections
	# GROUP
	if (($tokens[0] eq "GROUP") && ($tokensSize == 6)) {
		@currarray = @groupext;
	}
	#INSTANCE
	if (($tokens[0] eq "INSTANCE") && ($tokensSize == 9)) {
		@currarray = @instancestatus;
	}
	#PRIVATEIPADDRESS
	if (($tokens[0] eq "PRIVATEIPADDRESS") && ($tokensSize == 3)) {
		@currarray = @privateipaddress;
	}
	#ATTACHMENT
	if (($tokens[0] eq "ATTACHMENT") && ($tokensSize == 7)) {
		@currarray = @volattachment;
	}
	
	print "\n$tokens[0]\n";
	print "$headerSep\n";
	my $currarraySize = @currarray;
	my $maxlength = ($currarraySize + ($tokensSize-1) + abs($currarraySize - ($tokensSize-1))) / 2;
	for($i = 0; $i < $maxlength; $i++) {
		printf("%23s%4s%s\n", $currarray[$i], $fieldDelim, $tokens[$i+1]);
	}
}
print "\n";