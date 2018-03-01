filenamevar1="strg001.out.2018_March_01"
errStr=""

if [ -f "/home/ec2-user/OptGeoData/2018/March/01/$filenamevar1*" ]; then
        reportErr=true
        errStr+=" "$filenamevar1
fi

echo $errStr
