/*
 * HistoryModel.h
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
 *  Created on: 19 mars 2015
 *      Author: Sylvain Berfini
 */

#ifndef HISTORYMODEL_H_
#define HISTORYMODEL_H_

#include <QObject>

#include "src/linphone/LinphoneManager.h"
#include "linphone/linphonecore.h"

class HistoryModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString displayName READ displayName NOTIFY historyLogUpdated);
    Q_PROPERTY(QString sipUri READ sipUri NOTIFY historyLogUpdated);
    Q_PROPERTY(QString linphoneAddress READ linphoneAddress NOTIFY historyLogUpdated);
    Q_PROPERTY(QString photo READ photo NOTIFY historyLogUpdated);
    Q_PROPERTY(QString direction READ direction NOTIFY historyLogUpdated);
    Q_PROPERTY(QString details READ details NOTIFY historyLogUpdated);
    Q_PROPERTY(bool isSipContact READ isSipContact NOTIFY historyLogUpdated)

public:
    HistoryModel(QObject *parent = NULL);
    void setSelectedHistoryLog(LinphoneCallLog *log);

Q_SIGNALS:
    void historyLogUpdated();

private:
    QString displayName() const {
        return _displayName;
    }
    QString _displayName;

    QString sipUri() const {
        return _sipUri;
    }
    QString _sipUri;

    QString linphoneAddress() const {
        return _linphoneAddress;
    }
    QString _linphoneAddress;

    QString photo() const {
        return _photo;
    }
    QString _photo;

    QString direction() const {
        return _direction;
    }
    QString _direction;

    QString details() const {
        return _details;
    }
    QString _details;

    bool isSipContact() const {
        return _isSipContact;
    }
    bool _isSipContact;

    LinphoneCallLog *_selectedHistoryLog;
};

#endif /* HISTORYMODEL_H_ */
