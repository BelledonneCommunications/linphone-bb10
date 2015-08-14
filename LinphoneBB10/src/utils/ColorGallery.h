/*
 * ColorGallery.h
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
 *  Created on: 22 juil. 2015
 *      Author: Sylvain Berfini
 */

#ifndef COLORGALLERY_H_
#define COLORGALLERY_H_

#include <QObject>
#include <bb/cascades/Color>

class ColorGallery : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bb::cascades::Color colorA READ colorA CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorA15 READ colorA15 CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorB READ colorB CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorC READ colorC CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorD READ colorD CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorE READ colorE CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorF READ colorF CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorG READ colorG CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorH READ colorH CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorI READ colorI CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorJ READ colorJ CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorK READ colorK CONSTANT);
    Q_PROPERTY(bb::cascades::Color colorL READ colorL CONSTANT);

public:
    ColorGallery(QObject *parent = NULL) : QObject(parent) { }
    virtual ~ColorGallery() { }

private:
    bb::cascades::Color colorA() const {
        return bb::cascades::Color::fromARGB(0xffff5e00);
    }
    bb::cascades::Color colorA15() const {
        return bb::cascades::Color::fromARGB(0xffffe7d9); // This is the color resulting of colorA with 15% opacity above a white background
    }
    bb::cascades::Color colorB() const {
        return bb::cascades::Color::fromARGB(0xff000000);
    }
    bb::cascades::Color colorC() const {
        return bb::cascades::Color::fromARGB(0xff444444);
    }
    bb::cascades::Color colorD() const {
        return bb::cascades::Color::fromARGB(0xff808080);
    }
    bb::cascades::Color colorE() const {
        return bb::cascades::Color::fromARGB(0xffc4c4c4);
    }
    bb::cascades::Color colorF() const {
        return bb::cascades::Color::fromARGB(0xffe1e1e1);
    }
    bb::cascades::Color colorG() const {
        return bb::cascades::Color::fromARGB(0xfff3f3f3);
    }
    bb::cascades::Color colorH() const {
        return bb::cascades::Color::fromARGB(0xffffffff);
    }
    bb::cascades::Color colorI() const {
        return bb::cascades::Color::fromARGB(0xffff0000);
    }
    bb::cascades::Color colorJ() const {
        return bb::cascades::Color::fromARGB(0xffffa645);
    }
    bb::cascades::Color colorK() const {
        return bb::cascades::Color::fromARGB(0xff3eb5c0);
    }
    bb::cascades::Color colorL() const {
        return bb::cascades::Color::fromARGB(0xff96c11f);
    }
};

#endif /* COLORGALLERY_H_ */
