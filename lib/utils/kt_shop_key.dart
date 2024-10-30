import 'encrypt.dart';

String getTime() {
  final date = DateTime.now();
  final year = date.year.toString();
  final month = (date.month).toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final hours = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  final second = date.second.toString().padLeft(2, '0');

  return '$year$month$day$hours$minute$second';
}

String getKTShopKey() {
  return encryptText(getTime());
}

String encryptKTShopKey(String text) {
  return encryptText(text);
}
