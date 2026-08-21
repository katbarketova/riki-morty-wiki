// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'characters_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _CharactersApi implements CharactersApi {
  _CharactersApi(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<CharactersResponseDto> getCharacters(int page) async {
    final queryParameters = <String, dynamic>{r'page': page};
    final headers = <String, dynamic>{};
    final options = _setStreamType<CharactersResponseDto>(
      Options(method: 'GET', headers: headers)
          .compose(_dio.options, '/character', queryParameters: queryParameters)
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final result = await _dio.fetch<Map<String, dynamic>>(options);
    return CharactersResponseDto.fromJson(result.data!);
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }

    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
