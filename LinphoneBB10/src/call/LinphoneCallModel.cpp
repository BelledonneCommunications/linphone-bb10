/*
 * LinphoneCallModel.cpp
 *
 *  Created on: 7 oct. 2015
 *      Author: viish_dsre1h1
 */

#include "src/utils/Misc.h"
#include "LinphoneCallModel.h"

LinphoneCallModel::LinphoneCallModel(QObject *parent, LinphoneCall *call, QString sipUri, QString displayName, QString photo)
    : QObject(parent),
      _call(call),
      _displayName(displayName),
      _sipUri(sipUri),
      _callTime(""),
      _photo(photo)
{
    bool result = QObject::connect(parent, SIGNAL(statsUpdated()), this, SLOT(statsUpdated()));
    Q_ASSERT(result);
}

void LinphoneCallModel::statsUpdated() {
    if (_call) {
        int duration = linphone_call_get_duration(_call);
        _callTime = FormatCallDuration(duration);
        emit timerTick();
    }
}
