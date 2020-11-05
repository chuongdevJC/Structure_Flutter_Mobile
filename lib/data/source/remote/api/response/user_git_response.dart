import 'package:json_annotation/json_annotation.dart';
import 'package:structure_flutter_mobile/data/entities/user_git_entity.dart';

part 'user_git_response.g.dart';

@JsonSerializable()
class UserGitResponse {
  @JsonKey(name: "items")
  final List<UserGitEntity> userGits;

  UserGitResponse(this.userGits);

  factory UserGitResponse.fromJson(Map<String, dynamic> json) =>
      _$UserGitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserGitResponseToJson(this);
}
