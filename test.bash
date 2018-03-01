filenamevar1="strg001.out.2018_March_01"
errStr=""

ls -l /home/ec2-user/OptGeoData/2018/March/01/$filenamevar1*77 > /dev/null 2>&1

if [ ! "$?" = "0" ]; then
        reportErr=true
        errStr+=" "$filenamevar1
fi

echo $errStr


