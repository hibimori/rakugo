rem Tomcat7 reboot

set service_name=Tomcat7
net stop %service_name%
net start %service_name%