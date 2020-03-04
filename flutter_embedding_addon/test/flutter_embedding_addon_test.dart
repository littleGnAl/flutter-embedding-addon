import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_embedding_addon/flutter_embedding_addon.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_embedding_addon');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterEmbeddingAddon.platformVersion, '42');
  });
}
