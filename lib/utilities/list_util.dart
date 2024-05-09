import 'dart:math';

void shuffle(List array) {
  for (var i = array.length - 1; i > 0; i--) {
    var j = Random().nextInt(i + 1);
    var temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
}
