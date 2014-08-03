import 'package:unittest/unittest.dart';
import 'package:storage_element/base64_zip.dart';

main() {
  test('zip and unzip', () {
    final str = "＼( 'ω')／＜UOOOOOOAAAAAAAA";
    final encoded = zip(str);
    expect(unzip(encoded), str);
  });
}
