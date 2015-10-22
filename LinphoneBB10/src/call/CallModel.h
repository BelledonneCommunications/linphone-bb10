/*
 * CallModel.h
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

#ifndef CALLMODEL_H_
#define CALLMODEL_H_

#include <QObject>
#include <QTimer>
#include <QSize>
#include <screen/screen.h>
#include <bb/cascades/UIOrientation>
#include <bb/cascades/DisplayDirection>
#include <bb/cascades/GroupDataModel>

#include "CallStatsModel.h"
#include "LinphoneCallModel.h"
#include "linphone/linphonecore.h"

// Needed to be able to use the type in QML
Q_DECLARE_METATYPE(LinphoneCallModel*);

class CallModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bb::cascades::GroupDataModel* pausedCallsDataModel READ pausedCallsDataModel NOTIFY pausedCallsUpdated);
    Q_PROPERTY(LinphoneCallModel* currentCall READ currentCall NOTIFY currentCallChanged);
    Q_PROPERTY(LinphoneCallModel* incomingCall READ incomingCall NOTIFY incomingCallChanged);
    Q_PROPERTY(LinphoneCallModel* outgoingCall READ outgoingCall NOTIFY outgoingCallChanged);

    Q_PROPERTY(bool mediaInProgress READ mediaInProgress NOTIFY mediaInProgressUpdated);
    Q_PROPERTY(bool callUpdatedByRemoteInProgress READ callUpdatedByRemoteInProgress NOTIFY callUpdatedByRemote);
    Q_PROPERTY(bool isInCall READ isInCall NOTIFY callStateChanged);
    Q_PROPERTY(bool isVideoEnabled READ isVideoEnabled WRITE setVideoEnabled NOTIFY callStateChanged);
    Q_PROPERTY(bool videoUpdateInProgress READ videoUpdateInProgress NOTIFY callStateChanged);
    Q_PROPERTY(bool isMicMuted READ isMicMuted WRITE setMicMuted NOTIFY callControlsUpdated);
    Q_PROPERTY(bool isSpeakerEnabled READ isSpeakerEnabled WRITE setSpeakerEnabled NOTIFY callControlsUpdated);
    Q_PROPERTY(bool areControlsVisible READ areControlsVisible NOTIFY fadeControlsUpdated);
    Q_PROPERTY(bool isInConference READ isInConference NOTIFY conferenceUpdated);
    Q_PROPERTY(int runningCallsNotInAnyConferenceCount READ runningCallsNotInAnyConferenceCount NOTIFY callStateChanged);
    Q_PROPERTY(int dialerCallButtonMode READ dialerCallButtonMode WRITE setDialerCallButtonMode NOTIFY nextNewCallActionUpdated);

    Q_PROPERTY(int deviceOrientation READ deviceOrientation NOTIFY deviceOrientationChanged);
    Q_PROPERTY(QSize previewSize READ previewSize NOTIFY statsUpdated);

    Q_PROPERTY(bool isCallTransferAllowed READ isCallTransferAllowed NOTIFY callStateChanged);
    Q_PROPERTY(bool isMultiCallAllowed READ isMultiCallAllowed NOTIFY callStateChanged);
    Q_PROPERTY(bool isConferenceAllowed READ isConferenceAllowed NOTIFY callStateChanged);

    Q_PROPERTY(CallStatsModel* callStatsModel READ callStatsModel CONSTANT);

public:
    CallModel(QObject *parent = NULL);

public Q_SLOTS:
    void callStateChanged(LinphoneCall *call);
    void statsTimerTimeout();
    void acceptCallUpdate(bool accept);
    void acceptCallUpdatedByRemoteTimeout();

    void accept(LinphoneCallModel *callModel);
    void hangUp(LinphoneCallModel *callModel);
    void hangUp();

    void pausedCalls();
    void pauseCurrentCall();
    void resumeCall(const LinphoneCallModel*& callModel);

    void onVideoSurfaceCreationCompleted(QString id, QString group);
    void fadeTimerTimeout();
    void resetFadeTimer();
    void switchFullScreenMode();
    void switchCamera();
    void cameraPreviewAttached(screen_window_t handle);

    void updateZRTPTokenValidation(bool isTokenOk);

    void onOrientationAboutToChange(bb::cascades::DisplayDirection::Type, bb::cascades::UIOrientation::Type uiOrientation);

Q_SIGNALS:
    void currentCallChanged();
    void incomingCallChanged();
    void outgoingCallChanged();
    void callStateChanged();
    void pausedCallsUpdated();
    void conferenceUpdated();
    void mediaInProgressUpdated();
    void callControlsUpdated();
    void statsUpdated();
    void fadeControlsUpdated();
    void deviceOrientationChanged();
    void nextNewCallActionUpdated();
    void callUpdatedByRemote();

private:
    void updateCallTimerInPausedCalls();

    const char *window_id;
    const char *window_group;

    bb::cascades::GroupDataModel* pausedCallsDataModel() const {
        return _pausedCallsDataModel;
    }
    bb::cascades::GroupDataModel* _pausedCallsDataModel;

    CallStatsModel *callStatsModel() const {
        return _callStatsModel;
    }
    CallStatsModel *_callStatsModel;

    LinphoneCallModel* currentCall() const {
        return _currentCall;
    }
    LinphoneCallModel* _currentCall;

    LinphoneCallModel* incomingCall() const {
        return _incomingCall;
    }
    LinphoneCallModel* _incomingCall;

    LinphoneCallModel* outgoingCall() const {
        return _outgoingCall;
    }
    LinphoneCallModel* _outgoingCall;

    bool isInCall() const;

    bool isVideoEnabled() const {
        return _isVideoEnabled;
    }
    void setVideoEnabled(const bool &enabled);
    bool _isVideoEnabled;

    bool videoUpdateInProgress() const {
        return _videoUpdateInProgress;
    }
    bool _videoUpdateInProgress;

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

    bool areControlsVisible() const {
       return _areControlsVisible;
    }
    bool _areControlsVisible;

    QTimer *_statsTimer;
    QTimer *_controlsFadeTimer;
    QTimer *_acceptCallUpdateTimer;

    int dialerCallButtonMode() const {
        return _dialerCallButtonMode;
    }
    void setDialerCallButtonMode(const int& mode) {
        _dialerCallButtonMode = mode;
        emit nextNewCallActionUpdated();
    }
    int _dialerCallButtonMode;

    int deviceOrientation() const {
        return _deviceOrientation;
    }
    int _deviceOrientation;

    QSize previewSize() const {
        return _previewSize;
    }
    QSize _previewSize;

    bool isCallTransferAllowed() const;

    bool isMultiCallAllowed() const;

    bool isConferenceAllowed() const;

    bool isInConference() const;

    int runningCallsNotInAnyConferenceCount() const;

    bool mediaInProgress() const {
       return _mediaInProgress;
    }
    bool _mediaInProgress;

    bool callUpdatedByRemoteInProgress() const {
        return _acceptCallUpdatedByRemoteVisible;
    }
    bool _acceptCallUpdatedByRemoteVisible;
    LinphoneCall *_callUpdatedByRemote;
};

#endif /* CALLMODEL_H_ */
