class Post {
  int? id;
  String? postURL;
  List<String>? relatedTo;
  String? postContent;
  DateTime? createdOn;
  DateTime? modifiedOn;
  bool? isPostedAnonymously;
  bool? isRemoved;
  bool? isPokedToNGO;
  String? postType;

  Post({
    this.id,
    this.postURL,
    this.relatedTo,
    this.postContent,
    this.createdOn,
    this.modifiedOn,
    this.isPostedAnonymously,
    this.isRemoved,
    this.isPokedToNGO,
    this.postType,
  });
}
