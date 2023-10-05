# Quarantine-Active-Directory-not-active-Users 
<dl>

  <picture>
  <img alt="Quarantine Not-Active-Users from Active Directory" src="https://i.imgur.com/aCGirE4.png">
</picture>

<dt>📂File 1 : move not Active Computers to OU.ps1</dt>
<dd><br>
  why writting this powershell script ?

> In our company the active directory was full with users that are not active.

<H4> Before Running this Script </H4>

> Don't forget to create Organization Unit 'OU' in Active Directory Directly after in Domain-name container,
>
>  and name it "Not-Active-Users", so the path will be for-example:
>
> "OU=Not-Active-Users,DC=my-Domain,DC=LOCAL" or "my-Domain.local/Not-Active-Users"
 
<H4>GOD Willing, This powershell script do the following : </H4>

1- Select all Users that their "last login date" exceed for example 6 months <br>
&ensp; &ensp;"You can modify the number : 3 months or whatever you want",<br>
&ensp; &ensp;Then move them to new Organization Unit (OU) named 'Not-Active-Users'

2- During this operation the script :
> 2.1- The script go to file named 'exception-list.txt' <br>
> &ensp; &ensp; &ensp;that include ( important users ) SAMAccountName "the username used in login to domain computers", <br>
> &ensp; &ensp; &ensp;That I don't want to be touched or moved "exclude those users while running this script".

> 2.2- The script will ignore all the Users inside "Not-Active-Users" OU <br>
> &ensp; &ensp; &ensp;when counting the Users that Need to be Moved.

> 2.3- The script will ignore all users inside OU called "Mobiles", <br>
> &ensp; &ensp; &ensp;You can ignore this part by commenting it by putting before it "<#", Putting after it "#>" <br>
> &ensp; &ensp; &ensp;or you can edit this part to exclude important OU's, That you Don't want the Script to touch Users inside of it.

3- Move users should be moved, to "Not-Active-Users" OU.

4- At the end create log file that contains users moved to'Not-Active-Users' OU folloing Data :
> name,<br>
> last log on date,<br>
> old OU. 'before moving'


<H4> After Running this Script </H4>

You will disable all the users in , if no complain occured in let's say 1 month,
then delete those Users.
</dd>
<br>

$${\color{green}\Large GOD \space WILLING, \space after \space that \space we \space will \space have \space active \space directory \space clear \space of \space not \space active \space users.}$$

$${\color{green}\Large good \space end \space right.}$$

<br>
📜file 1 Credits : <br>
&ensp; &ensp; &ensp; &ensp; &ensp; &ensp; &ensp; &ensp; &ensp; &ensp; &ensp; https://shellgeek.com/get-aduser/ <br>
https://community.spiceworks.com/topic/2001760-powershell-script-for-enabled-users-lastlogondate-30-days/ <br>
https://activedirectorypro.com/last-logon-time/
<br>
<br>
<dt> 📂File 2 : Exception-list.txt </dt>
<dd>
&ensp; &ensp; &ensp;Put the important Users here, that shouldn't be moved by this script.<br>
&ensp; &ensp; &ensp; &ensp; &ensp; &ensp; &ensp; &ensp; &ensp; (Those Users will be safe from this script)
</dd>


<dt>📂File 3 : Extra/get OU Users count.ps1 </dt>
<dd>
&ensp; &ensp; &ensp;"Not Related but, extra feature if you want to count the Users in Specific OU in your Active Directory"

&ensp;📜file 3 Credits : https://stackoverflow.com/questions/32484212/get-a-count-of-users-in-a-specific-ou-and-its-sub-ous
</dd>
