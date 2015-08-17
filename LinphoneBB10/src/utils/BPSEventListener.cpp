/*
 * VirtualKeyboardListener.cpp
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

#include "BPSEventListener.h"
#include "src/linphone/LinphoneManager.h"

#include <bps/bps.h>
#include <bps/virtualkeyboard.h>
#include <bps/netstatus.h>

BPSEventListener::BPSEventListener()
    : _isKeyboardVisible(false)
{
    subscribe(virtualkeyboard_get_domain());
    subscribe(netstatus_get_domain());

    bps_initialize();
    virtualkeyboard_request_events(0);
    netstatus_request_events(0);
}

void BPSEventListener::event(bps_event_t *event) {
    if (event != NULL) {
        if (bps_event_get_domain(event) == virtualkeyboard_get_domain()) {
            uint16_t code = bps_event_get_code(event);
            if (code == VIRTUALKEYBOARD_EVENT_VISIBLE) {
                int pixelsHeight = 0;
                virtualkeyboard_get_height(&pixelsHeight);
                if (pixelsHeight > _mPixelsHeightToConsiderKeyboardVisible) {
                    _isKeyboardVisible = true;
                    emit keyboardVisibilityUpdated();
                }
            } else if (code == VIRTUALKEYBOARD_EVENT_HIDDEN && _isKeyboardVisible) {
                _isKeyboardVisible = false;
                emit keyboardVisibilityUpdated();
            } else if (code == VIRTUALKEYBOARD_EVENT_INFO) {
                int pixelsHeight = 0;
                virtualkeyboard_get_height(&pixelsHeight);
                _isKeyboardVisible = pixelsHeight > _mPixelsHeightToConsiderKeyboardVisible;
                emit keyboardVisibilityUpdated();
            }
        } else if (bps_event_get_domain(event) == netstatus_get_domain()) {
            if (NETSTATUS_INFO == bps_event_get_code(event)) {
                netstatus_info_t *info = netstatus_event_get_info(event);
                if (info) {
                    bool networkReachable = netstatus_info_get_availability(info);
                    ms_message("[BB10] Network status event: network reachable: %i", networkReachable);

                    LinphoneManager *manager = LinphoneManager::getInstance();
                    linphone_core_set_network_reachable(manager->getLc(), networkReachable);
                }
            }
        }
    }
}

BPSEventListener::~BPSEventListener() {
    bps_shutdown();
}
