import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iframemobile/core/class/crypto_class.dart';
import 'package:iframemobile/core/components/alert_dialog.dart';
import 'package:iframemobile/core/components/custom_text_field.dart';
import 'package:iframemobile/core/components/password_field.dart';
import 'package:iframemobile/core/model/iframe_connection_model.dart';
import 'package:iframemobile/core/provider/iframe_connection_provider.dart';
import 'package:iframemobile/core/service/api_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddOrEditConnection extends StatefulWidget {
  final Connection? connection;
  const AddOrEditConnection(this.connection, {super.key});

  @override
  State<AddOrEditConnection> createState() => _AddOrEditConnectionState();
}

class _AddOrEditConnectionState extends State<AddOrEditConnection> {
  bool useDefaultNotifications = true;
  String selectedProtocol = 'http';
  bool isButtonEnabled = true;
  bool isChecked = false;
  EncryptionService encryptionService = EncryptionService();
  final TextEditingController siteNameController = TextEditingController();
  final TextEditingController siteAddressController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscured = true;

  @override
  void initState() {
    super.initState();
    if (widget.connection != null) {
      selectedProtocol = widget.connection!.siteProtocol;
      siteNameController.text = widget.connection!.siteName;
      siteAddressController.text = widget.connection!.siteAddress;
      usernameController.text = widget.connection!.username;
      passwordController.text =
          encryptionService.decryptText(widget.connection!.password);
    }
  }

  @override
  void dispose() {
    siteNameController.dispose();
    siteAddressController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void saveConnection() async {
    var uuid = const Uuid();
    String uniqueId = uuid.v4();

    final newConnection = Connection(
      id: uniqueId,
      siteName: siteNameController.text,
      siteProtocol: selectedProtocol,
      siteAddress: siteAddressController.text,
      username: usernameController.text,
      password: encryptionService.encryptText(passwordController.text),
    );

    final connectionProvider =
        Provider.of<ConnectionIframeAppProvider>(context, listen: false);
    await connectionProvider.saveConnection(newConnection);
  }

  void editConnection() async {
    final updatedConnection = Connection(
      id: widget.connection!.id,
      siteName: siteNameController.text,
      siteProtocol: selectedProtocol,
      siteAddress: siteAddressController.text,
      username: usernameController.text,
      password: encryptionService.encryptText(passwordController.text),
    );

    final connectionProvider =
        Provider.of<ConnectionIframeAppProvider>(context, listen: false);
    await connectionProvider.editConnection(
      widget.connection!.id,
      updatedConnection,
    );
  }

  Future<void> performConnection() async {
    ApiService apiService = ApiService();

    if (siteNameController.text.isEmpty ||
        siteAddressController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedProtocol.isEmpty) {
      showAlertDialog(context, 'Warning', 'Please fill in all fields');
    } else {
      Map<String, String> passwordData = {
        'password': passwordController.text,
      };
      try {
        final response = await apiService.login(
          "$selectedProtocol://${siteAddressController.text}/FSession/login?userName=${usernameController.text}",
          passwordData,
        );
        if (response.statusCode == 200) {
          if (context.mounted) {
            if (widget.connection == null) {
              saveConnection();
            } else {
              editConnection();
            }
            if (context.mounted) {
              if (!mounted) return;
              Navigator.pop(context);
            }
          }
        } else {
          if (!mounted) return;
          showAlertDialog(
            context,
            'Warning',
            'Connection failed. Please check your username or password',
          );
        }
      } catch (e) {
        if (!mounted) return;
        showAlertDialog(
          context,
          'Error',
          'Connection failed. Please check your protocol or site address.\n$e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.connection == null ? 'Add Connection' : 'Edit Connection',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'iframeImage',
                    child: SizedBox(
                      height: 100,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset(
                          'assets/images/iframesplash.png',
                          fit: BoxFit.fill,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  CustomTextField(
                      controller: siteNameController, label: 'Site Name'),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width / 4,
                        child: buildProtocolDropdown(),
                      ),
                      SizedBox(
                        width: size.width / 1.55,
                        child: CustomTextField(
                            controller: siteAddressController,
                            label: 'Site Address'),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  CustomTextField(
                      controller: usernameController, label: 'Username'),
                  SizedBox(height: size.height * 0.03),
                  PasswordField(
                      controller: passwordController, label: 'Password'),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: isButtonEnabled
                            ? () async {
                                setState(() {
                                  isButtonEnabled = false;
                                });
                                try {
                                  await performConnection();
                                } finally {
                                  setState(() {
                                    isButtonEnabled = true;
                                  });
                                }
                              }
                            : null,
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildProtocolDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedProtocol,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedProtocol = newValue;
          });
        }
      },
      items: <String>['http', 'https']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Protocol',
        labelStyle: const TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
