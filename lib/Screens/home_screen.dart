import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var deviceData = <String, dynamic>{};

  @override
  void initState() {
    initPlatFormState();
    super.initState();
  }

  Future<void> initPlatFormState() async {
    try {
      if (kIsWeb) {
        deviceData = readDeviceInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        final deviceInformation = await getDeviceInfo();
        deviceData = readDeviceInfo(deviceInformation);
      }
    } catch (e) {
      deviceData = <String, dynamic>{'Error': 'Failed to Get Info'};
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<dynamic> getDeviceInfo() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await deviceInfoPlugin.androidInfo;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await deviceInfoPlugin.iosInfo;
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return await deviceInfoPlugin.linuxInfo;
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      return await deviceInfoPlugin.windowsInfo;
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return await deviceInfoPlugin.macOsInfo;
    } else {
      return null;
    }
  }

  Map<String, dynamic> readDeviceInfo(dynamic deviceInfo) {
    if (deviceInfo is AndroidDeviceInfo) {
      return <String, dynamic>{
        'Version': deviceInfo.version.release,
        'Model': deviceInfo.model,
        'Brand': deviceInfo.brand,
      };
    } else if (deviceInfo is IosDeviceInfo) {
      return <String, dynamic>{
        'Model': deviceInfo.model,
        'System Version': deviceInfo.systemVersion,
      };
    } else if (deviceInfo is LinuxDeviceInfo) {
      return <String, dynamic>{
        'Name': deviceInfo.name,
        'Version': deviceInfo.version,
      };
    } else if (deviceInfo is WindowsDeviceInfo) {
      return <String, dynamic>{
        'Version': deviceInfo.majorVersion,
        'Computer Name': deviceInfo.computerName,
      };
    } else if (deviceInfo is MacOsDeviceInfo) {
      return <String, dynamic>{
        'Model': deviceInfo.model,
        'Kernel Version': deviceInfo.kernelVersion,
      };
    } else {
      return <String, dynamic>{'Error': 'UnSuppoerted PlatForm'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 5.0,
          title: Text(_getAppBarTitle()),
          centerTitle: true,
        ),
        body: ListView(
          children: deviceData.entries.map((e) {
            return ListTile(
              title: Text(e.key),
              subtitle: Text(e.value.toString()),
            );
          }).toList(),
        ));
  }

  String _getAppBarTitle() {
    if (kIsWeb) {
      return "Web Browser Info";
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return 'Android Device Info';
        case TargetPlatform.iOS:
          return 'iOS Device Info';
        case TargetPlatform.linux:
          return 'Linux Device Info';
        case TargetPlatform.windows:
          return 'Windows Device Info';
        case TargetPlatform.macOS:
          return 'MacOS Device Info';
        default:
          return 'Unsupported Platform';
      }
    }
  }
}
