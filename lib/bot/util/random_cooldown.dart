import 'dart:math';

extension RandomCooldown on Random {
  int randomCooldown(int min, int max) {
    return min == max ? min : min + nextInt(max - min);
  }
}