import 'package:equatable/equatable.dart';

class GetCharactersParams extends Equatable {
  const GetCharactersParams({required this.page});

  final int page;

  @override
  List<Object?> get props => [page];
}
