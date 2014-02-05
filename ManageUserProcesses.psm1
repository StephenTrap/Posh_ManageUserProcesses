<#
.Synopsis
   This cmdlet allows termination of a process in a user's session.
.DESCRIPTION
   When using RDS (terminal services) this cmdlet will allow an admin to remotely terminate a process on a specific user's session.
.EXAMPLE
   Stop-ProcessPerUser -ComputerName batcomputer -process notepad.exe -user batman

   Here we are terminating 'notepad.exe' for 'batman' on his server 'batcomputer'
#>
function Stop-ProcessPerUser
{
    [CmdletBinding()]
    Param
    (
        # Server. Specify the RDS server.
        [Parameter(Mandatory=$true, Position = 0)]
        [string]$ComputerName,

        # Process. Specify the process to end.
        [Parameter(Mandatory=$true, Position = 1)]
        [string]$Process,

        # User. Specify the user to end the process for.
        [Parameter(Mandatory=$true, Position = 2)]
        [string]$User
    )

    Begin
    {
        $PName = (Get-WmiObject -Class Win32_Process -Filter "Name= '$Process'" -ComputerName $ComputerName | 
        Where-Object { $_.GetOwner().User -eq $User })
    }
    Process
    {


        if($PName){

            Get-WmiObject -Class Win32_Process -Filter "Name= '$Process'" -ComputerName $ComputerName | 
            Where-Object { $_.GetOwner().User -eq $User } | 
            Foreach-Object { $_.Terminate() } | select ProcessName

            Write-Host "$Process has been terminated for $User on $ComputerName. Great job!" -ForegroundColor Cyan
        }
        else{
            Write-Host "'$Process' is not running for $User on $ComputerName. Double-check your parameters." -ForegroundColor Red
        }
       
    }
    End
    {
    }
}

<#
.Synopsis
   This cmdlet checks to see if the processes are running in a user's session.
.DESCRIPTION
   This cmdlet will allow an admin to remotely check if processes are running on a specific user's session in a specified server/workstation.
.EXAMPLE
   Get-ProcessPerUser -ComputerName batcomputer -user batman

   Here we are checking to see if any processes are running for 'batman' on his server 'batcomputer'
#>
function Get-ProcessPerUser
{
    [CmdletBinding()]
    Param
    (
        # Server. Specify the RDS server.
        [Parameter(Mandatory=$true, Position = 0)]
        [string]$ComputerName,

        # Process. Specify the process to end.
       # [Parameter(Mandatory=$true, Position = 1)]
       # [string[]]$Process,

        # User. Specify the user to end the process for.
        [Parameter(Mandatory=$true, Position = 1)]
        [string]$User
    )

    Begin
    { 
        Write-Host "The script is executing ..."

        
    }
    Process
    {     
        $PName = (Get-WmiObject -Class Win32_Process -ComputerName $ComputerName | 
        Where-Object { $_.GetOwner().User -eq $User } | select ProcessName)

        if($PName){
            Write-Host "These are the Processes running on $ComputerName for $User" -ForegroundColor Cyan

            Get-WmiObject -Class Win32_Process -ComputerName $ComputerName | 
                Where-Object { $_.GetOwner().User -eq $User} | select ProcessName | Sort-Object ProcessName

        }
        else{
            Write-Host "There are no processes running for $User on $ComputerName. The user may not be logged in." -ForegroundColor DarkCyan
        }

    }
    End
    {
    }
}