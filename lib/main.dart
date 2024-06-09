import 'package:battery_system_app/components/homePage.dart';
import 'package:battery_system_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const HomePage(),
  );
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BluetoothScreen(),
//     );
//   }
// }

// class BluetoothScreen extends StatefulWidget {
//   @override
//   _BluetoothScreenState createState() => _BluetoothScreenState();
// }

// class _BluetoothScreenState extends State<BluetoothScreen> {
//   List<BluetoothDevice> devices = [];

//   @override
//   void initState() {
//     super.initState();
//     discoverDevices();
//   }

//   void discoverDevices() async {
    // List<BluetoothDevice> devicesBound =
    //     await FlutterBluetoothSerial.instance.getBondedDevices();

    // setState(() {
    //   devices = devicesBound;
    // });

    // FlutterBluetoothSerial.instance.startDiscovery().listen((device) {
    //   setState(() {
    //     devices.add(device.device);
    //   });
    // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bluetooth Devices'),
//       ),
//       body: ListView.builder(
//         itemCount: devices.length,
//         itemBuilder: (context, index) {
//           BluetoothDevice device = devices[index];
//           return Card(
//             child: ListTile(
//               title: Text(device.name ?? 'Unknown Device'),
//               subtitle: Text(device.address),
//               onTap: () async {
//                 print('Connecting to ${device.name}');
//                 await BluetoothConnection.toAddress(
//                   device.address,
//                 ).then((connection) {
//                   print('Connected to ${device.name}');
//                 }).catchError((error) {
//                   print('Cannot connect, error: $error');
//                 });
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


// var str = "1.2 Running 3.3 Charging 43";
//     var trimmedArray = str.trim().split(" ");
//     setState(() {
//       // devices.add(device.device);
//       _device = true;
//       voltage1 = double.parse(trimmedArray[0]);
//       voltage2 = double.parse(trimmedArray[2]);
//       temperature = double.parse(trimmedArray[4]);
//       status1 = trimmedArray[1];
//       status2 = trimmedArray[3];
//       // if (temperature > 35.0) {
//       //   AlertTemp = true;
//       // } else {
//       //   AlertTemp = false;
//       // }
//     });