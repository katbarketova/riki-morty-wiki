import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final int? id;
  final String? name;
  final String? status;
  final String? species;
  final String? type;
  final String? gender;
  final String? image;

  const CharacterEntity({
    this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, status, species, type, gender, image];
}
