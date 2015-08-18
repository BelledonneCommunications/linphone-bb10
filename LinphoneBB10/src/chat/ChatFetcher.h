/*
 * ChatFetcher.h
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
 *  Created on: 2 août 2015
 *      Author: Sylvain Berfini
 */

#ifndef CHATFETCHER_H_
#define CHATFETCHER_H_

#include <QThread>
#include <bb/cascades/GroupDataModel>
#include "linphone/linphonecore.h"

class ChatFetcher : public QThread
{
    Q_OBJECT

public:
    ChatFetcher();
    void emitChatFetched(QVariantMap chat);
    void updateChat(LinphoneChatRoom *room, LinphoneChatMessage *message, bb::cascades::GroupDataModel *dataModel);
    void updateChatReadCount(QString sipAddress, bb::cascades::GroupDataModel *dataModel);

Q_SIGNALS:
    void chatFetched(QVariantMap chat);

protected:
    void run();
};

#endif /* CHATFETCHER_H_ */
