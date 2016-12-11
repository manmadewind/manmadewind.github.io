#!/usr/bin/perl
#    创建灯塔日志解析结果虚拟表分发供各业务使用
#    @author    simonpeng
#    @date      2014-07-26
#    
#    update: 2015-06-30
#        
#
BEGIN { unshift @INC, ("/data/script/common"); }
use POSIX;
use UDPPCommon;
$ENV{LANG} =  "POSIX";

# hadoop安装路径
my $HADOOP_BIN_PATH = "/data/home/hadoop/bin";

# 参数判断
if ( @ARGV != 3 )
{
    UDPPCommon::LOG("参数输入有误!");
    exit -1;
}

my $cycle         = $ARGV[0];
my $tmp_del_cycle = $ARGV[1];
my $rzt_del_cycle = $ARGV[2];

my $config_path = "/data/script/common/config/beacon_event_parser";
my $custom_space_dict;

my @table_prefix = 't_si_light_event_log_vtb';
my @productypeList = ('mig', 'mqq', 'ieg', 'other');
my @eventypeList = ('beacon', 'custom');
my $cmd = "";

sub main
{
	UDPPCommon::LOG('START (debug version...)');
	
	# initial 
	my $filename = "${config_path}/${cycle}_beacon_custom_event_dynamic.cf";
	$custom_space_dict->{"mig"}   = ["unknown"];
	$custom_space_dict->{"mqq"}   = ["unknown"];
	$custom_space_dict->{"ieg"}   = ["unknown"];
	$custom_space_dict->{"other"} = ["unknown"];
	
	# Open file	
	UDPPCommon::LOG('Openning file: ${filename}');
	open(my $fh, '<', $filename) or print "Could not open file ${filename}";
	
	while (my $row = <$fh>)
	{
		chomp $row;
		print "$row\n";
		@line_array = split(/\t/, $row);
		
		my $customspace = $line_array[2];
		my $productype  = $line_array[4];
		
		UDPPCommon::LOG("DICT: ${productype} , ${customspace}\n");
		if (exists $dict->${productype})
		{ push(@${dict->${productype}}, $customspace);}
	}    	
	
	# default
    foreach $productype (@productypeList) 
    {
        my $eventype    = 'beacon';
		my $customspace = 'default';
		
		$cmd = "/data/home/hive/bin/hive -e \"use u_wsd; ALTER TABLE ${table_prefix}_${productype}_${eventype} 
		        ADD PARTITION (ds=${cycle}, productype='${productype}', eventype='${eventype}', customspace='${customspace}')\"";
		UDPPCommon::LOG($cmd);
		##system($cmd);
		
		$cmd = "/data/home/hive/bin/hive -e \"use u_wsd; ALTER TABLE ${table_prefix}_${productype}_all 
		        ADD PARTITION (ds=${cycle}, productype='${productype}', eventype='${eventype}', customspace='${customspace}')\"";
		UDPPCommon::LOG($cmd);
		##system($cmd);
		
		$cmd = "/data/home/hive/bin/hive -e \"use u_wsd; ALTER TABLE ${table_prefix}_all_${eventype} 
		        ADD PARTITION (ds=${cycle}, productype='${productype}', eventype='${eventype}', customspace='${customspace}')\"";
		UDPPCommon::LOG($cmd);
		##system($cmd);
    }
	
	# custom
	foreach $productype (@productypeList) 
    {	
		my $eventype    = 'custom';	

		$cmd = "/data/home/hive/bin/hive -e \"use u_wsd; ALTER TABLE ${table_prefix}_${productype}_all 
				ADD PARTITION (ds=${cycle}, productype='${productype}', eventype='${eventype}', customspace='${customspace}')\"";
		UDPPCommon::LOG($cmd);
		#system($cmd);
			
		my @customspaceList = @${custom_space_dict->${productype}};
        foreach $customspace (@customspaceList) 
        {
			$cmd = "/data/home/hive/bin/hive -e \"use u_wsd; ALTER TABLE ${table_prefix}_${productype}_${eventype} 
					ADD PARTITION (ds=${cycle}, productype='${productype}', eventype='${eventype}', customspace='${customspace}')\"";
			UDPPCommon::LOG($cmd);
			##system($cmd);
			
			$cmd = "/data/home/hive/bin/hive -e \"use u_wsd; ALTER TABLE ${table_prefix}_all_${eventype} 
					ADD PARTITION (ds=${cycle}, productype='${productype}', eventype='${eventype}', customspace='${customspace}')\"";
			UDPPCommon::LOG($cmd);
			#system($cmd);
        }
    }

	# model
    $cmd = "/data/home/hive/bin/hive -e \"use u_wsd; ALTER TABLE ${table_prefix}_mig_all ADD PARTITION (ds=${cycle}, productype='all', eventype='model')\"";
    UDPPCommon::LOG($cmd);
    ##system($cmd);

    $cmd = "/data/home/hive/bin/hive -e \"use u_wsd; ALTER TABLE ${table_prefix}_all_model ADD PARTITION (ds=${cycle}, productype='all', eventype='model')\"";
    UDPPCommon::LOG($cmd);
    ##system($cmd);

	# remove
    $cmd = "${HADOOP_BIN_PATH}/hadoop fs -rmr -skipTrash /user/hive/warehouse/u_wsd.db/${table_prefix}_buf/ds=${tmp_del_cycle}";
    UDPPCommon::LOG($cmd);
    ##system($cmd);

    $cmd = "${HADOOP_BIN_PATH}/hadoop fs -rmr -skipTrash /user/hive/warehouse/u_wsd.db/${table_prefix}/ds=${rzt_del_cycle}/productype=mqq/eventype=custom/*";
    UDPPCommon::LOG($cmd);
    ##system($cmd);

    UDPPCommon::LOG("OK!");
}

main();

