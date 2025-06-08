import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'ENCRYPT_KEY', obfuscate: true)
  static final String encryptKey = _Env.encryptKey;

  @EnviedField(varName: 'ENCRYPT_IV', obfuscate: true)
  static final String encryptIv = _Env.encryptIv;

  @EnviedField(varName: 'ANDROID_API_KEY', obfuscate: true)
  static final String androidApiKey = _Env.androidApiKey;

  @EnviedField(varName: 'IOS_API_KEY', obfuscate: true)
  static final String iosApiKey = _Env.iosApiKey;
}
