/*
 * SettingsModel.cpp
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
 *  Created on: 24 août 2015
 *      Author: Sylvain Berfini
 */

#include "SettingsModel.h"

SettingsModel::SettingsModel(QObject *parent)
    : QObject(parent),
      _manager(LinphoneManager::getInstance()),
      _isSrtpSupported(false),
      _isZrtpSupported(false),
      _isDtlsSupported(false)
{
    LinphoneCore *lc = _manager->getLc();
    if (lc) {
        _isSrtpSupported = linphone_core_media_encryption_supported(lc, LinphoneMediaEncryptionSRTP);
        _isZrtpSupported = linphone_core_media_encryption_supported(lc, LinphoneMediaEncryptionZRTP);
        _isDtlsSupported = linphone_core_media_encryption_supported(lc, LinphoneMediaEncryptionDTLS);
        emit settingsUpdated();
    }
}

bool SettingsModel::debugEnabled() const {
    LpConfig *lpc = linphone_core_get_config(_manager->getLc());
    return lp_config_get_int(lpc, "app", "debug", 0) == 1;
}

void SettingsModel::setDebugEnabled(const bool& enabled) {
    OrtpLogLevel logLevel = static_cast<OrtpLogLevel>(ORTP_LOGLEV_END);
    if (enabled) {
        logLevel = static_cast<OrtpLogLevel>(ORTP_MESSAGE | ORTP_WARNING | ORTP_FATAL | ORTP_ERROR);
    }
    linphone_core_set_log_level_mask(logLevel);

    LpConfig *lpc = linphone_core_get_config(_manager->getLc());
    lp_config_set_int(lpc, "app", "debug", enabled ? 1 : 0);
    lp_config_sync(lpc);
}

bool SettingsModel::videoSupported() const {
    return linphone_core_video_supported(_manager->getLc());
}

bool SettingsModel::videoEnabled() const {
    return linphone_core_video_enabled(_manager->getLc());
}

void SettingsModel::setVideoEnabled(const bool& enabled) {
    linphone_core_enable_video(_manager->getLc(), enabled, enabled);
}

bool SettingsModel::previewVisible() const {
    return linphone_core_video_preview_enabled(_manager->getLc());
}

void SettingsModel::setPreviewVisible(const bool& visible) {
    linphone_core_enable_video_preview(_manager->getLc(), visible);
}

int SettingsModel::preferredVideoSizeIndex() const {
    const char *videoSize = linphone_core_get_preferred_video_size_name(_manager->getLc());

    if (strcmp(videoSize, "720p") == 0) {
        return 0;
    } else if (strcmp(videoSize, "vga") == 0) {
        return 1;
    } else if (strcmp(videoSize, "cif") == 0) {
        return 2;
    } else if (strcmp(videoSize, "qvga") == 0) {
        return 3;
    } else if (strcmp(videoSize, "qcif") == 0) {
        return 4;
    }
    return -1;
}

void SettingsModel::setPreferredVideoSize(const QString& videoSize) {
    linphone_core_set_preferred_video_size_by_name(_manager->getLc(), videoSize.toLower().toUtf8().constData());
}

int SettingsModel::mediaEncryption() const {
    return (int)linphone_core_get_media_encryption(_manager->getLc());
}

void SettingsModel::setMediaEncryption(const int& mediaEncryption) {
    linphone_core_set_media_encryption(_manager->getLc(), (LinphoneMediaEncryption)mediaEncryption);
}

bool SettingsModel::mediaEncryptionMandatory() const {
    return linphone_core_is_media_encryption_mandatory(_manager->getLc());
}

void SettingsModel::setMediaEncryptionMandatory(const bool& enabled) {
    linphone_core_set_media_encryption_mandatory(_manager->getLc(), enabled);
}

QString SettingsModel::stunServer() const {
    return linphone_core_get_stun_server(_manager->getLc());
}

void SettingsModel::setStunServer(const QString& stunServer) {
    linphone_core_set_stun_server(_manager->getLc(), stunServer.toUtf8().constData());
}

bool SettingsModel::iceEnabled() const {
    return linphone_core_get_firewall_policy(_manager->getLc()) == LinphonePolicyUseIce;
}

void SettingsModel::setIceEnabled(const bool& enabled) {
    LinphoneFirewallPolicy policy = LinphonePolicyNoFirewall;
    if (enabled) {
        policy = LinphonePolicyUseIce;
    } else {
        if (stunServer().isEmpty()) {
            policy = LinphonePolicyNoFirewall;
        } else {
            policy = LinphonePolicyUseStun;
        }
    }
    linphone_core_set_firewall_policy(_manager->getLc(), policy);
}
