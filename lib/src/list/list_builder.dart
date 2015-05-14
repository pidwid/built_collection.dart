// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.list;

/// The Built Collection builder for [BuiltList].
///
/// It implements the mutating part of the [List] interface.
///
/// See the
/// [Built Collection library documentation](#built_collection/built_collection)
/// for the general properties of Built Collections.
class ListBuilder<E> {
  bool _copyBeforeWrite;
  BuiltList<E> _builtList;
  List<E> _list;

  /// Instantiates with elements from an [Iterable].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new ListBuilder([1, 2, 3])`.
  ///
  /// Right: `new ListBuilder<int>([1, 2, 3])`,
  ///
  /// Rejects nulls. Rejects elements of the wrong type.
  factory ListBuilder([Iterable iterable = const []]) {
    if (iterable is BuiltList<E>) {
      return new ListBuilder<E>._fromBuiltList(iterable);
    } else {
      return new ListBuilder<E>._withSafeList(new List<E>.from(iterable));
    }
  }

  /// Converts to a [BuiltList].
  ///
  /// The `ListBuilder` can be modified again and used to create any number
  /// of `BuiltList`s.
  BuiltList<E> build() {
    if (_builtList == null) {
      _copyBeforeWrite = true;
      _builtList = new BuiltList<E>._withSafeList(_list);
    }
    return _builtList;
  }

  /// Applies a function to `this`.
  void update(updates(ListBuilder<E> builder)) {
    updates(this);
  }

  // Based on List.

  /// As [List].
  operator []=(int index, E element) {
    _checkElement(element);
    _maybeCopyBeforeWrite();
    _list[index] = element;
  }

  /// As [List.add].
  void add(E value) {
    _checkElement(value);
    _maybeCopyBeforeWrite();
    _list.add(value);
  }

  /// As [List.addAll].
  void addAll(Iterable<E> iterable) {
    _checkElements(iterable);
    _maybeCopyBeforeWrite();
    _list.addAll(iterable);
  }

  /// As [List.reversed], but updates the builder in place. Returns nothing.
  void reverse() {
    _list = _list.reversed.toList(growable: true);
    _copyBeforeWrite = false;
  }

  /// As [List.sort].
  void sort([int compare(E a, E b)]) {
    _maybeCopyBeforeWrite();
    _list.sort(compare);
  }

  /// As [List.shuffle].
  void shuffle([Random random]) {
    _maybeCopyBeforeWrite();
    _list.shuffle(random);
  }

  /// As [List.clear].
  void clear() {
    _maybeCopyBeforeWrite();
    _list.clear();
  }

  /// As [List.insert].
  void insert(int index, E element) {
    _checkElement(element);
    _maybeCopyBeforeWrite();
    _list.insert(index, element);
  }

  /// As [List.insertAll].
  void insertAll(int index, Iterable<E> iterable) {
    _checkElements(iterable);
    _maybeCopyBeforeWrite();
    _list.insertAll(index, iterable);
  }

  /// As [List.setAll].
  void setAll(int index, Iterable<E> iterable) {
    _checkElements(iterable);
    _maybeCopyBeforeWrite();
    _list.setAll(index, iterable);
  }

  /// As [List.remove], but returns nothing.
  void remove(Object value) {
    _maybeCopyBeforeWrite();
    _list.remove(value);
  }

  /// As [List.removeAt], but returns nothing.
  void removeAt(int index) {
    _maybeCopyBeforeWrite();
    _list.removeAt(index);
  }

  /// As [List.removeLast], but returns nothing.
  void removeLast() {
    _maybeCopyBeforeWrite();
    _list.removeLast();
  }

  /// As [List.removeWhere].
  void removeWhere(bool test(E element)) {
    _maybeCopyBeforeWrite();
    _list.removeWhere(test);
  }

  /// As [List.retainWhere].
  void retainWhere(bool test(E element)) {
    _maybeCopyBeforeWrite();
    _list.retainWhere(test);
  }

  /// As [List.sublist], but updates the builder in place. Returns nothing.
  void sublist(int start, [int end]) {
    _list = _list.sublist(start, end);
    _copyBeforeWrite = false;
  }

  /// As [List.setRange].
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _checkElements(iterable);
    _maybeCopyBeforeWrite();
    _list.setRange(start, end, iterable, skipCount);
  }

  /// As [List.removeRange].
  void removeRange(int start, int end) {
    _maybeCopyBeforeWrite();
    _list.removeRange(start, end);
  }

  /// As [List.fillRange], but requires a value.
  void fillRange(int start, int end, E fillValue) {
    _checkElement(fillValue);
    _maybeCopyBeforeWrite();
    _list.fillRange(start, end, fillValue);
  }

  /// As [List.replaceRange].
  void replaceRange(int start, int end, Iterable<E> iterable) {
    _checkElements(iterable);
    _maybeCopyBeforeWrite();
    _list.replaceRange(start, end, iterable);
  }

  // Based on Iterable.

  /// As [Iterable.map], but updates the builder in place. Returns nothing.
  void map(E f(E element)) {
    _list = _list.map(f).toList(growable: true);
    _checkElements(_list);
    _copyBeforeWrite = false;
  }

  /// As [Iterable.where], but updates the builder in place. Returns nothing.
  void where(bool test(E element)) {
    _list = _list.where(test).toList(growable: true);
    _copyBeforeWrite = false;
  }

  /// As [Iterable.expand], but updates the builder in place. Returns nothing.
  void expand(Iterable<E> f(E element)) {
    _list = _list.expand(f).toList(growable: true);
    _checkElements(_list);
    _copyBeforeWrite = false;
  }

  /// As [Iterable.take], but updates the builder in place. Returns nothing.
  void take(int n) {
    _list = _list.take(n).toList(growable: true);
    _copyBeforeWrite = false;
  }

  /// As [Iterable.takeWhile], but updates the builder in place. Returns nothing.
  void takeWhile(bool test(E value)) {
    _list = _list.takeWhile(test).toList(growable: true);
    _copyBeforeWrite = false;
  }

  /// As [Iterable.skip], but updates the builder in place. Returns nothing.
  void skip(int n) {
    _list = _list.skip(n).toList(growable: true);
    _copyBeforeWrite = false;
  }

  /// As [Iterable.skipWhile], but updates the builder in place. Returns nothing.
  void skipWhile(bool test(E value)) {
    _list = _list.skipWhile(test).toList(growable: true);
    _copyBeforeWrite = false;
  }

  // Internal.

  ListBuilder._fromBuiltList(BuiltList<E> builtList)
      : _copyBeforeWrite = true,
        _builtList = builtList,
        _list = builtList._list {
    _checkGenericTypeParameter();
  }

  ListBuilder._withSafeList(this._list) : _copyBeforeWrite = false {
    _checkGenericTypeParameter();
  }

  void _maybeCopyBeforeWrite() {
    if (!_copyBeforeWrite) return;
    _copyBeforeWrite = false;
    _builtList = null;
    _list = new List<E>.from(_list, growable: true);
  }

  void _checkGenericTypeParameter() {
    if (null is E && E != Object) {
      throw new UnsupportedError('explicit element type required,'
          ' for example "new ListBuilder<int>"');
    }
  }

  void _checkElement(Object element) {
    if (element is! E) {
      throw new ArgumentError('invalid element: ${element}');
    }
  }

  void _checkElements(Iterable elements) {
    for (final element in elements) {
      _checkElement(element);
    }
  }
}
