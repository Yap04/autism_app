import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/timestamp_converter.dart';

part 'content_model.freezed.dart';
part 'content_model.g.dart';

enum ContentTarget { parent, trainer }

enum ContentType { article, video, quiz }

@freezed
class ContentModel with _$ContentModel {
  const factory ContentModel({
    required String id,
    required String title,
    required ContentTarget target,
    required ContentType type,
    @TimestampConverter() required DateTime publishedAt,
    @Default('') String description,
    String? contentUrl,
    @Default(0) int viewsOrTakes,
    @Default(false) bool isPublished,
  }) = _ContentModel;

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);
}
