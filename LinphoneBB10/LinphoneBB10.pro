APP_NAME = LinphoneBB10

CONFIG += qt warn_on cascades10

include(config.pri)

include(linphone.pri)

LIBS += -lbb -lbbsystem -lbbplatform -lbbdevice -lsocket -lslog2 -lasound -laudio_manager -lbbpim -lbbcascadespickers -lscreen -lcamapi -lbps
