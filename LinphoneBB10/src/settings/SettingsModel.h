/*
 * SettingsModel.h
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
 *  Created on: 24 août 2015
 *      Author: Sylvain Berfini
 */

#ifndef SETTINGSMODEL_H_
#define SETTINGSMODEL_H_

#include <QObject>

#include "src/linphone/LinphoneManager.h"

class SettingsModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool debugEnabled READ debugEnabled WRITE setDebugEnabled NOTIFY settingsUpdated)

public:
    SettingsModel(QObject *parent = NULL);

public Q_SLOTS:

Q_SIGNALS:
    void settingsUpdated();

private:
    LinphoneManager *_manager;

    bool debugEnabled() const;
    void setDebugEnabled(const bool& enabled);
};

#endif /* SETTINGSMODEL_H_ */
