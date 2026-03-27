import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env') // 1. Cambia @envied por @Envied (Mayúscula)
abstract class Env {

    @EnviedField(varName: 'GTFS_KEY', obfuscate: true)
    static final String apiKey = _Env.apiKey; // Al usar obfuscate, debe ser 'static final'
}