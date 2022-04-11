class UserModel {
  final int id;
  final String username;
  final bool isVerified;
  final String displayPicture;
  final String phone;
  final String email;
  final DateTime joinedDate;
  final List<int> postedPosts;

  UserModel(
      {required this.id,
      required this.username,
      required this.isVerified,
      required this.displayPicture,
      required this.phone,
      required this.email,
      required this.joinedDate,
      required this.postedPosts});
}
