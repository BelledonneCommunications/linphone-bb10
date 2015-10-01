/*
 * AccountSettingsModel.h
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

#ifndef ACCOUNTSETTINGSMODEL_H_
#define ACCOUNTSETTINGSMODEL_H_

#include <QObject>

#include "src/linphone/LinphoneManager.h"

class AccountSettingsModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY accountUpdated);
    Q_PROPERTY(QString authid READ authid WRITE setAuthid NOTIFY accountUpdated);
    Q_PROPERTY(QString domain READ domain WRITE setDomain NOTIFY accountUpdated);
    Q_PROPERTY(QString displayName READ displayName WRITE setDisplayName NOTIFY accountUpdated);

    Q_PROPERTY(int transportIndex READ transportIndex NOTIFY accountUpdated);
    Q_PROPERTY(QString proxy READ proxy NOTIFY accountUpdated);
    Q_PROPERTY(bool outboundProxy READ outboundProxy NOTIFY accountUpdated);
    Q_PROPERTY(bool avpf READ avpf NOTIFY accountUpdated);

    Q_PROPERTY(bool defaultProxy READ defaultProxy WRITE setDefaultProxy NOTIFY accountUpdated);

public:
    AccountSettingsModel(QObject *parent = NULL);

public Q_SLOTS:
    void setSelectedAccount(QString sipUri);
    void selectDefaultProxy();
    void deleteAccount();

Q_SIGNALS:
    void accountUpdated();

private:
    LinphoneProxyConfig *_proxyConfig;
    const LinphoneAuthInfo *_authInfo;

    QString username() const;
    void setUsername(const QString& username);
    QString authid() const;
    void setAuthid(const QString& authid);
    //QString password() const;
    //void setPassword(const QString& password);
    QString domain() const;
    void setDomain(const QString& domain);
    QString displayName() const;
    void setDisplayName(const QString& displayName);

    int transportIndex() const;
    QString proxy() const;
    bool outboundProxy() const;
    bool avpf() const;

    bool defaultProxy() const;
    void setDefaultProxy(const bool& yes);
};

#endif /* ACCOUNTSETTINGSMODEL_H_ */
