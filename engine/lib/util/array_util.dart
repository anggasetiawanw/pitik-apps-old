class ArrayUtil {
  List<List<T>> transpose<T>(List<List<T>> data) {
    List<List<T>> output = [];

    // Check for rectangle matrix
    if (data.any((element) => element.length != data[0].length)) {
      throw const FormatException('Not a rectangle Matrix');
    }

    for (int i = 0; i < data[0].length; i++) {
      output.add(List<T>.generate(data.length, (idx) => data[idx][i]));
    }

    for (int i = 0; i < data.length; i++) {
      List<T> column = data[i];
      for (int j = 0; j < data[0].length; j++) {
        T rowItem = column[j];
        output.elementAt(j).removeAt(i);
        output.elementAt(j).insert(i, rowItem);
      }
    }

    return output;
  }
}
