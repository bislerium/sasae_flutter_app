import 'package:sasae_flutter_app/models/post/ngo__.dart';

abstract class AbstractPostModel {
  late final int id;
  late final String? author;
  late final int? authorID;
  late final List<String> relatedTo;
  late final String postContent;
  late final DateTime createdOn;
  late final DateTime? modifiedOn;
  late final bool isAnonymous;
  late final String postType;
  late final List<NGO__Model> pokedNGO;
}
