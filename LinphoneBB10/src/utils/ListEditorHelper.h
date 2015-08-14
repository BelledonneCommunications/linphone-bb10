/*
 * ListEditorHelper.h
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
 *  Created on: 3 août 2015
 *      Author: Sylvain Berfini
 */

#ifndef LISTEDITORHELPER_H_
#define LISTEDITORHELPER_H_

#include <QObject>
#include <bb/cascades/GroupDataModel>

class ListEditorHelper: public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isEditMode READ isEditMode WRITE setEditMode NOTIFY editModeUpdated)
    Q_PROPERTY(int selectionSize READ selectionSize NOTIFY editModeUpdated)

public:
    ListEditorHelper(bb::cascades::GroupDataModel *dataModel);
    void setDataModel(bb::cascades::GroupDataModel *dataModel);

public Q_SLOTS:
    void updateSelection(const QVariantList &indexPath, bool checked);
    void deleteSelection();
    void selectAll(bool select);

Q_SIGNALS:
    void editModeUpdated();
    void deleteRequested(QList<QVariantList> indexPaths);

private:
    bool isEditMode() const {
        return _isEditMode;
    }
    void setEditMode(const bool &editModeEnabled);
    bool _isEditMode;

    int selectionSize() const {
        return _selection.size();
    }
    QList<QVariantList> _selection;

    bb::cascades::GroupDataModel *_dataModel;
};

#endif /* LISTEDITORHELPER_H_ */
