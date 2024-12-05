import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iframemobile/core/model/iframe_connection_model.dart';

class ConnectionIframeAppProvider extends ChangeNotifier {
  List<Connection> _connections = [];
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  List<Connection> get connections => _connections;

  // Load connections only once at the start
  Future<void> loadConnections() async {
    try {
      String? connectionsString = await _secureStorage.read(key: 'connections');
      if (connectionsString != null) {
        List<dynamic> connectionsList = json.decode(connectionsString);
        _connections = connectionsList
            .map((connectionJson) => Connection.fromJson(connectionJson))
            .toList();
                notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading connections: $e');
    }
  }

  Future<void> _syncWithStorage() async {
    await _secureStorage.write(
        key: 'connections', value: json.encode(_connections.map((e) => e.toJson()).toList()));
  }

  Future<void> saveConnection(Connection connectionDetails) async {
    try {
      _connections.add(connectionDetails);
      await _syncWithStorage();
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving connection: $e');
    }
  }

 Future<void> deleteConnection(Connection connection) async {
  try {
    // Bağlantıyı listeden kaldır
    _connections.remove(connection);

    // Güncel listeyi depoya yaz
    await _syncWithStorage();

    // Dinleyicileri bilgilendir
    notifyListeners();
  } catch (e) {
    debugPrint('Error deleting connection: $e');
  }
}


  Future<void> editConnection(
      String connectionId, Connection updatedDetails) async {
    try {
      int connectionIndex = _connections
          .indexWhere((connection) => connection.id == connectionId);
      if (connectionIndex != -1) {
        _connections[connectionIndex] = updatedDetails;
        await _syncWithStorage();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error editing connection: $e');
    }
  }
}
