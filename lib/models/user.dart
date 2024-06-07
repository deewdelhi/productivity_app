class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });
}

class MyUser {
  MyUser(
      {
      //required this.location,
      required this.firstNmae,
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
  //final Location location;
  List<MyUser> following = [];
}
