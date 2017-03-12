 #!/usr/bin/perl

use FindBin qw($Bin); #full path
use File::Basename qw(dirname); #parse the path
use File::Spec::Functions qw(catdir);
use DBI;
use Net::SNMP;
use Data::Dumper;

my $dirpath=$Bin;
my $dirname=dirname($dirpath);
my $value=catdir($dirname,'db2.conf');
#print "$value";

require $value;

#$dsn = "DBI:mysql::$host";
#$dbh = DBI->connect($dsn, $username, $password);


$dsn = "DBI:mysql:database=$database;host=$host;port=$port ";
$dbh = DBI->connect($dsn, $username, $password);

$s="CREATE TABLE IF NOT EXISTS manidetails (
id int (11) NOT NULL AUTO_INCREMENT,
IP tinytext NOT NULL,
PORT int (11) NOT NULL,
COMMUNITY tinytext NOT NULL,
sysuptime varchar (40) NOT NULL,
sentReq int (25) NOT NULL,
lostReq int (25) NOT NULL,
updatedtime varchar(40) NOT NULL,
status text (40) NOT NULL,
PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;";
my $result = $dbh->do( $s ) or die("Table not created\n");

$det = $dbh->prepare("SELECT * FROM manidetails");
$det->execute() or die ("can't select\n");

if($det->rows == 0)
{
$insert = "INSERT INTO manidetails (id,IP,PORT,COMMUNITY) SELECT id,IP,PORT,COMMUNITY from DEVICES"; 
my $result1 = $dbh->do( $insert ) or die("ERROR \n");

}


$det = $dbh->prepare("SELECT * FROM manidetails");
$det->execute() or die ("can't select\n");


while($ary = $det->fetchrow_arrayref())
{
 $id1=$$ary[0];
 $IP=$$ary[1];
 $PORT=$$ary[2];
 $COMMUNITY=$$ary[3];
 $sr=$$ary[5];
 $lr=$$ary[6];

$session = Net::SNMP->session(Hostname => "$IP",Port => "$PORT",Community => "$COMMUNITY" , Nonblocking=>'1',-timeout=>'1');
$sysuptime = '1.3.6.1.2.1.1.3.0';

$system = $session->get_request(-varbindlist => [$sysuptime],-callback => [\&get_sysuptime, "$id1", "$IP", "$PORT", "$COMMUNITY","$sr", $lr]);
 }#while
snmp_dispatcher();
$session->close;
exit;

sub get_sysuptime
{
   my ($session, $id1, $IP, $PORT, $COMMUNITY) = @_;

	my $uptime = $session->var_bind_list($sysuptime);
#print $uptime;
	
if (!defined($uptime)) 
	{
	   my ($session, $id1, $IP, $PORT, $COMMUNITY, $sr, $lr) = @_;
$updatedtime = localtime();
$sentReq = $sr+1;
$lostreq = $lr+1;

my $mani = $dbh->prepare("UPDATE manidetails SET updatedtime = '$updatedtime',lostreq = '$lostreq',sentReq = '$sentReq',status = 'Not Done' WHERE id = '$id1'"); 
 $mani->execute() or die $DBI::errstr;

	}
else
	{
$sysup = $uptime->{$sysuptime};
$updatedtime = localtime();
$sentReq = $sr+1;

my $update = $dbh->prepare("UPDATE manidetails SET sysuptime = '$sysup',updatedtime = '$updatedtime', sentReq = '$sentReq', status = 'Done' WHERE id = '$id1'");
$update->execute() or die $DBI::errstr;

#print "subvalid\n";
	}#else
}#sub get_sysuptime

