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

    Q_PROPERTY(QString remoteProvisioningUrl READ remoteProvisioningUrl)

public:
    AssistantModel(QObject *parent = NULL);
    void emitAccountActivated(bool yesno);
    void emitUsernameAvailable(bool yesno);
    void emitAccountCreated(bool yesno);

public Q_SLOTS:
    bool configureLinphoneAccount(QString username, QString password, QString displayName);
    bool configureSipAccount(QString username, QString password, QString domain, QString displayName);
    void createLinphoneAccount(QString username, QString password, QString email);
    void isUsernameAvailable(QString username);
    void configureCreatedAccount();
    void isAccountActivated();
    bool remoteProvisioning(QString url);
    bool isValidEmail(QString email);

    void setPreviousPage(QString previousPage) {
        _previousPage = previousPage;
    }

    QString getPreviousPage() {
        return _previousPage;
    }

Q_SIGNALS:
    void accountActivated(bool yesno);
    void usernameAvailable(bool yesno);
    void accountCreated(bool yesno);

private:
    void configureAccount(QString username, QString password, QString domain, QString displayName);

    LinphoneAccountCreator *_accountCreator;
    LinphoneAccountCreatorCbs *_accountCreatorCbs;
    const char *_defaultSipDomain;

    QString _previousPage;

    QString remoteProvisioningUrl() const {
        return _currentRemoteProvisioningUrl;
    }
    QString _currentRemoteProvisioningUrl;
};

#endif /* ASSISTANTMODEL_H_ */
