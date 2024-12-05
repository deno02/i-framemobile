class Connection {
  final String id;
  final String siteName;
  final String siteProtocol;
  final String siteAddress;
  final String username;
  final String password;

  Connection({
    required this.id,
    required this.siteName,
    required this.siteProtocol,
    required this.siteAddress,
    required this.username,
    required this.password,
  });

  // JSON'dan Connection objesi oluşturma
  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      id: json['id'],
      siteName: json['siteName'],
      siteProtocol: json['siteProtocol'],
      siteAddress: json['siteAddress'],
      username: json['username'],
      password: json['password'],
    );
  }

  // Connection objesini JSON formatına dönüştürme
  Map<String, dynamic> toJson() => {
        'id': id,
        'siteName': siteName,
        'siteProtocol': siteProtocol,
        'siteAddress': siteAddress,
        'username': username,
        'password': password,
      };
}
