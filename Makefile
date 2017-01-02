THEOS_DEVICE_IP = iphone5c
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = mailhelper
mailhelper_FILES = \
		Tweak.xm \
		FilterViewController.m \
		Masonry/MASCompositeConstraint.m \
		Masonry/MASViewConstraint.m \
		Masonry/MASConstraint.m \
		Masonry/NSArray+MASAdditions.m\
		Masonry/MASConstraintMaker.m\
		Masonry/NSLayoutConstraint+MASDebugAdditions.m\
		Masonry/MASLayoutConstraint.m\
		Masonry/View+MASAdditions.m\
		Masonry/MASViewAttribute.m\
		Masonry/ViewController+MASAdditions.m
mailhelper_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = mailhelper_res
mailhelper_res_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
include $(THEOS)/makefiles/bundle.mk

after-install::
	install.exec "killall -9 MobileMail"
