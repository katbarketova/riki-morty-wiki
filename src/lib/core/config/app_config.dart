class AppConfig {
  const AppConfig({required this.baseUrl});

  factory AppConfig.fromEnvironment() {
    const baseUrl = String.fromEnvironment('BASE_URL');
    const isRelease = bool.fromEnvironment('dart.vm.product');
    const isProfile = bool.fromEnvironment('dart.vm.profile');
    const isDebug = !isRelease && !isProfile;

    if (baseUrl.isNotEmpty) {
      return const AppConfig(baseUrl: baseUrl);
    }

    if (isDebug) {
      return const AppConfig(baseUrl: 'https://rickandmortyapi.com/api');
    }

    throw StateError('BASE_URL must be provided with --dart-define');
  }

  final String baseUrl;
}
