class MyUser {
  MyUser(
      {required this.firstNmae,
      required this.lastName,
      required this.email,
      required this.id,
      required this.username,
      required this.pictureUrl});

  final String id;
  final String firstNmae;
  final String lastName;
  final String email;
  final String username;
  final String pictureUrl;
  List<MyUser> following = [];
}
