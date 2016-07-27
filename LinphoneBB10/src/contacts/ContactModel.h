/*
 * ContactModel.h
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
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 *  Created on: 16 févr. 2015
 *      Author: Sylvain Berfini
 */

#ifndef CONTACTMODEL_H_
#define CONTACTMODEL_H_

#include <bb/pim/contacts/ContactService>
#include <bb/cascades/GroupDataModel>
#include <QObject>

class ContactModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString displayName READ displayName NOTIFY contactUpdated);
    Q_PROPERTY(QString photo READ photo NOTIFY contactUpdated);
    Q_PROPERTY(bool isSipContact READ isSipContact NOTIFY contactUpdated);
    Q_PROPERTY(int contactId READ contactId NOTIFY contactUpdated);
    Q_PROPERTY(bb::cascades::GroupDataModel* dataModel READ dataModel NOTIFY contactUpdated);

public:
    ContactModel(QObject *parent = 0);
    void setSelectedContactId(bb::pim::contacts::ContactId contactId);

public Q_SLOTS:
    void deleteContact();

private Q_SLOTS:
    void contactsChanged(const QList<int> &ids);

Q_SIGNALS:
    void contactUpdated();

private:
    void updateContact();

    int contactId() const {
        return _contactId;
    }

    bb::pim::contacts::ContactId _contactId;

    QString displayName() const {
        return _displayName;
    }
    QString _displayName;

    QString photo() const {
        return _photo;
    }
    QString _photo;

    bool isSipContact() const {
        return _isSipContact;
    }
    bool _isSipContact;

    bb::cascades::GroupDataModel* dataModel() const {
        return _dataModel;
    }
    bb::cascades::GroupDataModel* _dataModel;
};

#endif /* CONTACTMODEL_H_ */
