#This script removes a Office 365 License from a User.
#Fill in a Global Admin username and Password (this can be your own Office 365 account if you are a global admin in the Office 365 tenant)
#Scripts asks for the UserPrincipleName
#Afterwards choose the subscription you want to remove, commonly option A is the most used option
#Exit Script with X and the license will be removed from the user, to check execute the followin Powershell command:
#Get-MsolUser -UserPrincipalName "Username" value under license must be set on False. This way you know that the script worked..or check the Office 365 Portal
#The script will return a Licenses information so you can see which license the person have active
#You have to adjust the script with your own tenant domain name!
#KingSeifer21 System Administrator\DevOps 18-12-2017, Last update 20-12-2017

$Usercredential = Get-Credential
Connect-MsolService -AzureEnvironment AzureCloud -Credential $Usercredential
$UserInOffice365 = READ-HOST -PROMPT 'Type in UserPrinciple Name'
Get-MsolUser -UserPrincipalName $UserInOffice365
Get-MsolUser -UserPrincipalName $UserInOffice365 | Format-List DisplayName,Licenses
#Set-MsolUser -UserPrincipalName $UserInOffice365 -UsageLocation NL

do {
    do {
        write-host ""
        write-host "A - Remove Offic 365 Business Premium"
        write-host "B - Remove Office 365 Enterprise"
        write-host "C - Remove Visio License"
        write-host "D - Remove Exchange Online License Only"
        write-host ""
        write-host "X - Exit"
        write-host ""
        write-host -nonewline "Type your choice and press Enter: "
        
        $choice = read-host
        
        write-host ""
        
        $ok = $choice -match '^[abcdx]+$'
        
        if ( -not $ok) { write-host "Invalid selection" }
    } until ( $ok )
    
    switch -Regex ( $choice ) {
        "A"
        {
            write-host "You entered 'A'"
            Set-MsolUserLicense -UserPrincipalName $UserInOffice365 -RemoveLicenses "tenant:O365_BUSINESS_PREMIUM"
        }
        
        "B"
        {
            write-host "You entered 'B'"
            Set-MsolUserLicense -UserPrincipalName $UserInOffice365 -RemoveLicenses "tenant:ENTERPRISEPACK"
        }

        "C"
        {
            write-host "You entered 'C'"
            Set-MsolUserLicense -UserPrincipalName $UserInOffice365 -RemoveLicenses "tenant:VISIOCLIENT"
        }

        "D"
        {
            write-host "You entered 'D'"
            Set-MsolUserLicense -UserPrincipalName $UserInOffice365 -RemoveLicenses "tenant:EXCHANGESTANDARD"
        }
    }
} until ( $choice -match "X" )

