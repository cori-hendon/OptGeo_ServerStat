filenamevar1="2018_March_01"
errStr=""

if [ ! -f /home/ec2-user/$filenamevar1* ]; then
        reportErr=true
        errStr+=" "$filenamevar1
fi

echo $errStr
