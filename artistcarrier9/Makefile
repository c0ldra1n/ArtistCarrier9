include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ArtistCarrier9
ArtistCarrier9_FILES = ACRootListController.m PFHeaderCell.mm
ArtistCarrier9_INSTALL_PATH = /Library/PreferenceBundles
ArtistCarrier9_FRAMEWORKS = UIKit
ArtistCarrier9_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ArtistCarrier9.plist$(ECHO_END)
