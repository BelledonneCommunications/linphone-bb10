/*
 * InCallModel.h
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
 *  Created on: 19 mars 2015
 *      Author: Sylvain Berfini
 */

#ifndef INCALLMODEL_H_
#define INCALLMODEL_H_

#include <QObject>
#include <QTimer>
#include <screen/screen.h>
#include <bb/cascades/UIOrientation>
#include <bb/cascades/DisplayDirection>
#include <QSize>

#include "CallStatsModel.h"
#include "linphone/linphonecore.h"

class InCallModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString displayName READ displayName NOTIFY callUpdated);
    Q_PROPERTY(QString sipUri READ sipUri NOTIFY callUpdated);
    Q_PROPERTY(QString callTime READ callTime NOTIFY statsUpdated);
    Q_PROPERTY(QString photo READ photo NOTIFY callUpdated);
    Q_PROPERTY(bool isInCall READ isInCall NOTIFY callUpdated);
    Q_PROPERTY(bool isVideoEnabled READ isVideoEnabled WRITE setVideoEnabled NOTIFY callUpdated);
    Q_PROPERTY(bool isMicMuted READ isMicMuted WRITE setMicMuted NOTIFY callUpdated);
    Q_PROPERTY(bool isSpeakerEnabled READ isSpeakerEnabled WRITE setSpeakerEnabled NOTIFY callUpdated);
    Q_PROPERTY(bool isPaused READ isPaused NOTIFY callUpdated);
    Q_PROPERTY(bool areControlsVisible READ areControlsVisible NOTIFY fadeControlsUpdated);
    Q_PROPERTY(int deviceOrientation READ deviceOrientation NOTIFY deviceOrientationChanged);
    Q_PROPERTY(QSize previewSize READ previewSize NOTIFY statsUpdated);
    Q_PROPERTY(CallStatsModel* callStatsModel READ callStatsModel CONSTANT);

public:
    InCallModel(QObject *parent = NULL);

public Q_SLOTS:
    void onVideoSurfaceCreationCompleted(QString id, QString group);
    void callStateChanged(LinphoneCall *call);
    void statsTimerTimeout();
    void fadeTimerTimeout();
    void resetFadeTimer();
    void switchFullScreenMode();
    void accept();
    void hangUp();
    void switchCamera();
    void togglePause();
    void onOrientationAboutToChange(bb::cascades::DisplayDirection::Type, bb::cascades::UIOrientation::Type uiOrientation);
    void updateZRTPTokenValidation(bool isTokenOk);

Q_SIGNALS:
    void callUpdated();
    void statsUpdated();
    void fadeControlsUpdated();
    void deviceOrientationChanged();

private:
    const char *window_id;
    const char *window_group;

    CallStatsModel *callStatsModel() const {
        return _callStatsModel;
    }
    CallStatsModel *_callStatsModel;

    QString displayName() const {
        return _displayName;
    }
    QString _displayName;

    QString sipUri() const {
        return _sipUri;
    }
    QString _sipUri;

    QString callTime() const {
        return _callTime;
    }
    QString _callTime;

    QString photo() const {
        return _photo;
    }
    QString _photo;

    bool isInCall() const;

    bool isVideoEnabled() const {
        return _isVideoEnabled;
    }
    void setVideoEnabled(const bool &enabled);
    bool _isVideoEnabled;

    bool isMicMuted() const {
        return _isMicMuted;
    }
    void setMicMuted(const bool &muted);
    bool _isMicMuted;

    bool isSpeakerEnabled() const {
        return _isSpeakerEnabled;
    }
    void setSpeakerEnabled(const bool &enabled);
    bool _isSpeakerEnabled;

    bool isPaused() const {
        return _isPaused;
    }
    bool _isPaused;

    bool areControlsVisible() const {
       return _areControlsVisible;
   }
   bool _areControlsVisible;

    QTimer *_statsTimer;
    QTimer *_controlsFadeTimer;

    int deviceOrientation() const {
        return _deviceOrientation;
    }
    int _deviceOrientation;

    QSize previewSize() const {
        return _previewSize;
    }
    QSize _previewSize;
};

#endif /* INCALLMODEL_H_ */
