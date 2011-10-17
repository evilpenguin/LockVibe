export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 2222
include theos/makefiles/common.mk

TWEAK_NAME = LockVibe
LockVibe_FILES = Tweak.xm
LockVibe_FRAMEWORKS = UIKit AudioToolbox
include $(THEOS_MAKE_PATH)/tweak.mk
