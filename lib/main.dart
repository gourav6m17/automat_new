import 'dart:developer';

import 'package:automat/Constant/const.dart';
import 'package:automat/model/devices_model.dart';
import 'package:automat/plugins/reactive_ble/ui/device_list.dart';
import 'package:automat/plugins/reactive_ble/utils.dart';
import 'package:automat/services/automat_services.dart';
import 'package:automat/services/intl_service.dart';
import 'package:automat/ui/basic/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'plugins/reactive_ble/ble/ble_device_connector.dart';
import 'plugins/reactive_ble/ble/ble_device_interactor.dart';
import 'plugins/reactive_ble/ble/ble_logger.dart';
import 'plugins/reactive_ble/ble/ble_scanner.dart';
import 'plugins/reactive_ble/ble/ble_status_monitor.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as ble;
import 'package:location/location.dart' as loc;

const _themeColor = Colors.lightGreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _bleLogger = BleLogger();
  final _ble = FlutterReactiveBle();
  final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
  final _monitor = BleStatusMonitor(_ble);
  final _connector = BleDeviceConnector(
    ble: _ble,
    logMessage: _bleLogger.addToLog,
  );
  final _serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: _ble.discoverServices,
    readCharacteristic: _ble.readCharacteristic,
    writeWithResponse: _ble.writeCharacteristicWithResponse,
    writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: _ble.subscribeToCharacteristic,
    logMessage: _bleLogger.addToLog,
  );
  final _autoServices = AutomatServices();
  final appDocumentDirectory =
      (await getExternalStorageDirectories(type: StorageDirectory.documents))
          ?.first;
  if (!kIsWeb) {
    // <-- I put this here so that I could use Hive in Flutter Web

    Hive.init(appDocumentDirectory!.path);
  }
  await Hive.initFlutter(appDocumentDirectory!.path);
  log("----app paths---" + appDocumentDirectory.path);
  Hive.registerAdapter(DevicesModelDBAdapter());
  Hive.registerAdapter(DeviceListModelDBAdapter());
  Hive.registerAdapter(DiscoveredDeviceModelAdapter());
  await Hive.openBox<DevicesModelDB>(dbName);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(
      MultiProvider(
        providers: [
          Provider.value(value: _scanner),
          Provider.value(value: _monitor),
          Provider.value(value: _connector),
          Provider.value(value: _serviceDiscoverer),
          Provider.value(value: _bleLogger),
          StreamProvider<BleScannerState?>(
            create: (_) => _scanner.state,
            initialData: const BleScannerState(
              discoveredDevices: [],
              scanIsInProgress: false,
            ),
          ),

          StreamProvider<BleStatus?>(
            create: (_) => _monitor.state,
            initialData: BleStatus.unknown,
          ),
          // ChangeNotifierProvider(create: (_) => AutomatServices()),

          StreamProvider<ConnectionStateUpdate>(
            create: (_) => _connector.state,
            initialData: const ConnectionStateUpdate(
              deviceId: 'Unknown device',
              connectionState: DeviceConnectionState.disconnected,
              failure: null,
            ),
          ),
          // StreamProvider(
          //     create: (_) =>
          //         _autoServices.readDpCycle(characteristicId, deviceId),
          //     initialData: initialData)
          // StreamProvider<AutomatServices>(create: create, initialData: initialData)
        ],
        child: GetMaterialApp(
          translations: IntlService(),
          locale: const Locale("en", "US"),
          debugShowCheckedModeBanner: false,
          // color: _themeColor,
          // theme: ThemeData(primarySwatch: _themeColor),
          builder: EasyLoading.init(),
          home: const SplashScreen(),
        ),
      ),
    );
  });
  //runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       translations: IntlService(),
//       locale: const Locale("en", "US"),
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? locStatus;
  getLocationStatus() async {
    await Permission.location.request();
    await Permission.bluetooth.request().then((value) => log(value.name));
    final loc = await Permission.locationWhenInUse.serviceStatus.isEnabled;
    setState(() {
      locStatus = loc;
    });
    log(loc.toString());
  }

  @override
  void initState() {
    getLocationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<BleStatus?>(
        builder: (_, status, __) {
          log(status.toString());
          if (status == BleStatus.ready) {
            return const SplashScreen();
          } else if (status == BleStatus.unknown ||
              status == BleStatus.poweredOff ||
              status == BleStatus.unauthorized ||
              status == BleStatus.unsupported ||
              status == BleStatus.poweredOff) {
            //openAppSettings();
            log("enter here");

            //ble.FlutterBluePlus.instance.turnOn();

            // Future.delayed(
            //     Duration(seconds: 2), () => Permission.location.request());

            //Geolocator.requestPermission();
            return Center(
                child: Column(
              children: const [
                Text("Turn on Bluetooth"),
                CircularProgressIndicator(),
              ],
            ));
            // return BleStatusScreen(status: status ?? BleStatus.unknown);
          } else {
            Permission.location.request();
            Permission.locationWhenInUse.request();
            return Center(
                child: Column(
              children: const [
                Text("Turn on Location"),
                CircularProgressIndicator(),
              ],
            ));
          }
        },
      );
}
