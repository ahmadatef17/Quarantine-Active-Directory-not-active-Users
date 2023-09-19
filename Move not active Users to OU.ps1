<# select Date to use in last login date #>
$No_Of_Months = 6
$d = (Get-Date).AddMonths(-$No_Of_Months)

<# Bring exception list file and put it variable #>
$filePath = "\\dc01\Drivers\ERP\Scripts\Active Directory Related\1- Disable not active users\2- move Users that are not used lately\Exception-list-Users.txt"
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
    $v="CN=,OU=Not-Active-Users,DC=CAIROMETRO,DC=LOCAL"
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
    $vv="CN=,OU=Mobiles,DC=CAIROMETRO,DC=LOCAL"
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

$x=$Not_Used_Users.count
for($k=0 ; $k -lt $x ; $k++)
{
        $Not_Used_Users[$k] = $Not_Used_Users[$k].Replace(" ","")
	$Not_Used_Users[$k] = $Not_Used_Users[$k].Replace("+","")
	$j=$Not_Used_Users[$k]
        $DistName = Get-ADUser -Identity $j -Properties DistinguishedName | ForEach-Object {$_.DistinguishedName}
        $current_dateAndtime = [datetime]::now.tostring("yyyy-MM-dd  hh+mm+ss tt")
        $cdAndt = ($current_dateAndtime).Replace("+",";")
        "$j`n" + "$DistName `n">> "\\dc01\Drivers\ERP\Scripts\Active Directory Related\1- Disable not active users\2- move Users that are not used lately\Text files in which OU those users were\Old OU for Moved Users\Users_not-used-for-$No_Of_Months-months-$cdAndt.txt"
        Move-ADObject -Identity "$DistName" -TargetPath "OU=Not-Active-Users,DC=CAIROMETRO,DC=LOCAL"
}
