/*
 * ContactFetcher.h
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
 *  Created on: 1 août 2015
 *      Author: Sylvain Berfini
 */

#ifndef CONTACTFETCHER_H_
#define CONTACTFETCHER_H_

#include <QThread>
#include <bb/pim/contacts/ContactService>

typedef struct ContactFound
{
    int id;
    QString displayName;
    QString picturePath;
    QString smallPicturePath;
} ContactFound;

class ContactFetcher : public QThread
{
    Q_OBJECT

public:
    static ContactFetcher* getInstance();
    bb::pim::contacts::ContactService* getContactService();
    ContactFound findContact(QString searchValue);
    void setContactsToUpdate(QList<int> contactsToUpdate);

Q_SIGNALS:
    void contactFetched(QVariantMap contact, bool isSipContact, bool isLinphoneContact);

protected:
    void run();

private:
    ContactFetcher();

    // The central object to access the contacts service
    bb::pim::contacts::ContactService* _contactService;

    QString _sipDomainToLookForToDisplayLinphoneLogo;
    QList<int> _contactsToUpdate;
};

static ContactFetcher *_contactFetcherInstance = NULL;

#endif /* CONTACTFETCHER_H_ */
