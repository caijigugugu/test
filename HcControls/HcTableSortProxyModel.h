#ifndef HCTABLESORTPROXYMODEL_H
#define HCTABLESORTPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QAbstractTableModel>
#include <QtQml/qqml.h>
#include <QJSValue>
#include "stdafx.h"

class HcTableSortProxyModel : public QSortFilterProxyModel {
    Q_OBJECT
    Q_PROPERTY_AUTO(QVariant, model)
    QML_NAMED_ELEMENT(HcTableSortProxyModel)
public:
    explicit HcTableSortProxyModel(QSortFilterProxyModel *parent = nullptr);

    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

    bool filterAcceptsColumn(int sourceColumn, const QModelIndex &sourceParent) const override;

    bool lessThan(const QModelIndex &sourceLeft, const QModelIndex &sourceRight) const override;

    [[maybe_unused]] Q_INVOKABLE QVariant getRow(int rowIndex);

    [[maybe_unused]] Q_INVOKABLE void setRow(int rowIndex, const QVariant &val);

    [[maybe_unused]] Q_INVOKABLE void insertRow(int rowIndex, const QVariant &val);

    [[maybe_unused]] Q_INVOKABLE void removeRow(int rowIndex, int rows);

    [[maybe_unused]] Q_INVOKABLE void setComparator(const QJSValue &comparator);

    [[maybe_unused]] Q_INVOKABLE void setFilter(const QJSValue &filter);

private:
    QJSValue _filter;
    QJSValue _comparator;
};

#endif // HCTABLESORTPROXYMODEL_H
