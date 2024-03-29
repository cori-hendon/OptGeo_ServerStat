#!/bin/bash
# this should run once every 10 mins to organize files uploaded to ftp and update the git repo

# echo to all.log a date stamp
echo $(date) >> /mnt/ftp/httpd/customers/optimalgeo/all.log

# move old stuff to directories for storage
yr=$(TZ=US/Central date +%Y)
mo=$(TZ=US/Central date +%B)
da=$(TZ=US/Central date +%d)
hr=$(TZ=US/Central date +%H)
# adjust day for time zone difference
#if [ $hr = "00" ]	
#then
#	da=$(($da - 1))
#	hr="23"
#fi
pathvar=$yr/$mo/$da
filenamevar1=strg001.out.${yr}_${mo}_${da}
filenamevar2=strg002.out.${yr}_${mo}_${da}
filenamevar3=strg003.out.${yr}_${mo}_${da}
filenamevar4=strg004.out.${yr}_${mo}_${da}


reportErr=false
errStr=''
mkdir -p /home/ec2-user/OptGeoData/$pathvar

ls -l /home/ec2-user/$filenamevar1* > /dev/null 2>&1
if [ ! "$?" = "0" ]; then
	reportErr=true
	errStr+=" "$filenamevar1
fi

ls -l /home/ec2-user/$filenamevar2* > /dev/null 2>&1
if [ ! "$?" = "0" ]; then
        reportErr=true
        errStr+=" "$filenamevar2
fi

ls -l /home/ec2-user/$filenamevar3* > /dev/null 2>&1
if [ ! "$?" = "0" ]; then
        reportErr=true
        errStr+=" "$filenamevar3
fi

ls -l /home/ec2-user/$filenamevar4* > /dev/null 2>&1
if [ ! "$?" = "0" ]; then
        reportErr=true
        errStr+=" "$filenamevar4
fi

mv /home/ec2-user/$filenamevar1* /home/ec2-user/OptGeoData/$pathvar/.
mv /home/ec2-user/$filenamevar2* /home/ec2-user/OptGeoData/$pathvar/.
mv /home/ec2-user/$filenamevar3* /home/ec2-user/OptGeoData/$pathvar/.
mv /home/ec2-user/$filenamevar4* /home/ec2-user/OptGeoData/$pathvar/.

if $reportErr ; then
	echo $(date) >> /mnt/ftp/httpd/customers/optimalgeo/err.log
	echo "Missing files:" >> /mnt/ftp/httpd/customers/optimalgeo/err.log
	echo $errStr >> /mnt/ftp/httpd/customers/optimalgeo/err.log
	echo '-----------------------------------------------------' >> /mnt/ftp/httpd/customers/optimalgeo/err.log
fi




# make a copy of the newest files for easy reference naming
newfile1=$(ls -ltr /home/ec2-user/OptGeoData/$pathvar/ | grep strg001 | tail -1 | awk '{print $9}')
rm -f /mnt/ftp/httpd/customers/optimalgeo/newest1.data
cp /home/ec2-user/OptGeoData/$pathvar/$newfile1 /mnt/ftp/httpd/customers/optimalgeo/newest1.data

newfile2=$(ls -ltr /home/ec2-user/OptGeoData/$pathvar/ | grep strg002 | tail -1 | awk '{print $9}')
rm -f /mnt/ftp/httpd/customers/optimalgeo/newest2.data
cp /home/ec2-user/OptGeoData/$pathvar/$newfile2 /mnt/ftp/httpd/customers/optimalgeo/newest2.data

newfile3=$(ls -ltr /home/ec2-user/OptGeoData/$pathvar/ | grep strg003 | tail -1 | awk '{print $9}')
rm -f /mnt/ftp/httpd/customers/optimalgeo/newest3.data
cp /home/ec2-user/OptGeoData/$pathvar/$newfile3 /mnt/ftp/httpd/customers/optimalgeo/newest3.data

newfile4=$(ls -ltr /home/ec2-user/OptGeoData/$pathvar/ | grep strg004 | tail -1 | awk '{print $9}')
rm -f /mnt/ftp/httpd/customers/optimalgeo/newest4.data
cp /home/ec2-user/OptGeoData/$pathvar/$newfile4 /mnt/ftp/httpd/customers/optimalgeo/newest4.data



# parse the newest files
rm /mnt/ftp/httpd/customers/optimalgeo/newest1_parsed.data
rm /mnt/ftp/httpd/customers/optimalgeo/newest2_parsed.data
rm /mnt/ftp/httpd/customers/optimalgeo/newest3_parsed.data
rm /mnt/ftp/httpd/customers/optimalgeo/newest4_parsed.data

python /mnt/ftp/httpd/customers/optimalgeo/optgeoParser.py /mnt/ftp/httpd/customers/optimalgeo/newest1.data /mnt/ftp/httpd/customers/optimalgeo/strg1Ref.txt > /mnt/ftp/httpd/customers/optimalgeo/newest1_parsed.data
python /mnt/ftp/httpd/customers/optimalgeo/optgeoParser.py /mnt/ftp/httpd/customers/optimalgeo/newest2.data /mnt/ftp/httpd/customers/optimalgeo/strg2Ref.txt > /mnt/ftp/httpd/customers/optimalgeo/newest2_parsed.data
python /mnt/ftp/httpd/customers/optimalgeo/optgeoParser.py /mnt/ftp/httpd/customers/optimalgeo/newest3.data /mnt/ftp/httpd/customers/optimalgeo/strg3Ref.txt > /mnt/ftp/httpd/customers/optimalgeo/newest3_parsed.data
python /mnt/ftp/httpd/customers/optimalgeo/optgeoParser.py /mnt/ftp/httpd/customers/optimalgeo/newest4.data /mnt/ftp/httpd/customers/optimalgeo/strg4Ref.txt > /mnt/ftp/httpd/customers/optimalgeo/newest4_parsed.data


# combine the newest individual files into one newest.data
cat /mnt/ftp/httpd/customers/optimalgeo/newest*parsed.data > /mnt/ftp/httpd/customers/optimalgeo/newest.data




# update github directory
cd /mnt/ftp/httpd/customers/optimalgeo
git add -A &> /dev/null
git commit -am "automated file upload" &> /dev/null
git push origin master &> /dev/null
