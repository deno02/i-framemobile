import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iframemobile/core/components/connection_card.dart';
import 'package:iframemobile/core/model/iframe_connection_model.dart';
import 'package:iframemobile/core/provider/iframe_connection_provider.dart';
import 'package:iframemobile/widgets/add_or_edit_connection.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Connection> connections = [];
  bool isButtonEnabled = true;

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  Provider.of<ConnectionIframeAppProvider>(context, listen: false).loadConnections();
}


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Consumer<ConnectionIframeAppProvider>(
        builder: (context, connectionProvider, child) {
          connections = connectionProvider.connections;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'iframeImage',
                  child: SizedBox(
                    height: 100,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        'assets/images/iframesplash.png',
                        fit: BoxFit.fill,
                        width: 100,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (connections.isNotEmpty)
                 ...connections.map((connection) => ConnectionCard(connection: connection))
                else
                  Padding(
                    padding: EdgeInsets.only(top: size.height / 5),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'connection_add'.tr(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddOrEditConnection(null)),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
