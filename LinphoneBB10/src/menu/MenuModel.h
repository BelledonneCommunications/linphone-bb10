/*
 * MenuModel.h
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

#ifndef MENUMODEL_H_
#define MENUMODEL_H_

#include <QObject>

class MenuModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString displayName READ displayName NOTIFY defaultAccountUpdated);
    Q_PROPERTY(QString sipUri READ sipUri NOTIFY defaultAccountUpdated);
    Q_PROPERTY(QString photo READ photo NOTIFY defaultAccountUpdated);

public:
    MenuModel(QObject *parent = NULL);

public Q_SLOTS:
    void updateAccount();
    void setPicture(const QStringList &filePicked);

Q_SIGNALS:
    void defaultAccountUpdated();

private:
    QString displayName() const {
        return _displayName;
    }
    QString _displayName;

    QString sipUri() const {
        return _sipUri;
    }
    QString _sipUri;

    QString photo() const {
        return _photo;
    }
    QString _photo;
};

#endif /* MENUMODEL_H_ */
