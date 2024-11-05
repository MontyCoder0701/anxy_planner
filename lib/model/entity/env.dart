import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'ENCRYPT_KEY', obfuscate: true)
  static String encryptKey = _Env.encryptKey;

  @EnviedField(varName: 'ENCRYPT_IV', obfuscate: true)
  static String encryptIv = _Env.encryptIv;
}
