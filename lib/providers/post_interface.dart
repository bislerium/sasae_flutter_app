import 'package:sasae_flutter_app/models/post/post_.dart';

abstract class IPost {
  List<Post_Model>? get getPostData;

  bool get getHasMore;
}
