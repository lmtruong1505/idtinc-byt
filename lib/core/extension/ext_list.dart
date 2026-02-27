part of 'init_ext.dart';

extension ListExtension on List {
  List<T> addAll<T>(List<T> list) {
    return [...this, ...list];
  }

  List addIf<T>(bool condition, T item) {
    return condition ? [...this, item] : this;
  }

  List<T> remove<T>(T item) {
    return List<T>.from(this)..remove(item);
  }

  List<T> removeAt<T>(int index) {
    return List<T>.from(this)..removeAt(index);
  }

  List<T> removeWhere<T>(bool Function(T) test) {
    return List<T>.from(this)..removeWhere(test);
  }

  List<T> retainWhere<T>(bool Function(T) test) {
    return List<T>.from(this)..retainWhere(test);
  }

  List<T> where<T>(bool Function(T) test) {
    return List<T>.from(this)..where(test);
  }

  List<T> map<T>(T Function(T) f) {
    return List<T>.from(this)..map(f);
  }

  List<T> expand<T>(Iterable<T> Function(T) f) {
    return List<T>.from(this)..expand(f);
  }

  List<T> cast<T>() {
    return List<T>.from(this);
  }

  List get reversed {
    return List.from(this)..reversed;
  }

  List get shuffled {
    return List.from(this)..shuffle();
  }

  List get sorted {
    return List.from(this)..sort();
  }

  List get reversedSorted {
    return List.from(this)..sort((a, b) => b.compareTo(a));
  }

  List get unique {
    return List.from(this)..toSet().toList();
  }

  List get duplicates {
    return List.from(this)..where((item) => count(item) > 1).toSet().toList();
  }

  int count<T>(T item) {
    return List<T>.from(this).where((T i) => i == item).length;
  }

  String joinWith<T>(String separator) {
    return List<T>.from(this).join(separator);
  }
}

extension ExtList on List? {
  List get validator => this ?? [];
  String get toText {
    if (this == null) {
      return '';
    }

    return this!.join(', ');
  }
}

extension ExtendList<T> on List<T> {
  void extend(int newLength, T defaultValue) {
    assert(newLength >= 0); // Đảm bảo độ dài mới không âm.

    final lengthDifference =
        newLength - length; // Tính toán số phần tử cần thêm.
    if (lengthDifference <= 0) {
      return; // Nếu danh sách đã dài hơn hoặc bằng newLength, không làm gì cả.
    }

    // Thêm các phần tử mặc định để đạt tới newLength.
    addAll(List.filled(lengthDifference, defaultValue));

    // List<int> numbers = [1, 2, 3];

    // print("Before extend: $numbers"); // Output: Before extend: [1, 2, 3]

    // // Sử dụng extension để mở rộng danh sách
    // numbers.extend(6, 0);

    // print("After extend: $numbers"); // Output: After extend: [1, 2, 3, 0, 0, 0]
  }
}
