bool isInt(String? string) {
  if (string != null && string.isNotEmpty) {
    return int.tryParse(string) != null;
  }
  return false;
}
