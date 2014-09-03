# The script is used to re-sign apk with keystore
# 1. should install java-sdk and export /bin/ to $PATH 
# 2. should has keystore in toolkit folder

apk_name=$1

if [ -z ${apk_name} ]; then
	echo "Miss apk name to be resigned!"
	exit
fi

if [ ! -f "${apk_name}.apk" ];then
	echo "${apk_name}.apk not exist" 
	exit
fi
# unpack apk which needs to be resigned
echo""
echo "unpacking ${apk_name}.apk......"
apktool d -f "${apk_name}.apk" ./out 

# re-pack to unsigned apk
echo""
echo "re-build ${apk_name}.apk......"
apktool b -f ./out temp.apk

# resign temp.apk 
echo ""
echo "resign ${apk_name}.apk......"
jarsigner -verbose -keystore keystore -keypass skymobi -storepass skymobi -signedjar "resigned-${apk_name}".apk temp.apk skymobi

# remove temp files
rm -rf ./out
rm -rf temp.apk
echo ""
echo "All Done"
