THEOS_DEVICE_IP = iphone5c
TARGET = iphone:7.0:7.0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = mailhelper
mailhelper_FILES = Tweak.xm
mailhelper_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileMail"
