crunckWinkDir := ../winkview/bin/res/crunch
crunckzircoDir := ./bin/res/crunch
apk_package := org.zirco

.PHONY:build
build:
# remove crunck directories
ifneq ($(wildcard $(crunckWinkDir)),)
	@echo 'remove '${crunckWinkDir}
	@rm -rf $(crunckWinkDir)
endif
ifneq ($(wildcard $(crunckzircoDir)),)
	@echo 'remove '${crunckzircoDir}
	@rm -rf $(crunckzircoDir)
endif

ifneq ($(wildcard libs),)
	@rm -rf ./libs
endif

	ant debug

# setup the software link for libs/ jni/ obj/
ifneq ($(wildcard ../winkview/jni),)
	@rm -rf ./jni
	ln -s ../winkview/jni jni
endif

ifneq ($(wildcard ../winkview/obj),)
	@rm -rf ./obj
	ln -s ../winkview/obj obj
endif

ifneq ($(wildcard ../winkview/libs),)
	@rm -rf ./libs
	@mkdir ./libs
ifneq ($(wildcard ../winkview/libs/armeabi-v7a/gdb.setup),)
	@mkdir ./libs/armeabi-v7a
	cp ../winkview/libs/armeabi-v7a/gdb.setup ./libs/*
endif
#	@rm -rf ./libs
#	ln -s ../winkview/libs ./libs
endif

###############################################
####  install debug apk
install:
	adb uninstall $(apk_package)
	ant installd
	
###############################################
####  ndk-build native code
ndk-build:
	ndk-build -C ../winkview/jni -j4  NDK_DEBUG=1
	
	
ndk-build-release:
	ndk-build -C ../winkview/jni -j4  
	
###############################################
####  uninstall zirco browser
uninstall:
	adb uninstall $(apk_package)

###############################################
####  setup the ant environment
ant:
	android update lib-project -p ../winkview -t android-19
	android update project -p ./ -t android-19 -n Zirco --subprojects

###############################################
# setup the software link for libs/ jni/ obj/
slink:
ifneq ($(wildcard ../winkview/jni),)
	@rm -rf ./jni
	ln -s ../winkview/jni jni
endif

ifneq ($(wildcard ../winkview/obj),)
	@rm -rf ./obj
	ln -s ../winkview/obj obj
endif

ifneq ($(wildcard ../winkview/libs),)
	@rm -rf ./libs
	@mkdir ./libs
ifneq ($(wildcard ../winkview/libs/armeabi-v7a/gdb.setup),)
	@mkdir ./libs/armeabi-v7a
	cp ../winkview/libs/armeabi-v7a/gdb.setup ./libs/*
endif
#	@rm -rf ./libs
#	ln -s ../winkview/libs ./libs
endif

###############################################
# delete software link for libs/ jni/ obj/
dlink:
ifneq ($(wildcard ../winkview/jni),)
	@rm -rf ./jni
endif

ifneq ($(wildcard ../winkview/obj),)
	@rm -rf ./obj
endif

ifneq ($(wildcard ../winkview/libs),)
	@rm -rf ./libs
endif


###############################################
######## build + install
full:
#-----------------ndk-build-----------------------
	ndk-build -C ../winkview/jni -j4  NDK_DEBUG=1

#---------------- build ----------------------
# remove crunck directories
ifneq ($(wildcard $(crunckWinkDir)),)
	@echo 'remove '${crunckWinkDir}
	@rm -rf $(crunckWinkDir)
endif
ifneq ($(wildcard $(crunckzircoDir)),)
	@echo 'remove '${crunckzircoDir}
	@rm -rf $(crunckzircoDir)
endif

ifneq ($(wildcard libs),)
	@rm -rf ./libs
endif

	ant debug

# setup the software link for libs/ jni/ obj/
ifneq ($(wildcard ../winkview/jni),)
	@rm -rf ./jni
	ln -s ../winkview/jni jni
endif

ifneq ($(wildcard ../winkview/obj),)
	@rm -rf ./obj
	ln -s ../winkview/obj obj
endif

ifneq ($(wildcard ../winkview/libs),)
	@rm -rf ./libs
	@mkdir ./libs
ifneq ($(wildcard ../winkview/libs/armeabi-v7a/gdb.setup),)
	@mkdir ./libs/armeabi-v7a
	cp ../winkview/libs/armeabi-v7a/gdb.setup ./libs/*
endif
#	@rm -rf ./libs
#	ln -s ../winkview/libs ./libs
endif
#----------------- install --------------
	adb uninstall $(apk_package)
	ant installd
###############################################
###############################################
# clean the project includes libs/ jni/ objs/
clean:
	rm -rf ./jni
	rm -rf ./obj
	rm -rf ./libs
	rm -rf ./bin
	rm -rf ../winkview/obj
	rm -rf ../winkview/libs
	rm -rf ../winkview/bin
