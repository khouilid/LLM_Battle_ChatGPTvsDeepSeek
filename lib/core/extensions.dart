extension IterableExtension<T> on Iterable<T> {
  Iterable<T> takeLast(int n) {
    if (n <= 0) return [];
    final length = this.length;
    if (length <= n) return this;
    return skip(length - n);
  }
}