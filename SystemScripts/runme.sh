#!/usr/bin/bash
# Dated : June 12,2025
# Author: Jagdeep Singh
########################################################################################################
DATE="`date '+%d%m%Y'`"
signature="[$(date '+%d%m%Y %H:%M:%S')]"
BASE_PATH="/home/jagdeep/workshop/ShellScript/SystemScripts";
IPCONF="${BASE_PATH}/ip.conf"
ExpectBinary="${BASE_PATH}/login.exp"
CreateInputBinary="${BASE_PATH}/createInputFile.sh"
LOG_FILE="${BASE_PATH}/log/$(date '+%Y-%m-%d_%H-%M').log" 
NEWDATA_FILE="${BASE_PATH}/newData.txt"
CREATCSV_BINARY="${BASE_PATH}/fileReader.php"

signalHandler()
{	
	echo  $signature "Intrupted by User , Going to exiting from Runme Script.."  >> ${LOG_FILE}
	exit
}


trap signalHandler 2 ;
while IFS=':' read ip server user pass
do
	if echo $ip | grep -q ^#
	then
		#echo -e "\n Commeneted Line \n" >> ${LOG_FILE}
		continue;
	fi
	 	 expect ${ExpectBinary} $ip $user $pass     >> ${LOG_FILE} 
		 if [[ $? -ne 0 ]]
		 then
		 	echo $signature "Checkup Failed on Server:$server with IP : $ip "  >> ${LOG_FILE}
		 	continue	
		 fi
		#echo $signature "Checkup Done on $server  :  $ip"   >> ${LOG_FILE}
done < $IPCONF

bash ${CreateInputBinary} ${LOG_FILE}  > ${NEWDATA_FILE}

if [ -e "${NEWDATA_FILE}" ]; then
	/usr/bin/php ${CREATCSV_BINARY}
	echo $signature "CSV Created Successfully"
else

	echo $signature "NewData File does'nt Exist"
fi
