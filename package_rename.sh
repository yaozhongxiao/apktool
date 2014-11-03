#! /bin/bash

# package_rename.sh 修改应用程序包名和应用程序名称
#
# 因为应程序的包名唯一标识一个应用，所以通过该脚本可以使得应用分别独立共存
#

# default package name
packageName=com.alibaba.wireless

# app name on desktop
appName=阿里巴巴winkview

if [ -z $1 ]; then
	echo "missing new package name !"
	echo "will use the default package name : ${packageName}"
	echo "type 'y|Y|yes|Yes' to coninue or 'n|N|no|No' to exit "		
    echo ''
    read options
    case $options in
          y|Y|yes|Yes)
            ;;
           n|N|no|No)
            exit 1
            ;;
    esac
else
	packageName=$1
fi

if [ -z $2 ]; then
	echo "missing new app name !"
	echo "will use the default app name : ${appName}"
	echo "type 'y|Y|yes|Yes' to coninue or 'n|N|no|No' to exit "		
    echo ''
    read options
    case $options in
          y|Y|yes|Yes)
            ;;
           n|N|no|No)
            exit 1
            ;;
    esac
else
	appName=$2
fi

# 1.---------------------------------------------------------------------------------
# replace app name
echo ""
echo "replace app_name in $dir/$file..."
dir=res/values
file=strings.xml
prefix=\<string\\s*name\\s*=\\s*\"app_name\"\\s*\>
postfix=\<\\/string\>
sed -i "s/\($prefix\).*\($postfix\)/\1${appName}\2/g" $dir/$file

# 2.---------------------------------------------------------------------------------
# replace the package name for app as independent app
echo ""
echo "replace package name in $dir/$file..."
dir=.
file=AndroidManifest.xml
prefix=package\\s*=\\s*\"
postfix=\"
sed -i "s/\($prefix\)\S*\($postfix\)/\1${packageName}\2/g" $dir/$file

# 3.---------------------------------------------------------------------------------
#replace the resource reference 
echo ""
echo "replace *.R ..."
prefix=import\\s*
postfix=\\.R\;    # attation ';' should be re-translation as escape character
find -name "*.java" | xargs sed -i "s/\($prefix\)\S*\($postfix\)/\1${packageName}\2/g"

# 4.---------------------------------------------------------------------------------
#option (only needed while self-defined xml namesapce is presented)
#replace xmlns for alibaba
dir=res/layout
echo ""
echo "replace xmlns:alibaba ..."
prefix=xmlns:alibaba=\"http:\\/\\/schemas.android.com\\/apk\\/res\\/
postfix=\"\\s*
find ${dir} -name "*.xml" | xargs sed -i "s/\($prefix\)\S*\($postfix\)/\1${packageName}\2/g"

echo ""
echo "All Done"
