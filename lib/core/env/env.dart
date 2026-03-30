import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GTFS_KEY', obfuscate: true)
  static final String apiKey = _Env.apiKey;
}
