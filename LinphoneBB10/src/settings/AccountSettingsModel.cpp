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
 *  Created on: 1 oct. 2015
 *      Author: Sylvain Berfini
 */

#include <AccountSettingsModel.h>

AccountSettingsModel::AccountSettingsModel(QObject *parent)
    : QObject(parent),
      _proxyConfig(NULL),
      _authInfo(NULL)
{

}

void AccountSettingsModel::setSelectedAccount(QString sipUri) {
    const MSList *proxy_configs = linphone_core_get_proxy_config_list(LinphoneManager::getInstance()->getLc());
    sipUri = QString("sip:") + sipUri;

    while (proxy_configs) {
        LinphoneProxyConfig *lpc = (LinphoneProxyConfig *)proxy_configs->data;
        const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(lpc);
        const char *uri = linphone_address_as_string_uri_only(addr);

        if (strcmp(uri, sipUri.toUtf8().constData()) == 0) {
            _proxyConfig = lpc;
            _authInfo = linphone_core_find_auth_info(LinphoneManager::getInstance()->getLc(), NULL, linphone_address_get_username(addr), linphone_address_get_domain(addr));
            if (_proxyConfig && _authInfo) {
                emit accountUpdated();
            }
            return;
        }

        proxy_configs = ms_list_next(proxy_configs);
    }
}

void AccountSettingsModel::selectDefaultProxy() {
    _proxyConfig = linphone_core_get_default_proxy_config(LinphoneManager::getInstance()->getLc());
    if (!_proxyConfig) {
        return;
    }

    const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(_proxyConfig);
    _authInfo = linphone_core_find_auth_info(LinphoneManager::getInstance()->getLc(), NULL, linphone_address_get_username(addr), linphone_address_get_domain(addr));
    if (_proxyConfig && _authInfo) {
        emit accountUpdated();
    }
}

QString AccountSettingsModel::username() const {
    if (!_authInfo) {
        return NULL;
    }
    return linphone_auth_info_get_username(_authInfo);
}

void AccountSettingsModel::setUsername(const QString& username) {
    if (!_authInfo || !_proxyConfig) {
        return;
    }
    LinphoneAuthInfo *ai = linphone_auth_info_clone(_authInfo);
    linphone_auth_info_set_username(ai, username.toUtf8().constData());
    linphone_core_remove_auth_info(LinphoneManager::getInstance()->getLc(), _authInfo);
    linphone_core_add_auth_info(LinphoneManager::getInstance()->getLc(), ai);
    _authInfo = ai;

    const char *identity = linphone_proxy_config_get_identity(_proxyConfig);
    LinphoneAddress *addr = linphone_core_create_address(LinphoneManager::getInstance()->getLc(), identity);
    linphone_address_set_username(addr, username.toUtf8().constData());

    linphone_proxy_config_edit(_proxyConfig);
    linphone_proxy_config_set_identity_address(_proxyConfig, addr);
    linphone_proxy_config_done(_proxyConfig);
    linphone_address_destroy(addr);
}

QString AccountSettingsModel::authid() const {
    if (!_authInfo) {
        return NULL;
    }
    return linphone_auth_info_get_userid(_authInfo);
}

void AccountSettingsModel::setAuthid(const QString& authid) {
    if (!_authInfo) {
        return;
    }
    LinphoneAuthInfo *ai = linphone_auth_info_clone(_authInfo);
    linphone_auth_info_set_userid(ai, authid.toUtf8().constData());
    linphone_core_remove_auth_info(LinphoneManager::getInstance()->getLc(), _authInfo);
    linphone_core_add_auth_info(LinphoneManager::getInstance()->getLc(), ai);
    _authInfo = ai;
}

QString AccountSettingsModel::domain() const {
    if (!_authInfo) {
        return NULL;
    }
    return linphone_auth_info_get_domain(_authInfo);
}

void AccountSettingsModel::setDomain(const QString& domain) {
    if (!_authInfo || !_proxyConfig) {
        return;
    }
    LinphoneAuthInfo *ai = linphone_auth_info_clone(_authInfo);
    linphone_auth_info_set_domain(ai, domain.toUtf8().constData());
    linphone_core_remove_auth_info(LinphoneManager::getInstance()->getLc(), _authInfo);
    linphone_core_add_auth_info(LinphoneManager::getInstance()->getLc(), ai);
    _authInfo = ai;

    const char *identity = linphone_proxy_config_get_identity(_proxyConfig);
    LinphoneAddress *addr = linphone_core_create_address(LinphoneManager::getInstance()->getLc(), identity);
    linphone_address_set_domain(addr, domain.toUtf8().constData());

    linphone_proxy_config_edit(_proxyConfig);
    linphone_proxy_config_set_identity_address(_proxyConfig, addr);
    linphone_proxy_config_done(_proxyConfig);
    linphone_address_destroy(addr);
}

QString AccountSettingsModel::displayName() const {
    if (!_proxyConfig) {
        return NULL;
    }
    const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(_proxyConfig);
    return linphone_address_get_display_name(addr);
}

void AccountSettingsModel::setDisplayName(const QString& displayName) {
    if (!_proxyConfig) {
        return;
    }
    const char *identity = linphone_proxy_config_get_identity(_proxyConfig);
    LinphoneAddress *addr = linphone_core_create_address(LinphoneManager::getInstance()->getLc(), identity);
    linphone_address_set_display_name(addr, displayName.toUtf8().constData());

    linphone_proxy_config_edit(_proxyConfig);
    linphone_proxy_config_set_identity_address(_proxyConfig, addr);
    linphone_proxy_config_done(_proxyConfig);
    linphone_address_destroy(addr);
}

int AccountSettingsModel::transportIndex() const {
    if (!_proxyConfig) {
        return -1;
    }

    const char *transport = linphone_proxy_config_get_transport(_proxyConfig);
    if (strcmp(transport, "udp") == 0) {
        return 0;
    } else if (strcmp(transport, "tcp") == 0) {
        return 1;
    } else if (strcmp(transport, "tls") == 0) {
        return 2;
    }

    return -1;
}

QString AccountSettingsModel::proxy() const {
    if (!_proxyConfig) {
        return NULL;
    }
    return linphone_proxy_config_get_server_addr(_proxyConfig);
}

bool AccountSettingsModel::outboundProxy() const {
    if (!_proxyConfig) {
        return false;
    }
    return linphone_proxy_config_get_route(_proxyConfig) != NULL;
}

bool AccountSettingsModel::avpf() const {
    if (!_proxyConfig) {
        return false;
    }
    return linphone_proxy_config_avpf_enabled(_proxyConfig);
}

bool AccountSettingsModel::defaultProxy() const {
    return linphone_core_get_default_proxy_config(LinphoneManager::getInstance()->getLc()) == _proxyConfig;
}

void AccountSettingsModel::setDefaultProxy(const bool& yes) {
    if (!_proxyConfig || !yes) {
        return;
    }
    linphone_core_set_default_proxy_config(LinphoneManager::getInstance()->getLc(), _proxyConfig);
    emit accountUpdated();
}

void AccountSettingsModel::deleteAccount() {
    if (_proxyConfig) {
        linphone_core_remove_proxy_config(LinphoneManager::getInstance()->getLc(), _proxyConfig);
    }
    if (_authInfo) {
        linphone_core_remove_auth_info(LinphoneManager::getInstance()->getLc(), _authInfo);
    }
    emit accountUpdated();
}
