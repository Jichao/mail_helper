THEOS_DEVICE_IP = iphone5c
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = mailhelper
mailhelper_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk
