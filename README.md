Posh_ManageUserProcesses
========================

This is a quick way to stop a process for a user on a remote machine.

I use it to end a hanging process on a Server 2012 Remote Desktop Services user session since session shadowing is not available (pre R2 release). Since I usually have PowerShell open anyway, this is faster than session shadowing for this kind of task.

Included in this module is also the function Get-ProcessPerUser which checks to see what processes are running for a particular user on a particular remote server. This works best against a RDS host.
