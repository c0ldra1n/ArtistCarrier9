include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ArtistCarrier9
ArtistCarrier9_FILES = Tweak.xm ACDataServer.m
SHARED_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += artistcarrier9
include $(THEOS_MAKE_PATH)/aggregate.mk
