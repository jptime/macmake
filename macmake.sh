#!/bin/sh

#-------------------------------------------------------------------------#
# Script to Dynamically create xml files based on requests to TFTP server #
#-------------------------------------------------------------------------#
#                          Written by John Petty
#                 Tested with Spectralink IP Dect 400


#Please modify this file based on your directory structure and the ending 
#of the tftp requests made by the device.  
#In this example, the IP Dect 400 server requests a MAC-config.xml.


#Below File will need to be changed to the file that has the logs#

cat /home/macmake/testlogs | grep in.tftpd | egrep --line-buffered 'config.xml' >  maclog.txt

#The above step will search in the messages log for tftpd requests 
#and pull the whole line that ends with config.xml.  
#This is what all lines end with when the DECT Server requests them.
#These lines are then written to maclog.txt in the same directory

#The next step is to parse the maclog.txt file we just wrote to.
#This remove all the beginning info from the lines in maclog.txt.  
#Gives us only the info we want MAC-config.xml. Puts this info into dectmacs.txt
cat maclog.txt | sed -n -r 's/.*(0013d1[a-zA-Z0-9]{6}-config\.xml).*/\1/p' > dectmacs.txt

#In the case the device made multiple attempts to connect,
#this will remove any duplicate entries 
MAC=`awk 'seen[$0]++ == 1' dectmacs.txt`
echo "$MAC" > dectmacs.txt

#Next we take the filename it requested and copy the 
#dectconfig file to the configs folder and then to the tftp boot
#The first copy would be if you have the provisioning files in a different location. 
#
#The second copy is changing the file name of that copied config file to the mac-config.xml
cp -a /home/macmake/dectconfig.xml /home/macmake/configs/
mv /home/macmake/configs/dectconfig.xml "/home/macmake/configs/$MAC"

#next step will be to create this as an IF loop
