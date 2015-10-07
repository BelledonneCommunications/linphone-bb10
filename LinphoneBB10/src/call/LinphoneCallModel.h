/*
 * LinphoneCallModel.h
 *
 *  Created on: 7 oct. 2015
 *      Author: viish_dsre1h1
 */

#ifndef LINPHONECALLMODEL_H_
#define LINPHONECALLMODEL_H_

#include <QObject>

#include "linphone/linphonecore.h"

class LinphoneCallModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString displayName READ displayName CONSTANT);
    Q_PROPERTY(QString sipUri READ sipUri CONSTANT);
    Q_PROPERTY(QString callTime READ callTime NOTIFY timerTick);
    Q_PROPERTY(QString photo READ photo CONSTANT);

public:
    LinphoneCallModel(QObject *parent = NULL, LinphoneCall *call = NULL, QString sipUri = "", QString displayName = "", QString photo = "");

    QString displayName() const {
        return _displayName;
    }

    QString sipUri() const {
        return _sipUri;
    }

    QString callTime() const {
        return _callTime;
    }

    QString photo() const {
        return _photo;
    }

    LinphoneCall* _call;

public Q_SLOTS:
    void statsUpdated();

Q_SIGNALS:
    void timerTick();

private:
    QString _displayName;
    QString _sipUri;
    QString _callTime;
    QString _photo;
};

#endif /* LINPHONECALLMODEL_H_ */
