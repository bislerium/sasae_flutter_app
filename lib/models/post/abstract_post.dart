import './ngo__.dart';

abstract class AbstractPost {
  late final int id;
  late final String author;
  late final List<String> relatedTo;
  late final String content;
  late final DateTime createdOn;
  late final bool isAnonymous;
  late final String postType;
  late final List<NGO__> pokedNGO;
}
