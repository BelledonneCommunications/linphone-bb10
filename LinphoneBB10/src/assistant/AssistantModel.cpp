/*
 * AssistantModel.cpp
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

#include "AssistantModel.h"
#include "src/linphone/LinphoneManager.h"

#include <bb/system/InvokeManager.hpp>

using namespace bb::system;

static void test_account_existence_cb(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status) {
    AssistantModel *thiz = (AssistantModel *)linphone_account_creator_get_user_data(creator);
    thiz->emitUsernameAvailable(status == LinphoneAccountCreatorOk);
}

static void test_account_validation_cb(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status) {
    AssistantModel *thiz = (AssistantModel *)linphone_account_creator_get_user_data(creator);
    thiz->emitAccountActivated(status == LinphoneAccountCreatorOk);
}

static void account_validate_cb(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status) {
    AssistantModel *thiz = (AssistantModel *)linphone_account_creator_get_user_data(creator);
    thiz->emitAccountCreated(status == LinphoneAccountCreatorOk);
}

AssistantModel::AssistantModel(QObject *parent)
    : QObject(parent),
      _accountCreator(NULL),
      _accountCreatorCbs(NULL),
      _defaultSipDomain(NULL),
      _previousPage(""),
      _currentRemoteProvisioningUrl("")
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LpConfig *lpc = linphone_core_get_config(lc);

    const char *wizardUrl = lp_config_get_string(lpc, "wizard", "wizard_url", "https://www.linphone.org/wizard.php");
    _defaultSipDomain = lp_config_get_string(lpc, "wizard", "default_sip_domain", "sip.linphone.org");
    _currentRemoteProvisioningUrl = lp_config_get_string(lpc, "misc", "config-uri", "");

    _accountCreator = linphone_account_creator_new(lc, wizardUrl);
    linphone_account_creator_set_user_data(_accountCreator, this);
    _accountCreatorCbs = linphone_account_creator_get_callbacks(_accountCreator);
    linphone_account_creator_cbs_set_existence_tested(_accountCreatorCbs, test_account_existence_cb);
    linphone_account_creator_cbs_set_validation_tested(_accountCreatorCbs, test_account_validation_cb);
    linphone_account_creator_cbs_set_validated(_accountCreatorCbs, account_validate_cb);
}

void AssistantModel::configureAccount(QString username, QString password, QString domain, QString displayName)
{
    linphone_account_creator_set_username(_accountCreator, username.toUtf8().constData());
    linphone_account_creator_set_password(_accountCreator, password.toUtf8().constData());

    linphone_account_creator_set_domain(_accountCreator, domain.toUtf8().constData());
    linphone_account_creator_set_route(_accountCreator, domain.toUtf8().constData());

    if (displayName.length() > 0) {
        linphone_account_creator_set_display_name(_accountCreator, displayName.toUtf8().constData());
    }

    LinphoneProxyConfig *lpc = linphone_account_creator_configure(_accountCreator);
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    linphone_core_set_default_proxy_config(lc, lpc);
}

bool AssistantModel::configureLinphoneAccount(QString username, QString password, QString displayName)
{
    if (username.length() == 0) {
        return false;
    }

    configureAccount(username, password, _defaultSipDomain, displayName);

    return true;
}

bool AssistantModel::configureSipAccount(QString username, QString password, QString domain, QString displayName)
{
    if (username.length() == 0 || domain.length() == 0) {
        return false;
    }

    configureAccount(username, password, domain, displayName);

    return true;
}

void AssistantModel::createLinphoneAccount(QString username, QString password, QString email)
{
    if (username.length() == 0 || email.length() == 0) {
        return;
    }

    linphone_account_creator_set_username(_accountCreator, username.toUtf8().constData());
    linphone_account_creator_set_password(_accountCreator, password.toUtf8().constData());
    linphone_account_creator_set_domain(_accountCreator, _defaultSipDomain);
    linphone_account_creator_set_route(_accountCreator, _defaultSipDomain);
    linphone_account_creator_set_email(_accountCreator, email.toUtf8().constData());

    linphone_account_creator_validate(_accountCreator);
}

void AssistantModel::isUsernameAvailable(QString username)
{
    if (username.length() == 0) {
        return;
    }

    linphone_account_creator_set_username(_accountCreator, username.toUtf8().constData());
    linphone_account_creator_set_domain(_accountCreator, _defaultSipDomain);
    linphone_account_creator_test_existence(_accountCreator);
}

void AssistantModel::configureCreatedAccount()
{
    LinphoneProxyConfig *lpc = linphone_account_creator_configure(_accountCreator);
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    linphone_core_set_default_proxy_config(lc, lpc);
}

void AssistantModel::isAccountActivated()
{
    linphone_account_creator_test_validation(_accountCreator);
}

bool AssistantModel::remoteProvisioning(QString url)
{
    if (url.length() == 0) {
        return false;
    }

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LpConfig *lpc = linphone_core_get_config(lc);
    lp_config_set_string(lpc, "misc", "config-uri", url.toUtf8().constData());
    lp_config_sync(lpc);

    manager->destroy();
    manager->createAndStartLinphoneCore();

    return true;
}

void AssistantModel::emitAccountActivated(bool yesno) {
    emit accountActivated(yesno);
}

void AssistantModel::emitAccountCreated(bool yesno) {
    emit accountCreated(yesno);
}

void AssistantModel::emitUsernameAvailable(bool yesno) {
    emit usernameAvailable(yesno);
}

bool AssistantModel::isValidEmail(QString email) {
    if (email.length() == 0) {
        return false;
    }

    QString emailPattern = "\\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z0-9]{2,6}\\b";
    QRegExp emailRegexp(emailPattern);
    return emailRegexp.exactMatch(email);
}
