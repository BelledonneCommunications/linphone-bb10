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
      _manager(LinphoneManager::getInstance())
{

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

    emit settingsUpdated();
}

bool SettingsModel::videoEnabled() const {
    return linphone_core_video_enabled(_manager->getLc());
}

void SettingsModel::setVideoEnabled(const bool& enabled) {
    linphone_core_enable_video(_manager->getLc(), enabled, enabled);
}

int SettingsModel::mediaEncryption() const {
    return (int)linphone_core_get_media_encryption(_manager->getLc());
}

void SettingsModel::setMediaEncryption(const int& mediaEncryption) {
    linphone_core_set_media_encryption(_manager->getLc(), (LinphoneMediaEncryption)mediaEncryption);
    emit settingsUpdated();
}

bool SettingsModel::mediaEncryptionMandatory() const {
    return linphone_core_is_media_encryption_mandatory(_manager->getLc());
}

void SettingsModel::setMediaEncryptionMandatory(const bool& enabled) {
    linphone_core_set_media_encryption_mandatory(_manager->getLc(), enabled);
    emit settingsUpdated();
}
