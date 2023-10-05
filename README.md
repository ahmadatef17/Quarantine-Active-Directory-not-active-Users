<picture>
  <img alt="Quarantine Not-Active-Users from Active Directory" src="https://i.imgur.com/aCGirE4.png">
</picture>


📰 # Quarantine-Active-Directory-not-active-Users 


📂File 1 :
<# move not Active Computers to OU.ps1 #>

why writting this powershell script ?

> In our company the active directory was full with users that are not active.

<H4> Before Running this Script </H4>

> Don't forget to create Organization Unit 'OU' in Active Directory Directly after in Domain-name container,
>
>  and name it "Not-Active-Users", so the path will be
> 
> for-example: "OU=Not-Active-Users,DC=my-company,DC=LOCAL" or "my-company.local/Not-Active-Users"
 
So this powershell scriptdo the following :

1- select all Users that their "last login date" exceed for example 6 moths -you can modify the number: 3 months what ever you want-
then move them to new Organization Unit (OU) named 'Not-Active-Users'

2-
> 2.1- During this operation the script go to file named 'exception-list.txt'
> that include ( important users ) SAMAccountName "the name used in login to domain computers", That I don't want to be touched or moved
> except those users while running this script.

> 2.2- During this operation the script will ignore all the Users inside "Not-Active-Users" OU when counting the Users that Need to be Moved.

> 2.3- During this operation the script will ignore all users inside OU called "Mobiles", you can Ignore this part by commenting it by putting before it "<#", after it "#>"

3- At the end create log file that contain data of
the users that are moved to 'Not-Active-Users' OU
> name,

> last log on date,

> old OU. 'before moving'

<H4> After Running this Script </H4>

You will disable all the users in , if no complain occured in let's say 1 month,
then delete those Users.

<H4>GOD WILLING, after that we will have active directory clear of not active Users.
good end right.</H4>

📜file 1 Credits : 
https://shellgeek.com/get-aduser/

https://community.spiceworks.com/topic/2001760-powershell-script-for-enabled-users-lastlogondate-30-days

https://activedirectorypro.com/last-logon-time/

📂File 2 :
<# Exception-list.txt #>

put the important Users here, that shouldn't be moved by this script.
(Those Users will be safe from this script)

📂File 3 :
<# Extra/get OU Users count.ps1 #>

"Not Related but, extra feature if you want to count the Users in Specific OU in your Active Directory"

📜file 3 Credits : 
https://stackoverflow.com/questions/32484212/get-a-count-of-users-in-a-specific-ou-and-its-sub-ous
