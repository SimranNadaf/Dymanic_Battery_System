// import 'package:battery_system_app/components/ble_controller.dart';
// import 'package:battery_system_app/components/button.dart';
// import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key, required this.onOut});

  final Function(String) onOut;
  @override
  State<DashBoard> createState() {
    // ignore: no_logic_in_create_state
    return DashBoradState(onOut: onOut);
  }
}

class DashBoradState extends State<DashBoard> {
  DashBoradState({required this.onOut});

  Function(String) onOut;

  bool _isLoading = false;
  bool _device = true;
  bool ignore = true;

  var voltage1 = 3.0;

  var voltage2 = 1.5;
  var temperature = 27.0;
  var status1 = "Running";
  var status2 = "Charging";
  Color _valueColor1 = Colors.grey;
  Color _valueColor2 = Colors.grey;
  late BluetoothConnection connection;

  String name = 'User';
  void getUSer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('email');
    print(value);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Collection reference
    DocumentSnapshot documentSnapshot = await firestore
        .collection(
            'users') // Replace 'your_collection' with your collection name
        .doc(value) // Replace 'your_document_id' with your document ID
        .get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      setState(() {
        name = documentSnapshot.get('fname').substring(0, 1).toUpperCase() +
            documentSnapshot.get('fname').substring(1);
      });
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    connection.finish();
    var snackBar = const SnackBar(
      backgroundColor: Color.fromARGB(255, 8, 120, 41),
      content: Text(
        'You are Logged Out Successfully!',
        style: TextStyle(color: Colors.white),
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void message() {
    print("Alert");
    var snackBar = const SnackBar(
      backgroundColor: Color.fromARGB(255, 8, 120, 41),
      content: Text(
        'You are Logged Out Successfully!',
        style: TextStyle(color: Colors.white),
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // ignore: non_constant_identifier_names
  bool AlertTemp = false;
  List<BluetoothDevice> devices = [];
  String scanText = "SCAN";

  void discoverDevices() async {
    var status = await Permission.bluetooth.request();
    if (status == PermissionStatus.granted) {
// List<BluetoothDevice> devicesBound =
//         await FlutterBluetoothSerial.instance.getBondedDevices();

//     setState(() {
//       devices = devicesBound;
//     });

      Set<BluetoothDevice> setDevices;
      setDevices = devices.toSet();
      FlutterBluetoothSerial.instance.startDiscovery().listen((device) {
        setDevices.add(device.device);
        setState(() {
          // devices.add(device.device);
          devices = setDevices.toList();
          scanText = "SCANING...";
        });
      });
      Future.delayed(const Duration(seconds: 10), () {
        FlutterBluetoothSerial.instance.cancelDiscovery();
        setState(() {
          // devices.add(device.device);
          devices = setDevices.toList();
          scanText = "SCAN";
        });
      });
    } else {
      print(status.isGranted);
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      print(connection.isConnected);
      connection.input?.listen((Uint8List data) {
        print('Data incoming: ${utf8.decode(data)}');

        var str = utf8.decode(data); // "1.2 Running 3.3 Charging 43";
        var trimmedArray = str.trim().split(" ");
        setState(() {
          // devices.add(device.device);
          _device = true;
          voltage1 = double.parse(trimmedArray[0]);
          voltage2 = double.parse(trimmedArray[1]);
          temperature = double.parse(trimmedArray[2]);
          // status1 = trimmedArray[1];
          // status2 = trimmedArray[3];
          // if (temperature > 35.0) {
          //   AlertTemp = true;
          // } else {
          //   AlertTemp = false;
          // }
        });

        // connection.output.add(data); // Sending data

        // if (ascii.decode(data).contains('!')) {
        //   connection.finish(); // Closing connection
        //   print('Disconnecting by local host');
        // }
      }).onDone(() {
        print('Disconnected by remote request');
      });
    } catch (exception) {
      print('Cannot connect, exception occured');
      print(exception.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getUSer();
    if (AlertTemp) {
      message();
    }
    // discoverDevices();
  }

  @override
  Widget build(BuildContext context) {
    int per1 = (voltage1 / 3.7 * 100).round();
    int per2 = (voltage2 / 3.7 * 100).round();
    double battery1 = voltage1 / 3.7;
    double battery2 = voltage2 / 3.7;

    if (per1 <= 20) {
      _valueColor1 = const Color.fromARGB(255, 248, 90, 78);
      ;
    } else if (per1 <= 50) {
      _valueColor1 = const Color.fromARGB(255, 245, 170, 59);
    } else if (per1 <= 100) {
      _valueColor1 = const Color.fromARGB(255, 123, 230, 126);
    }

    if (per2 <= 20) {
      _valueColor2 = const Color.fromARGB(255, 248, 90, 78);
    } else if (per2 <= 50) {
      _valueColor2 = const Color.fromARGB(255, 245, 170, 59);
    } else if (per2 <= 100) {
      _valueColor2 = const Color.fromARGB(255, 123, 230, 126);
    }

    if (temperature > 35 && !(ignore)) {
      AlertTemp = true;
    }

    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                  255, 2, 62, 11), // Background color of the app bar
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (name != null)
                  Text(
                    'Hello, $name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 180,
                  ),
                  IconButton(
                    onPressed: () {
                      logout();
                      onOut('SignIn');
                    },
                    color: Colors.white,
                    iconSize: 30,
                    icon: const Icon(
                      Icons.logout,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AlertTemp
              ? Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 40,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 180,
                    horizontal: 10,
                  ),
                  child: AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 230, 247, 230),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Colors.red, width: 1.0),
                    ),
                    title: const Icon(
                      // Icons.dangerous_sharp,
                      Icons.error_outline_sharp,
                      color: Colors.red,
                      size: 50,
                    ),
                    content: const Column(
                      children: [
                        Text(
                          'Temperature Excite Limit!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Would You Want to Continue...',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    // backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                    actions: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                            Colors.red,
                          ),
                          padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 40,
                            ),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            AlertTemp = false;
                            ignore = true;
                          });
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : _device
                  ? Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          const Text(
                            'Battery 1',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 62, 11),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Status: $status1',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 2, 62, 11),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                                  255, 150, 149, 149)
                                              .withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: SizedBox(
                                      height: 80,
                                      width: 250,
                                      child: LinearProgressIndicator(
                                        value: battery1,
                                        borderRadius: BorderRadius.circular(10),
                                        backgroundColor: const Color.fromARGB(
                                            255, 231, 227, 227),
                                        valueColor: AlwaysStoppedAnimation(
                                            _valueColor1),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                    width: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(
                                          5,
                                        ),
                                        topRight: Radius.circular(
                                          5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '$per1%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            'Battery 2',
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 62, 11),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Status: $status2',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 2, 62, 11),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                                  255, 150, 149, 149)
                                              .withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: SizedBox(
                                      height: 80,
                                      width: 250,
                                      child: LinearProgressIndicator(
                                        value: battery2,
                                        borderRadius: BorderRadius.circular(10),
                                        backgroundColor: const Color.fromARGB(
                                            255, 221, 224, 221),
                                        valueColor: AlwaysStoppedAnimation(
                                            _valueColor2),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                    width: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(
                                          5,
                                        ),
                                        topRight: Radius.circular(
                                          5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '$per2%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Transform.rotate(
                            angle: -1.5708,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 150, 149, 149)
                                            .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const SizedBox(
                                height: 15,
                                width: 80,
                                child: LinearProgressIndicator(
                                  value: 0.5,
                                  backgroundColor: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.red),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          ignore
                              ? Text(
                                  'Temperature: $temperature \u00B0C\nAlert\nSystem Overheat!',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 192, 11, 11),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  'Temperature: $temperature \u00B0C',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 2, 62, 11),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ],
                      ),
                    )
                  : _isLoading
                      ? Container(
                          margin: const EdgeInsets.only(top: 180),
                          height: 200,
                          width: 200,
                          child: const Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Color.fromARGB(255, 2, 62, 11),
                                ),
                                strokeWidth: 4,
                                // value: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Connecting...",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 2, 62, 11),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 35,
                                ),
                                ElevatedButton(
                                  style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 7, 156, 31),
                                    ),
                                    foregroundColor:
                                        MaterialStatePropertyAll(Colors.white),
                                    padding: MaterialStatePropertyAll(
                                      EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 50,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    discoverDevices();
                                  },
                                  child: Text(scanText),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: devices.length,
                                    itemBuilder: (context, index) {
                                      BluetoothDevice device = devices[index];
                                      return Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        child: ListTile(
                                          title: Text(
                                            (device.name) != null
                                                ? device.name.toString()
                                                : "Unknow Device",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 2, 62, 11),
                                            ),
                                          ),
                                          subtitle: Text(
                                            device.address,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 2, 62, 11),
                                            ),
                                          ),
                                          // trailing: Text(data.rssi.toString()),
                                          trailing: TextButton(
                                            style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                Color.fromARGB(
                                                    255, 178, 243, 182),
                                              ),
                                              foregroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.white),
                                              padding: MaterialStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 15,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              _connectToDevice(device);
                                              // setState(() {
                                              //   _isLoading = true;
                                              // });
                                              // controller
                                              //     .connectToDevice(
                                              //         data.device)
                                              //     .then((data) {
                                              //   setState(() {
                                              //     _isLoading =
                                              //         false;
                                              //   });
                                              // });
                                            },
                                            child: const Text(
                                              "connect",
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 2, 62, 11),
                                              ),
                                            ),
                                          ),
                                          // onTap: () => controller
                                          //     .connectToDevice(data.device),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
          // Expanded(
          // child: GetBuilder<BleController>(
          //   init: BleController(),
          //   builder: (BleController controller) {
          //     return Center(
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const SizedBox(
          //       height: 50,
          //     ),
          //     ElevatedButton(
          //         style: const ButtonStyle(
          //           backgroundColor:
          //               MaterialStatePropertyAll(
          //             Color.fromARGB(255, 7, 156, 31),
          //           ),
          //           foregroundColor:
          //               MaterialStatePropertyAll(
          //                   Colors.white),
          //   padding: MaterialStatePropertyAll(
          //     EdgeInsets.symmetric(
          //       vertical: 5,
          //       horizontal: 50,
          //     ),
          //   ),
          // ),
          // onPressed: () async {
          //   controller.scanDevices();
          //   // await controller.disconnectDevice();
          // },
          // child: const Text("SCAN")),
          // StreamBuilder<List<ScanResult>>(
          //     stream: controller.scanResults,
          // builder: (context, snapshot) {
          //   if (snapshot.hasData) {
          //     return Expanded(
          //       child: ListView.builder(
          //           shrinkWrap: true,
          //           itemCount:
          //               snapshot.data!.length,
          //           itemBuilder:
          //               (context, index) {
          //             final data =
          //                 snapshot.data![index];
          //             return Card(
          //               margin: const EdgeInsets
          //                   .symmetric(
          //                   horizontal: 35,
          //                   vertical: 12),
          //               elevation: 2,
          //               color: Colors.white,
          // child: ListTile(
          //   title: Text(
          //     data.device.name,
          //     style:
          //         const TextStyle(
          //       color:
          //           Color.fromARGB(
          //               255,
          //               2,
          //               62,
          //               11),
          //     ),
          //   ),
          //   subtitle: Text(
          //     data.device.id.id,
          //     style:
          //         const TextStyle(
          //       color:
          //           Color.fromARGB(
          //               255,
          //               2,
          //               62,
          //               11),
          //     ),
          //   ),
          //   // trailing: Text(data.rssi.toString()),
          //   trailing: TextButton(
          //     style:
          //         const ButtonStyle(
          //       backgroundColor:
          //           MaterialStatePropertyAll(
          //         Color.fromARGB(
          //             255,
          //             178,
          //             243,
          //             182),
          //       ),
          //       foregroundColor:
          //           MaterialStatePropertyAll(
          //               Colors
          //                   .white),
          //       padding:
          //           MaterialStatePropertyAll(
          //         EdgeInsets
          //             .symmetric(
          //           vertical: 5,
          //           horizontal: 15,
          //         ),
          //       ),
          //     ),
          //     onPressed: () {
          //       setState(() {
          //         _isLoading = true;
          //       });
          //       controller
          //           .connectToDevice(
          //               data.device)
          //           .then((data) {
          //         setState(() {
          //           _isLoading =
          //               false;
          //         });
          //       });
          //     },
          //     child: const Text(
          //       "connect",
          //       style: TextStyle(
          //         color: Color
          //             .fromARGB(
          //                 255,
          //                 2,
          //                 62,
          //                 11),
          //       ),
          //     ),
          //   ),
          //   // onTap: () => controller
          //   //     .connectToDevice(data.device),
          // ),
          // );
          //           }),
          //     );
          //   } else {
          //     return const Center(
          //       child: Text("No Device Found"),
          //     );
          //   }
          //               // }),
          //         ],
          //       ),
          //     );
          //   },
          // ),

          // ),
        ],
      ),
    );
  }
}
