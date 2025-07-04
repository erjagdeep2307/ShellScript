# Dated : June 12,2025
# Author: Jagdeep Singh
########################################################################################################
DATE="`date '+%d%m%Y'`"
signature="[$(date '+%d%m%Y %H:%M:%S')]"
IPCONF="`pwd`/ip.conf"
ExpectBinary="`pwd`/login.exp"
CreateInputBinary="`pwd`/createInputFile.sh"
LOG_FILE=`pwd`/log/$(date +"%Y-%m-%d_%H-%M").log 
NEWDATA_FILE=`pwd`/newData.txt
CREATCSV_BINARY=`pwd`/fileReader.php

signalHandler()
{	
	echo  "Intrupted by User , Going to exiting from Runme Script.."  #>> ${LOG_FILE}
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
	 	 expect ${ExpectBinary} $ip $user $pass   >> ${LOG_FILE} 
		 if [[ $? -ne 0 ]]
		 then
		 	echo $signature "Checkup Failed on Server:$server with IP : $ip "  >> ${LOG_FILE}
		 	continue	
		 fi
		echo $signature "Checkup Done on $server  :   $ip " >> ${LOG_FILE}
done < $IPCONF

bash ${CreateInputBinary} ${LOG_FILE} > ${NEWDATA_FILE}

sleep 1

php ${CREATCSV_BINARY}
