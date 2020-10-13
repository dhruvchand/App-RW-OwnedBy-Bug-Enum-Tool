
####Identifying Service Principals affected by the bug in the Application.ReadWrite.OwnedBy Application Resource Permission

##Introduction


Microsoft identified a bug in the Application.ReadWrite.OwnedBy permission that caused applications (henceforth called Creator apps) that programmatically create service principals from other applications (hence forth called a Backing App) to create service principals from backing applications that are not owned by the Creator App. The permission should only allow the creation of service principals from backing apps owned by the creator app. 
This bug has been fixed. If your creator app had created service principals using this permission that it should not have been able to, you would have received a notification pointing you to this script. 

This script will enumerate the service principals in your tenant that were created by a creator app from a backing app that it does not own, when it should not have been able to. 

Here are some of the mitigation options available:
1.	If backing applications (from which you were creating service principals) were incorrectly assigned to a different owner (and not your creator app), you can change the owner of those applications to your creator app (or create new ones that are now owned by your creator app)
2.	If you can only have a single creator app and it needs to support creating service principals from your applications and from other multi-tenant applications that are not owned by your creator app, consider using the Application.ReadWrite.All permission.



##How to run this script

1. Connect to your Azure AD Tenant using
`Connect-AzureAD`

2. Run the script with the list of App IDs provided to you

`EnumarateAffedtedSp.ps1 [appid1, appid2, ...]`

The arguments to this script are a list of application IDs that were sent to you as applications that are affected by this bug. 

The output of this script will let you know what service princials were created by the applications `[appid1, appid2, ...]`, whose creation should not have been possible using the Application.ReadWrite.OwnedBy permission. You can then take one of the available mitigation options for the apps `[appid1, appid2, ...]` in your tenant.