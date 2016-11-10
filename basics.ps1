
# Time-Series 2016 -- find out how many basic datasets have been used.

:out do{

switch($psversiontable.psversion.major){
{$_-lt4}{write "need powershell 4 or later";break out}
default:{}
}

$tsserver=read-host "server";$user=read-host "user";$password=read-host "password";
#$user="a";$password="a";$tsserver="alex6";

$prov_ep="http://$tsserver/aquarius/provisioning/v1";
$pub_ep="http://$tsserver/aquarius/publish/v2";

$authtoken=""
try{
write("logging in...");
$authtoken=invoke-restmethod $prov_ep/session -contenttype "application/json" -method POST -Body (@{Username=$user;EncryptedPassword=$password;Locale=""}| convertto-json)
write "done";
}catch{write "could not log in";break out}

try{
write("fetching dataset list...");
$dsl=invoke-restmethod $pub_ep/gettimeseriesdescriptionlist -contenttype "application/json" -method GET -Headers @{"X-Authentication-Token"=$authtoken};
write("finished");
}catch{write "could not fetch dataset list"}
$dsl=$dsl.TimeSeriesDescriptions;

$numbasic=($dsl | where { $_.TimeSeriesType-eq"ProcessorBasic"}).length

write "$numbasic basic datasets have been created so far.";

}while(0);
cmd /c pause;

