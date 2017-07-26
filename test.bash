var=newest1a
errvar=false
ls $var* || errvar=true; errstr+=$var

if $errvar ; then
	echo $(date)
	echo $errstr
fi
