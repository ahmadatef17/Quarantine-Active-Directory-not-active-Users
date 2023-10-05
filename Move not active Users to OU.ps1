<# select Date to use in last login date #>
$No_Of_Months = 6
$d = (Get-Date).AddMonths(-$No_Of_Months)
$srv_name = "server01"  <# your sever where you put ( log file, exception list ) on, write even the server name or it's Ip address #>
$domin_pt1= "stc"	<# Here Enter part one of your Domain Name, if your domain name is stc.local ,then enter "stc" #>
$domin_pt2= "local"	<# Here Enter part two of your Domain Name, if your domain name is stc.local ,then enter "local" #>

<# Bring exception list file and put it variable #>
$filePath = "\\$srv_name\path\to\the\Exception-list.txt"
[System.Collections.ArrayList]$exception_list = Get-Content $filePath
<# Bring Not Used Users for "EX: last 6 months" #>
[System.Collections.ArrayList]$Not_Used_Users= Get-ADUser -Filter '(LastLogonDate -lt $d)' -Properties LastLogonDate | ForEach-Object {$_.SamAccountName}
[System.Collections.ArrayList]$N2 = @()

$ee = $Not_Used_Users.count
for ($a=0 ; $a -lt $ee ; $a++)
{
$qq = $Not_Used_Users[$a]
$ll = Get-ADUser -Filter '(SamAccountName -like $qq)' -Properties * | ForEach-Object {$_.Name}
$N2 = $N2 + $ll
}


Write-host "All Users :"
write-host $Not_Used_Users.count, "Users `n-----------"
write-host $Not_Used_Users + "`n"

<# ------------------------------------------------------------------- #>
<# Exclude "Not-Active-Users" OU Users. #>
<# Get list of Users inside "Not-Active-Users" OU. #>

$b=$Not_Used_Users.count
[System.Collections.ArrayList]$OU= @()
for($p=0 ; $p -lt $b ; $p++)
  { 
    $z=$Not_Used_Users[$p]
    $gg=$N2[$p]
    $i="DistinguishedName -like "
    $v="CN=,OU=Not-Active-Users,DC=$domin_pt1,DC=$domin_pt2"
    $v=$v.Replace(" ",",")
    $v=$v.Insert(3,$gg)
    $m=" -AND (SamAccountName -like "
    $y="($i"+'"'+"$v"+'")'+"$m"+'"'+"$z"+'"'+")"
    $o= Get-ADUser -Filter $y -Properties DistinguishedName | ForEach-Object {$_.SamAccountName}
    if($o -ne " ")
    {$OU=$OU+"$o"}
  }

<# Remove the Users inside "Not-Active_Users" OU. #>

$t=$OU.count
for($n=0 ; $n -lt $t ; $n++)
{  if ($OU[$n] -in $Not_Used_Users)
    {
        $u = $OU[$n]
	$Not_Used_Users.Remove("$u")
    }
}

write-host "Users After Removing Users from 'Not-Active-Users' OU, Out of list:"
write-host $Not_Used_Users.count, "Users `n-----------"
write-host $Not_Used_Users , "`n"

<# ------------------------------------------------------------------- #>
<# Exclude users in Exception list. #>
<# Remove the Exception list Users from Not Used Users #>

$c= $exception_list.count

for($s=0 ; $s -lt $c ; $s++)
{   if ($exception_list[$s] -in $Not_Used_Users)
    {
        $w = $exception_list[$s]
	$Not_Used_Users.Remove("$w")
    }
}

write-host "Users After Removing Important Users from the list :"
write-host $Not_Used_Users.count, "Users `n-----------"
write-host $Not_Used_Users + "`n"


<# ------------------------------------------------------------------- #>
<# Exclude "Mobiles" OU Users. #>
<# Get list of Users inside "Mobiles" OU. #>

$bb=$Not_Used_Users.count
[System.Collections.ArrayList]$OUU= @()
for($pp=0 ; $pp -lt $bb ; $pp++)
  { 
    $zz=$Not_Used_Users[$pp]
    $ll = Get-ADUser -Filter '(SamAccountName -like $zz)' -Properties * | ForEach-Object {$_.Name}
    $ii="DistinguishedName -like "
    $vv="CN=,OU=Mobiles,DC=$domin_pt1,DC=$domin_pt2"
    $vv=$vv.Replace(" ",",")
    $vv=$vv.Insert(3,$ll)
    $mm=" -AND (SamAccountName -like "
    $yy="($ii"+'"'+"$vv"+'")'+"$mm"+'"'+"$zz"+'"'+")"
    $oo= Get-ADUser -Filter $yy -Properties DistinguishedName | ForEach-Object {$_.SamAccountName}
    
    if($oo -ne " ")
    {$OUU=$OUU+"$oo"}
  }

<# Remove the Users inside "Mobiles" OU. #>

$tw=$OUU.count
for($nn=0 ; $nn -lt $tw ; $nn++)
{  if ($OUU[$nn] -in $Not_Used_Users)
    {
        $uu = $OUU[$nn]
	$Not_Used_Users.Remove("$uu")
    }
}

write-host "Users After Removing Users from 'Mobiles' OU, out of list :"
write-host $Not_Used_Users.count, "Users `n-----------"
write-host $Not_Used_Users + "`n"

<# ------------------------------------------------------------------- #>
<# Move the rest of users to and write document of old Users Data. #>

$x=$Not_Used_Computers.count

<# variable that have date and time in this format : 2023-09-16  05:21:47 PM #>
$current_dateAndtime = [datetime]::now.tostring("yyyy-MM-dd  hh+mm+ss tt")
$current_dateAndtime = $current_dateAndtime.Replace("+",":")
$current_date = [datetime]::now.tostring("yyyy-MM-dd")

if ($x -ne 0) {
"Run At : " + $current_dateAndtime + "`n---------------------------------" >>  "\\$srv_name\path\to\log\file\Computers_not-used-for-$No_Of_Months-months-$current_date.txt"
}

for($k=0 ; $k -lt $x ; $k++)
{
        $Not_Used_Users[$k] = $Not_Used_Users[$k].Replace(" ","")
	$Not_Used_Users[$k] = $Not_Used_Users[$k].Replace("+","")
	$j=$Not_Used_Users[$k]
 	$last_logon = Get-ADUser -Identity $j -Properties LastLogonDate | ForEach-Object {$_.LastLogonDate}
        $DistName = Get-ADUser -Identity $j -Properties DistinguishedName | ForEach-Object {$_.DistinguishedName}
        "UserName : $j `n" + "Last logon Date : $last_logon `n" + "old OU : $DistName `n" >> "\\$srv_name\path\to\log\file\Computers_not-used-for-$No_Of_Months-months-$current_date.txt"
        Move-ADObject -Identity "$DistName" -TargetPath "OU=Not-Active-Users,DC=$domin_pt1,DC=$domin_pt1"
}

write-host "Users After Removing Users From 'Not-Active-Users' OU from the list:"
write-host $Not_Used_Users.count, "Users `n-----------"
write-host $Not_Used_Users , "`n"
