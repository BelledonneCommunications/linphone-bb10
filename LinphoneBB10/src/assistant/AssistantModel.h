/*
 * AssistantModel.h
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

#ifndef ASSISTANTMODEL_H_
#define ASSISTANTMODEL_H_

#include <QObject>
#include "linphone/linphonecore.h"

class AssistantModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString remoteProvisioningUrl READ remoteProvisioningUrl);
    Q_PROPERTY(QString usernameError READ usernameError NOTIFY assistantErrorUpdated);
    Q_PROPERTY(QString pwdError READ pwdError NOTIFY assistantErrorUpdated);
    Q_PROPERTY(QString emailError READ emailError NOTIFY assistantErrorUpdated);

public:
    AssistantModel(QObject *parent = NULL);
    void setUsernameError(QString err);
    void emitAccountActivated(bool yesno);
    void emitAccountCreated(bool yesno);

public Q_SLOTS:
    void setUsername(QString username);
    void setPassword(QString password);
    void setEmail(QString email);
    bool createLinphoneAccount();
    void configureAccount();

    bool configureLinphoneAccount(QString username, QString password, QString displayName);
    bool configureSipAccount(QString username, QString password, QString domain, QString displayName);
    void isAccountActivated();
    bool remoteProvisioning(QString url);

    void setPreviousPage(QString previousPage) {
        _previousPage = previousPage;
    }

    QString getPreviousPage() {
        return _previousPage;
    }

Q_SIGNALS:
    void assistantErrorUpdated();
    void accountActivated(bool yesno);
    void accountCreated(bool yesno);

private:
    void configureAccount(QString username, QString password, QString domain, QString displayName);

    LinphoneAccountCreator *_accountCreator;
    LinphoneAccountCreatorCbs *_accountCreatorCbs;

    QString _previousPage;

    QString remoteProvisioningUrl() const {
        return _currentRemoteProvisioningUrl;
    }
    QString _currentRemoteProvisioningUrl;

    QString usernameError() const {
        return _usernameError;
    }
    QString _usernameError;

    QString pwdError() const {
        return _pwdError;
    }
    QString _pwdError;

    QString emailError() const {
        return _emailError;
    }
    QString _emailError;
};

#endif /* ASSISTANTMODEL_H_ */
