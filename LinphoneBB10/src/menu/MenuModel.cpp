/*
 * MenuModel.cpp
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
 *  Created on: 31 juil. 2015
 *      Author: Sylvain Berfini
 */

#include "MenuModel.h"
#include "src/linphone/LinphoneManager.h"
#include "src/utils/Misc.h"

MenuModel::MenuModel(QObject *parent)
    : QObject(parent),
      _displayName(""),
      _sipUri(""),
      _photo("")
{
    bool result = QObject::connect(LinphoneManager::getInstance(), SIGNAL(registrationStatusChanged(LinphoneRegistrationState)), this, SLOT(updateAccount()));
    Q_ASSERT(result);
    Q_UNUSED(result);

    updateAccount();
}

void MenuModel::updateAccount() {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    LpConfig *lp = linphone_core_get_config(lc);
    _photo = lp_config_get_string(lp, "app", "avatar_url", "asset:///images/avatar.png");

    LinphoneProxyConfig *lpc = linphone_core_get_default_proxy_config(lc);
    if (lpc != NULL) {
        const LinphoneAddress *identity = linphone_proxy_config_get_identity_address(lpc);
        _displayName = GetDisplayNameFromLinphoneAddress(identity);
        _sipUri = linphone_address_as_string_uri_only(identity);

        emit defaultAccountUpdated();
    }
}

void MenuModel::setPicture(const QStringList &filePicked)
{
    if (filePicked.size() > 0) {
        _photo = "file:///" + filePicked.first();
        emit defaultAccountUpdated();

        LinphoneManager *manager = LinphoneManager::getInstance();
        LinphoneCore *lc = manager->getLc();
        LpConfig *lp = linphone_core_get_config(lc);
        lp_config_set_string(lp, "app", "avatar_url", _photo.toUtf8().constData());
    }
}
