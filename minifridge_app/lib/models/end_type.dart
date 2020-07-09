enum EndType {
  eaten, thrown, alive
}

extension EndTypes on EndType {
  static from(String name) {
    switch(name) {
      case 'eaten': return EndType.eaten;
      case 'thrown': return EndType.thrown;
      case 'alive': return EndType.alive;
      default: throw RangeError("enum EndType contains no value $name");
    }
  }
}

