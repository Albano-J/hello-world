<#
SYNOPSIS: a little script that import users from list in a text file and add them to an ad group
AUTHOR:CHRISTOPHE JULIE
version:0.01

#>
Set-Location $PWD
##The basic stuffs
$filename='userlist.txt'
$groupName='AD-GROUP-NAME' ##Name of group in AD

##connection
##Connect-Azaccount
##getting some IDs
$groupid=(Get-AzADGroup -DisplayName $groupName).Id
$userlist=@()

Get-Content $filename |%{$userlist+= $_}
$userId=$userlist|%{(Get-AzADUser -Mail $_)}

#check existing membership
$targetGroup=(Get-AzADGroupMember -GroupDisplayName $groupName)
$existing=@()
$queue=@()
$userId|%{if ($targetGroup.Id.contains($_.Id)){$existing+=$_  }else{$queue+=$_}}
if($existing.count -ne 0 )
{
    Write-Output "These users are already members :"
    echo $existing.DisplayName
}

if ($queue.count -eq 0)
{Write-Output "no valid users to add"}
else {
    <# Action when all if and elseif conditions are false #>
     
    
    Write-Progress "Adding users:"
    echo $queue.DisplayName
    $queue |%{Add-AzADGroupMember -TargetGroupObjectId $groupid -MemberObjectId $_}
}

##add the users

#$userId |%{Add-AzADGroupMember -TargetGroupObjectId $groupid -MemberObjectId $_}
