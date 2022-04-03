When troubleshooting group policies, do not forget the name resolution (use the command prompt)!
-----------

nslookup domain_name  
(for examples nslookup prime.pri)

ping prime.pri  
(the domain should be resolved with the IP address of a domain controller)

nltest /query  

nltest /sc_query:tomrocks.local

Using GPRESULT to list applied policies (use the command prompt)
-----------

gpresult /s ComputerName /user Domain\UserName /r  
Lists the summary of applied GPOs when the specified user is logged on to the specified computer.

gpresult /s ComputerName /user Domain\UserName /r /scope user  
Lists only user policies in the above report. Computer policies are omitted.

gpresult /s ComputerName /user Domain\UserName /h gpreport.html  
Generates the same report as in the first example, but saves it in an HTML file.

gpresult /s ComputerName /u domain\UserCred /p p@ssW23 /user Domain\UserName /r  
Generates the same report as the first example, but uses the specified credentials to run the command.

gpresult /s ComputerName /user Domain\UserName /z > policy.txt  
Generates a very detailed report with user and computer policy settings and saves it to a text file.


Resetting the Default Domain Policy and/or the Default Domain Controller Policy (use the command prompt)
---------

dcgpofix /target:Domain  
to reset the domain GPO.

dcgpofix /target:DC  
to reset the default DC GPO.

dcgpofix /target:both  
to reset the domain and default DC GPOs.


Although not widely used, problems can occur if you have edited a computer's local security policy. This policy can also be reset to default settings with the following steps:

    Log in to an account with local administrator privileges on the computer in question.

    Click Start, Run, and then type cmd at the command prompt. Then press Enter to start a command session.

    Type secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbose to reset the local security policy.


How to check if domain controllers are in sync with each other (use the command prompt)?
----------

Step 1 - Check the replication health

Repadmin /replsummary

Step 2 - Check the inbound replication requests that are queued.

Repadmin /Queue

Step 3 - Check the replication status

Repadmin /Showrepl

Step 4 - Synchronize replication between replication partners

Repadmin /syncall

Step 5 - Force the KCC to recalculate the topology

Repadmin /KCC

Step 6 - Force replication

Repadmin /replicate
