/*
 * BPSEventListener.h
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

#ifndef BPSEVENTLISTENER_H_
#define BPSEVENTLISTENER_H_

#include <QObject>
#include <bb/AbstractBpsEventHandler>

class BPSEventListener : public QObject, public bb::AbstractBpsEventHandler
{
    Q_OBJECT

    Q_PROPERTY(bool isKeyboardVisible READ isKeyboardVisible NOTIFY keyboardVisibilityUpdated)

public:
    BPSEventListener();
    ~BPSEventListener();
    virtual void event(bps_event_t *event);

Q_SIGNALS:
    void keyboardVisibilityUpdated();

private:
    bool isKeyboardVisible() const {
        return _isKeyboardVisible;
    }
    bool _isKeyboardVisible;

    static const int _mPixelsHeightToConsiderKeyboardVisible = 200; // This value is used to not trigger on the Passport device unless the special characters keyboard is shown
};

#endif /* BPSEVENTLISTENER_H_ */
