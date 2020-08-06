enum EndType {
  eaten, thrown, partial, alive, incorrect
}

extension EndTypes on EndType {
  static from(String name) {
    switch(name) {
      case 'eaten': return EndType.eaten;
      case 'thrown': return EndType.thrown;
      case 'partial': return EndType.partial;
      case 'alive': return EndType.alive;
      case 'incorrect': return EndType.incorrect;
      default: throw RangeError("enum EndType contains no value $name");
    }
  }
}

