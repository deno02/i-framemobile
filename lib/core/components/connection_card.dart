import 'package:flutter/material.dart';
import 'package:iframemobile/core/class/crypto_class.dart';
import 'package:iframemobile/core/components/alert_dialog.dart';
import 'package:iframemobile/core/model/iframe_connection_model.dart';
import 'package:iframemobile/core/provider/iframe_connection_provider.dart';
import 'package:iframemobile/core/service/api_service.dart';
import 'package:iframemobile/widgets/add_or_edit_connection.dart';
import 'package:iframemobile/widgets/web_view.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ConnectionCard extends StatefulWidget {
  final Connection connection;
  const ConnectionCard({super.key, required this.connection});

  @override
  ConnectionCardState createState() => ConnectionCardState();
}

class ConnectionCardState extends State<ConnectionCard> {
  Future<void> _handleLogin(BuildContext context, Connection connection) async {
    ApiService apiService = ApiService();
    EncryptionService encryptionService = EncryptionService();
    String decryptPassword = encryptionService.decryptText(connection.password);

    Map<String, String> passwordData = {
      'password': decryptPassword,
    };

    try {
      final response = await apiService.login(
        "${connection.siteProtocol}://${connection.siteAddress}/FSession/login?userName=${connection.username}",
        passwordData,
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen( url:
                "${connection.siteProtocol}://${connection.siteAddress}/html/main.html?userName=${connection.username}&password=$decryptPassword",),
            ),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        if (!mounted) return;
        if (context.mounted) {
          showAlertDialog(
            context,
            'warning'.tr(),
            'connection_failed_by_userinfo'.tr(),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      if (context.mounted) {
        showAlertDialog(
          context,
          'warning'.tr(),
          'error_try_again'.tr(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;

    return Dismissible(
     key: ValueKey(widget.connection.id), // Benzersiz key
      direction: DismissDirection.endToStart,
      onDismissed: (direction)async {
       await Provider.of<ConnectionIframeAppProvider>(context, listen: false)
        .deleteConnection(widget.connection);
    setState(() {}); // Widget ağacını yeniden oluştur
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.delete, color: Colors.white),
              Text('delete'.tr(), style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      child: InkWell(
        onDoubleTap: () {
          // Double tap handling
        },
        child: Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(color: Colors.grey, width: 1.2),
          ),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.connection.siteName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddOrEditConnection(widget.connection),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.blueGrey),
                            onPressed: () async {
                              await _handleLogin(context, widget.connection);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                      '${'site_address'.tr()}: ${widget.connection.siteAddress}',
                      style: _textStyle),
                  const SizedBox(height: 4),
                  Text('${'username'.tr()}: ${widget.connection.username}',
                      style: _textStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle get _textStyle {
    return const TextStyle(
        fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold);
  }
}
