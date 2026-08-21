import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:riki_morty_wiki/core/config/app_config.dart';
import 'package:riki_morty_wiki/features/characters/data/datasources/characters_api.dart';
import 'package:riki_morty_wiki/features/characters/data/repository/characters_repository.dart';
import 'package:riki_morty_wiki/features/characters/domain/repository/i_characters_repository.dart';
import 'package:riki_morty_wiki/features/characters/domain/usecases/get_characters_use_case.dart';
import 'package:riki_morty_wiki/features/characters/presentation/bloc/characters_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  final config = AppConfig.fromEnvironment();

  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerLazySingleton<Dio>(
      () => Dio(BaseOptions(baseUrl: getIt<AppConfig>().baseUrl)),
    )
    ..registerLazySingleton<CharactersApi>(
      () => CharactersApi(getIt<Dio>(), baseUrl: getIt<AppConfig>().baseUrl),
    )
    ..registerLazySingleton<ICharactersRepository>(
      () => CharactersRepository(getIt<CharactersApi>()),
    )
    ..registerFactory<GetCharactersUseCase>(
      () => GetCharactersUseCase(getIt<ICharactersRepository>()),
    )
    ..registerFactory<CharactersBloc>(
      () => CharactersBloc(getIt<GetCharactersUseCase>()),
    );
}
