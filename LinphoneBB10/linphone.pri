device {
    CONFIG(debug, debug|release) {
        INCLUDEPATH += assets/liblinphone-bb10-sdk/arm/include/
        LIBS += -Bstatic -L$$BASEDIR/../LinphoneBB10/assets/liblinphone-bb10-sdk/arm/lib/ -llinphone -lmediastreamer_voip -lmediastreamer_base -lbellesip -lortp -lbctoolbox -lpolarssl $$BASEDIR/../LinphoneBB10/assets/liblinphone-bb10-sdk/arm/lib/libxml2.a -lsrtp -lbzrtp -lopus -lspeex -lspeexdsp -lgsm -lantlr3c -lvpx -lmatroska2  -Bdynamic -liconv
    }

    CONFIG(release, debug|release) {
        INCLUDEPATH += assets/liblinphone-bb10-sdk/arm/include/
        LIBS += -Bstatic -L$$BASEDIR/../LinphoneBB10/assets/liblinphone-bb10-sdk/arm/lib/ -llinphone -lmediastreamer_voip -lmediastreamer_base -lbellesip -lortp -lbctoolbox -lpolarssl $$BASEDIR/../LinphoneBB10/assets/liblinphone-bb10-sdk/arm/lib/libxml2.a -lsrtp -lbzrtp -lopus -lspeex -lspeexdsp -lgsm -lantlr3c -lvpx -lmatroska2 -Bdynamic -liconv
    }
}

simulator {
    CONFIG(debug, debug|release) {
        INCLUDEPATH += assets/liblinphone-bb10-sdk/i486/include/
        LIBS += -Bstatic -L$$BASEDIR/../LinphoneBB10/assets/liblinphone-bb10-sdk/i486/lib/ -llinphone -lmediastreamer_voip -lmediastreamer_base -lbellesip -lortp -lbctoolbox -lpolarssl $$BASEDIR/../LinphoneBB10/assets/liblinphone-bb10-sdk/i486/lib/libxml2.a -lsrtp -lbzrtp -lopus -lspeex -lspeexdsp -lgsm -lantlr3c -Bdynamic -liconv
    }
}