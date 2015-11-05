/*
 * ContactEditorModel.h
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
 *  Created on: 29 juil. 2015
 *      Author: Sylvain Berfini
 */

#ifndef CONTACTEDITORMODEL_H_
#define CONTACTEDITORMODEL_H_

#include <QObject>
#include <bb/cascades/GroupDataModel>
#include <bb/pim/contacts/ContactService>

class ContactEditorModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isNewContact READ isNewContact NOTIFY contactUpdated);
    Q_PROPERTY(QString firstName READ firstName WRITE setFirstName NOTIFY contactUpdated);
    Q_PROPERTY(QString lastName READ lastName WRITE setLastName NOTIFY contactUpdated);
    Q_PROPERTY(bb::cascades::GroupDataModel* sipAddresses READ sipAddresses NOTIFY sipAddressesUpdated);
    Q_PROPERTY(QString photo READ photo NOTIFY contactUpdated);

public:
    ContactEditorModel(QObject *parent = NULL);

Q_SIGNALS:
    void contactUpdated();
    void sipAddressesUpdated();

public Q_SLOTS:
    void setSelectedContactId(int contactId);
    void editPicture(const QStringList &filePicked);
    void saveChanges();
    void deleteContact();

    void setPreviousPage(QString previousPage) {
        _previousPage = previousPage;
    }

    QString getPreviousPage() {
        return _previousPage;
    }

    void updateSipAddressForIndex(int index, QString sipAddress);
    void addNewSipAddressRow();
    void deleteSipAddressRowAtIndex(int index);

private:
    void getContact();
    void createContact();
    void updateContact();

    // The central object to access the contacts service
    bb::pim::contacts::ContactService* _contactService;
    bb::pim::contacts::ContactId _contactId;

    QString _previousPage;

    bb::cascades::GroupDataModel* sipAddresses() const {
        return _sipAddresses;
    }
    bb::cascades::GroupDataModel* _sipAddresses;

    bool isNewContact() const {
        return _isNewContact;
    }
    bool _isNewContact;

    QString firstName() const {
        return _firstName;
    }
    void setFirstName(const QString &firstName) {
        _firstName = firstName;
    }
    QString _firstName;

    QString lastName() const {
        return _lastName;
    }
    void setLastName(const QString &lastName) {
        _lastName = lastName;
    }
    QString _lastName;

    QString photo() const {
        return _photo;
    }
    QString _photo;

    QString _photoUrl;
};

#endif /* CONTACTEDITORMODEL_H_ */
