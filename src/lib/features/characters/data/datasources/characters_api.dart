import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riki_morty_wiki/features/characters/data/dto/characters_response_dto.dart';

part 'characters_api.g.dart';

@RestApi()
abstract class CharactersApi {
  factory CharactersApi(Dio dio, {String baseUrl}) = _CharactersApi;

  @GET('/character')
  Future<CharactersResponseDto> getCharacters(@Query('page') int page);
}
