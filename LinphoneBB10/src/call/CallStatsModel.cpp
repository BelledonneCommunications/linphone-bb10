/*
 * CallStatsModel.cpp
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

#include "CallStatsModel.h"
#include "src/utils/Misc.h"

CallStatsModel::CallStatsModel(QObject *parent)
    : QObject(parent),
    _currentCallQualityIcon(""),
    _currentCallSecurityIcon(""),
    _callSecurityToken(""),
    _audioCodec(""),
    _videoCodec(""),
    _downloadAudioBandwidth(""),
    _downloadVideoBandwidth(""),
    _uploadAudioBandwidth(""),
    _uploadVideoBandwidth(""),
    _iceStatus(""),
    _sentVideoSize(""),
    _receivedVideoSize("")
{

}

void CallStatsModel::updateStats(LinphoneCall *call)
{
    if (!call) {
        return;
    }

    float quality = linphone_call_get_current_quality(call);
    if (quality >= 4) {
        _currentCallQualityIcon = "/images/statusbar/call_quality_indicator_4.png";
    } else if (quality >= 3) {
        _currentCallQualityIcon = "/images/statusbar/call_quality_indicator_3.png";
    } else if (quality >= 2) {
        _currentCallQualityIcon = "/images/statusbar/call_quality_indicator_2.png";
    } else if (quality >= 1) {
        _currentCallQualityIcon = "/images/statusbar/call_quality_indicator_1.png";
    } else {
        _currentCallQualityIcon = "/images/statusbar/call_quality_indicator_0.png";
    }

    const LinphoneCallParams *params = linphone_call_get_current_params(call);
    if (!params) {
        return;
    }

    LinphoneMediaEncryption encryption = linphone_call_params_get_media_encryption(params);
    _currentCallSecurityIcon = "/images/statusbar/security_ko.png";
    if (encryption == LinphoneMediaEncryptionSRTP || encryption == LinphoneMediaEncryptionDTLS) {
        _currentCallSecurityIcon = "/images/statusbar/security_ok.png";
    } else if (encryption == LinphoneMediaEncryptionZRTP) {
        _callSecurityToken = tr("ZRTP token is %1.\r\nYou should only accept if you have the same token as your correspondent.").arg(linphone_call_get_authentication_token(call));
        bool isAuthTokenVerified = linphone_call_get_authentication_token_verified(call);
        if (isAuthTokenVerified) {
            _currentCallSecurityIcon = "/images/statusbar/security_ok.png";
        } else {
            _currentCallSecurityIcon = "/images/statusbar/security_pending.png";
        }
    }

    const LinphoneCallStats *audioStats = linphone_call_get_audio_stats(call);
    if (audioStats) {
        _iceStatus = IceStateToString(linphone_call_stats_get_ice_state(audioStats));
        _downloadAudioBandwidth = QString("<html>&#x2193; %1 kbits/s</html>").arg(QString::number((int)linphone_call_stats_get_download_bandwidth(audioStats), 10));
        _uploadAudioBandwidth = QString("<html>&#x2191; %1 kbits/s</html>").arg(QString::number((int)linphone_call_stats_get_upload_bandwidth(audioStats), 10));
    }

    const LinphonePayloadType *audioPayload = linphone_call_params_get_used_audio_codec(params);
    if (audioPayload) {
        _audioCodec = QString(linphone_payload_type_get_mime_type(audioPayload)) + "/" +  QString::number(linphone_payload_type_get_normal_bitrate(audioPayload), 10) + "/" + QString::number(linphone_payload_type_get_channels(audioPayload), 10);
    }

    if (linphone_call_params_video_enabled(params)) {
        const LinphoneCallStats *videoStats = linphone_call_get_video_stats(call);
        if (videoStats) {
            _downloadVideoBandwidth = QString("<html>&#x2193; %1 kbits/s</html>").arg(QString::number((int)linphone_call_stats_get_download_bandwidth(videoStats), 10));
            _uploadVideoBandwidth = QString("<html>&#x2191; %1 kbits/s</html>").arg(QString::number((int)linphone_call_stats_get_upload_bandwidth(videoStats), 10));
        }

        const LinphonePayloadType *videoPayload = linphone_call_params_get_used_video_codec(params);
        if (videoPayload) {
            _videoCodec = QString(linphone_payload_type_get_mime_type(videoPayload));
        }

        MSVideoSize sentVideoSize = linphone_call_params_get_sent_video_size(params);
        float framerate = linphone_call_params_get_sent_framerate(params);
        _sentVideoSize = QString("%1x%2 @ %3 fps").arg(QString::number(sentVideoSize.width, 10), QString::number(sentVideoSize.height, 10), QString::number((int)framerate, 10));

        MSVideoSize receivedVideoSize = linphone_call_params_get_received_video_size(params);
        framerate = linphone_call_params_get_received_framerate(params);
        _receivedVideoSize = QString("%1x%2 @ %3 fps").arg(QString::number(receivedVideoSize.width, 10), QString::number(receivedVideoSize.height, 10), QString::number((int)framerate, 10));
    }

    emit statsUpdated();
}
