#powershell file

# This creates two variables the username and password for the user account
$username = "New_user"
$password = ConvertTo-SecureString -String "12DigitPasscod3" -AsPlainText -Force

# For Each new user run this line that creates a new local user and sets the variables to the account
New-LocalUser -Name $username -Password $password -PasswordNeverExpires:$true -UserMayNotChangePassword:$false
# After the user logs into account they should change the password to something secure they want
# I set Password never expires to True so that when they does change it to something they want then they shouldnt have to change it again unless security reasons

# Creating a new local group called Employees
New-LocalGroup -Name "Employees" -Description "This is the group for all of the employees"
# Adding the employee to the employees group 
Add-LocalGroupMember -Group "Employees" -Member $username

# This is be a message on the screen when the steps are done 
Write-Output "User account created for $username"

# Login to the user account to make sure it is accessable 

-------------------------------------------

#This is to set up a new network drive.
## This is going to be the new network drive name
$drive = "N"
## This creates the path that the drive will be located in
## replace "\\server\share" with actual path when it created. 
$networkPath = "\\server\share"
## This will ask for credentials 
## $credentials = Get-Credential 


function Test-UserGroupMembership {
    # This sets the parameters of the username and groupname to the previously specified username and groupname
    param (
        [string]$username,
        [string]$Employees
    )
    # This is setting the testing parameters within the variable that will check in the try statement 
    $user = New-Object System.Security.Principal.NTAccount($username)
    $group = New-Object System.Security.Principal.NTAccount($Employees)
    # This is running a try statement to check if the security of the person is consistent with the group and is in the group. If not it will spit out a detailed Error Message
    try {
        $isMember = $user.Translate([System.Security.Principal.SecurityIdentifier]).IsInRole($group.Translate([System.Security.Principal.SecurityIdentifier]))
        return $isMember
    }
    catch {
        Write-Error "Error checking group membership $($_.Exception.Message)"
        return $false
    }
}

# Checks if the user is a member of $Employees and if it will map network drive and enable remote access to desktop through powershell and the firewall
if (Test-UserGroupMembership -UserName $username -GroupName $Employees) {
    # map network drive for users that are in the Employees group
    Write-Output "Mapping Network drive N"
    New-PSDrive -Name $drive -PSProvider FileSystem -Root $networkPath -Persist
    Write-Output "Enabling Remote Access through Firewall and Powershell"
    # This is for powershell remote access
    Enable-PSRemoting -Force
    Enable-NetFirewallRule -Name "WinRM-HHTP-In-TCP" -Force
    # This is for allowing remote desktop 
    Enable-NetFirewallRule -Name "RemoteDesktop-UserMode-In-TCP" -Force
} else {
    Write-Output "Member is not in group Employees"
}

