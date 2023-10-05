<# this code is to get the number of users in specific Organozation Unit 'OU' in Active Directory #>
<# replace : "OU=Not-Active-Users,DC=my-Domain,DC=LOCAL" with OU "DistinguishedName" you want to count it's Users #>
$ous = Get-ADOrganizationalUnit -Filter * -SearchBase "OU=Not-Active-Users,DC=CAIROMETRO,DC=LOCAL" | Select-Object -ExpandProperty DistinguishedName
$ous | ForEach-Object{
    [psobject][ordered]@{
        OU = $_
        Count = (Get-ADUser -Filter * -SearchBase "$_").count
    }
}

<# 
Credits : Matt in
https://stackoverflow.com/questions/32484212/get-a-count-of-users-in-a-specific-ou-and-its-sub-ous
#>
