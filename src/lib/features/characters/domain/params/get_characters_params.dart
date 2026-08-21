import 'package:equatable/equatable.dart';

class GetCharactersParams extends Equatable {
  const GetCharactersParams({required this.page, this.name});

  final int page;
  final String? name;

  @override
  List<Object?> get props => [page, name];
}
