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
    if (status == LinphoneAccountCreatorAccountExist) {
        thiz->setUsernameError("Username already in use");
    } else if (status == LinphoneAccountCreatorAccountNotExist) {
        thiz->setUsernameError("");
    } else {
        QString err = "Unknown error: %%s";
        err = err.replace("%%s", QString::number((int)status));
        thiz->setUsernameError(err);
    }
}

void AssistantModel::setUsernameError(QString err)
{
    _usernameError = QT_TR_NOOP(err);
    emit assistantErrorUpdated();
}

static void test_account_validation_cb(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status) {
    AssistantModel *thiz = (AssistantModel *)linphone_account_creator_get_user_data(creator);
    thiz->emitAccountActivated(status == LinphoneAccountCreatorAccountValidated);
}

static void account_create_cb(LinphoneAccountCreator *creator, LinphoneAccountCreatorStatus status) {
    AssistantModel *thiz = (AssistantModel *)linphone_account_creator_get_user_data(creator);
    thiz->emitAccountCreated(status == LinphoneAccountCreatorAccountCreated);
}

AssistantModel::AssistantModel(QObject *parent)
    : QObject(parent),
      _accountCreator(NULL),
      _accountCreatorCbs(NULL),
      _previousPage(""),
      _currentRemoteProvisioningUrl(""),
      _usernameError(""),
      _pwdError(""),
      _emailError("")
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LpConfig *lpc = linphone_core_get_config(lc);

    const char *wizardUrl = lp_config_get_string(lpc, "asssitant", "asssitant_url", "https://www.linphone.org/wizard.php");
    _currentRemoteProvisioningUrl = lp_config_get_string(lpc, "misc", "config-uri", "");

    _accountCreator = linphone_account_creator_new(lc, wizardUrl);
    linphone_account_creator_set_user_data(_accountCreator, this);
    _accountCreatorCbs = linphone_account_creator_get_callbacks(_accountCreator);
    linphone_account_creator_cbs_set_existence_tested(_accountCreatorCbs, test_account_existence_cb);
    linphone_account_creator_cbs_set_validation_tested(_accountCreatorCbs, test_account_validation_cb);
    linphone_account_creator_cbs_set_create_account(_accountCreatorCbs, account_create_cb);

    setUsername("");
    setPassword("");
    setEmail("");
}

void AssistantModel::setUsername(QString username)
{
    LinphoneAccountCreatorStatus status = linphone_account_creator_set_username(_accountCreator, username.toUtf8().constData());
    if (status != LinphoneAccountCreatorOK) {
        LinphoneCore *lc = LinphoneManager::getInstance()->getLc();
        LpConfig *config = linphone_core_get_config(lc);
        if (status == LinphoneAccountCreatorUsernameTooShort) {
            int minSize = lp_config_get_int(config, "assistant", "username_min_length", -1);
            QString err = QT_TR_NOOP("Username is too short (%%s characters min)");
            _usernameError = err.replace("%%s", QString::number(minSize));
        } else if (status == LinphoneAccountCreatorUsernameTooLong) {
            int maxSize = lp_config_get_int(config, "assistant", "username_max_length", -1);
            QString err = QT_TR_NOOP("Username is too long (%%s characters max)");
            _usernameError = err.replace("%%s", QString::number(maxSize));
        } else if (status == LinphoneAccountCreatorUsernameInvalidSize) {
            int size = lp_config_get_int(config, "assistant", "username_length", -1);
            QString err = QT_TR_NOOP("Username must be %%s characters long");
            _usernameError = err.replace("%%s", QString::number(size));
        } else if (LinphoneAccountCreatorUsernameInvalid) {
            _usernameError = QT_TR_NOOP("Username is not authorized");
        } else if (LinphoneAccountCreatorUsernameInvalid) {
            _usernameError = QT_TR_NOOP("Username is invalid");
        } else {
            QString err = QT_TR_NOOP("Unknown error: %%s");
            _usernameError = err.replace("%%s", QString::number((int)status));
        }
    } else {
        _usernameError = "";
        linphone_account_creator_test_existence(_accountCreator);
    }
    emit assistantErrorUpdated();
}

void AssistantModel::setPassword(QString password)
{
    LinphoneAccountCreatorStatus status = linphone_account_creator_set_password(_accountCreator, password.toUtf8().constData());
    if (status != LinphoneAccountCreatorOK) {
        LinphoneCore *lc = LinphoneManager::getInstance()->getLc();
        LpConfig *config = linphone_core_get_config(lc);
        if (status == LinphoneAccountCreatorPasswordTooShort) {
            int minSize = lp_config_get_int(config, "assistant", "password_min_length", -1);
            QString err = QT_TR_NOOP("Password is too short (%%s characters min)");
            _pwdError = err.replace("%%s", QString::number(minSize));
        } else if (status == LinphoneAccountCreatorPasswordTooLong) {
            int maxSize = lp_config_get_int(config, "assistant", "password_max_length", -1);
            QString err = QT_TR_NOOP("Password is too long (%%s characters max)");
            _pwdError = err.replace("%%s", QString::number(maxSize));
        } else {
            QString err = QT_TR_NOOP("Unknown error: %%s");
            _pwdError = err.replace("%%s", QString::number((int)status));
        }
    } else {
        _pwdError = "";
    }
    emit assistantErrorUpdated();
}

void AssistantModel::setEmail(QString email)
{
    LinphoneAccountCreatorStatus status = linphone_account_creator_set_email(_accountCreator, email.toUtf8().constData());
    if (status != LinphoneAccountCreatorOK) {
        if (status == LinphoneAccountCreatorEmailInvalid) {
            _emailError = QT_TR_NOOP("Email is invalid");
        } else {
            QString err = QT_TR_NOOP("Unknown error: %%s");
            _emailError = err.replace("%%s", QString::number((int)status));
        }
    } else {
        _emailError = "";
    }
    emit assistantErrorUpdated();
}

bool AssistantModel::createLinphoneAccount()
{
    if (usernameError().length() > 0 || pwdError().length() > 0 || emailError().length() > 0) return false;
    return linphone_account_creator_create_account(_accountCreator) == LinphoneAccountCreatorOK;
}

void AssistantModel::configureAccount() {
    LinphoneProxyConfig *lpc = linphone_account_creator_configure(_accountCreator);
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    linphone_core_set_default_proxy_config(lc, lpc);
}

void AssistantModel::configureAccount(QString username, QString password, QString domain, QString displayName)
{
    linphone_account_creator_set_username(_accountCreator, username.toUtf8().constData());
    linphone_account_creator_set_password(_accountCreator, password.toUtf8().constData());

    if (domain != NULL) {
        linphone_account_creator_set_domain(_accountCreator, domain.toUtf8().constData());
        linphone_account_creator_set_route(_accountCreator, domain.toUtf8().constData());
    }

    if (displayName.length() > 0) {
        linphone_account_creator_set_display_name(_accountCreator, displayName.toUtf8().constData());
    }

    configureAccount();
}

bool AssistantModel::configureLinphoneAccount(QString username, QString password, QString displayName)
{
    if (username.length() == 0) {
        return false;
    }

    configureAccount(username, password, NULL, displayName);

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
