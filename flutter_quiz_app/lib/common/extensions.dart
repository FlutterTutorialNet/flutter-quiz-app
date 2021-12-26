extension Format on Duration {
  String format() => '$this'.split('.')[0].padLeft(8, '0');
}
