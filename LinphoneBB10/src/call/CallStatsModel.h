/*
 * CallStatsModel.h
 * Copyright (C) 2015  Belledonne Communications, Grenoble, France
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 *  Created on: 19 août 2015
 *      Author: Sylvain Berfini
 */

#ifndef CALLSTATSMODEL_H_
#define CALLSTATSMODEL_H_

#include <QObject>

#include "linphone/linphonecore.h"

class CallStatsModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString callQualityIcon READ callQualityIcon NOTIFY statsUpdated);
    Q_PROPERTY(QString callSecurityIcon READ callSecurityIcon NOTIFY statsUpdated);
    Q_PROPERTY(QString audioCodec READ audioCodec NOTIFY statsUpdated);
    Q_PROPERTY(QString videoCodec READ videoCodec NOTIFY statsUpdated);
    Q_PROPERTY(QString downloadAudioBandwidth READ downloadAudioBandwidth NOTIFY statsUpdated);
    Q_PROPERTY(QString downloadVideoBandwidth READ downloadVideoBandwidth NOTIFY statsUpdated);
    Q_PROPERTY(QString uploadAudioBandwidth READ uploadAudioBandwidth NOTIFY statsUpdated);
    Q_PROPERTY(QString uploadVideoBandwidth READ uploadVideoBandwidth NOTIFY statsUpdated);
    Q_PROPERTY(QString iceStatus READ iceStatus NOTIFY statsUpdated);
    Q_PROPERTY(QString sentVideoSize READ sentVideoSize NOTIFY statsUpdated);
    Q_PROPERTY(QString receivedVideoSize READ receivedVideoSize NOTIFY statsUpdated);

public:
    CallStatsModel(QObject *parent = NULL);
    void updateStats(LinphoneCall *call);

Q_SIGNALS:
    void statsUpdated();

private:
    QString callQualityIcon() const {
        return _currentCallQualityIcon;
    }
    QString _currentCallQualityIcon;

    QString callSecurityIcon() const {
        return _currentCallSecurityIcon;
    }
    QString _currentCallSecurityIcon;

    QString audioCodec() const {
        return _audioCodec;
    }
    QString _audioCodec;

    QString videoCodec() const {
        return _videoCodec;
    }
    QString _videoCodec;

    QString downloadAudioBandwidth() const {
        return _downloadAudioBandwidth;
    }
    QString _downloadAudioBandwidth;

    QString downloadVideoBandwidth() const {
        return _downloadVideoBandwidth;
    }
    QString _downloadVideoBandwidth;

    QString uploadAudioBandwidth() const {
        return _uploadAudioBandwidth;
    }
    QString _uploadAudioBandwidth;

    QString uploadVideoBandwidth() const {
        return _uploadVideoBandwidth;
    }
    QString _uploadVideoBandwidth;

    QString iceStatus() const {
        return _iceStatus;
    }
    QString _iceStatus;

    QString sentVideoSize() const {
        return _sentVideoSize;
    }
    QString _sentVideoSize;

    QString receivedVideoSize() const {
        return _receivedVideoSize;
    }
    QString _receivedVideoSize;
};

#endif /* CALLSTATSMODEL_H_ */
