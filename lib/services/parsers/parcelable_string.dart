abstract interface class ParcelableString<T> {
  Future<T> parseString(final String data);
}