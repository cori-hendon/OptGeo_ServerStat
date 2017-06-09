#!/bin/bash
# this should run once every 10 mins to organize files uploaded to ftp and update the git repo


# move old stuff to directories for storage
yr=$(date +%Y)
mo=$(date +%B)
da=$(date +%d)
hr=$(date +%H)
# adjust day for time zone difference
if [ $hr = "00" ]	
then
	da=$(($da - 1))
	hr="23"
fi
pathvar=$yr/$mo/$da
filenamevar1=strg001.out.${yr}_${mo}_${da}
filenamevar2=strg002.out.${yr}_${mo}_${da}
filenamevar3=strg003.out.${yr}_${mo}_${da}
filenamevar4=strg004.out.${yr}_${mo}_${da}

mkdir -p /home/ec2-user/OptGeoData/$pathvar
mv /home/ec2-user/$filenamevar1* /home/ec2-user/OptGeoData/$pathvar/.
mv /home/ec2-user/$filenamevar2* /home/ec2-user/OptGeoData/$pathvar/.
mv /home/ec2-user/$filenamevar3* /home/ec2-user/OptGeoData/$pathvar/.
mv /home/ec2-user/$filenamevar4* /home/ec2-user/OptGeoData/$pathvar/.




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
rm newest_parsed1.data
rm newest_parsed2.data
rm newest_parsed3.data
rm newest_parsed4.data

python /mnt/ftp/httpd/customers/optimalgeo/optgeoParser.py /mnt/ftp/httpd/customers/optimalgeo/newest1.data /mnt/ftp/httpd/customers/optimalgeo/strg1Ref.txt > /mnt/ftp/httpd/customers/optimalgeo/newest1_parsed.data
python /mnt/ftp/httpd/customers/optimalgeo/optgeoParser.py /mnt/ftp/httpd/customers/optimalgeo/newest2.data /mnt/ftp/httpd/customers/optimalgeo/strg2Ref.txt > /mnt/ftp/httpd/customers/optimalgeo/newest2_parsed.data
python /mnt/ftp/httpd/customers/optimalgeo/optgeoParser.py /mnt/ftp/httpd/customers/optimalgeo/newest3.data /mnt/ftp/httpd/customers/optimalgeo/strg3Ref.txt > /mnt/ftp/httpd/customers/optimalgeo/newest3_parsed.data
python /mnt/ftp/httpd/customers/optimalgeo/optgeoParser.py /mnt/ftp/httpd/customers/optimalgeo/newest4.data /mnt/ftp/httpd/customers/optimalgeo/strg4Ref.txt > /mnt/ftp/httpd/customers/optimalgeo/newest4_parsed.data


# combine the newest individual files into one newest.data
cat /mnt/ftp/httpd/customers/optimalgeo/newest*parsed.data > /mnt/ftp/httpd/customers/optimalgeo/newest.data




# update github directory
cd /mnt/ftp/httpd/customers/optimalgeo
git add -A
git commit -am "automated file upload"
git push origin master
