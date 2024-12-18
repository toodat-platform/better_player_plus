import 'package:better_player_plus/better_player_plus.dart';
import 'package:better_player_example/constants.dart';
import 'package:flutter/material.dart';

class DrmPage extends StatefulWidget {
  @override
  _DrmPageState createState() => _DrmPageState();
}

class _DrmPageState extends State<DrmPage> {
  late BetterPlayerController _tokenController;
  late BetterPlayerController _widevineController;
  late BetterPlayerController _fairplayController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    BetterPlayerDataSource _tokenDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      Constants.tokenEncodedHlsUrl,
      videoFormat: BetterPlayerVideoFormat.hls,
      drmConfiguration: BetterPlayerDrmConfiguration(
          drmType: BetterPlayerDrmType.token,
          token: Constants.tokenEncodedHlsToken),
    );
    _tokenController = BetterPlayerController(betterPlayerConfiguration);
    _tokenController.setupDataSource(_tokenDataSource);

    _widevineController = BetterPlayerController(betterPlayerConfiguration);
    BetterPlayerDataSource _widevineDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      Constants.widevineVideoUrl,
      drmConfiguration: BetterPlayerDrmConfiguration(
          drmType: BetterPlayerDrmType.widevine,
          licenseUrl: Constants.widevineLicenseUrl,
          headers: {"Test": "Test2"}),
    );
    _widevineController.setupDataSource(_widevineDataSource);

    _fairplayController = BetterPlayerController(betterPlayerConfiguration);
    BetterPlayerDataSource _fairplayDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "https://contents.pallycon.com/test-contents/bigbuckbunny/hls/master.m3u8",
      videoFormat: BetterPlayerVideoFormat.hls,
      drmConfiguration: BetterPlayerDrmConfiguration(
          drmType: BetterPlayerDrmType.fairplay,
          certificateUrl: "https://license.pallycon.com/ri/fpsKeyManager.do",
          licenseUrl:
              "https://license-global.pallycon.com/ri/licenseManager.do",
          headers: {
            "pallycon-customdata-v2":
                "eyJrZXlfcm90YXRpb24iOmZhbHNlLCJyZXNwb25zZV9mb3JtYXQiOiJvcmlnaW5hbCIsInVzZXJfaWQiOiJ0ZXN0LXVzZXIiLCJkcm1fdHlwZSI6ImZhaXJwbGF5Iiwic2l0ZV9pZCI6IkRFTU8iLCJoYXNoIjoiMEZjRkF3R2xnWVdlWkcwYjhpYnJ1RzZoRldwMENvSHgvQmhxemVJRXlMND0iLCJjaWQiOiJCQkJfRlBTX0FWQ19BQUNfSExTX1RTX0NCQ1NfU0lOR0xFS0VZIiwicG9saWN5IjoidU9COCtMRFlYamxXU2hZTlFERnZHdjlua042eWRLN2lnK25SalR4d3hCNFk1MUxlN3RLZDRNajdodW83MUtPdy9iWjFyOEZPSy9aZ0Y1TWovc2FsRHkxVU5DTkVpRkk3REVGVVRLcUV5TTB0bEhvYTkyRHpvSkV0UHdPdzArVE5sM2xoeHlScUlybWhrOGN4c1ViSWhQRHRXUGdMeUtLaEZpSVhMc1d1RTIwVmpoR054blBNWGV0RTZ6a1ZjSDJjTDQ1SVc4Rm9SekU0cEpid0w4RXVkc3Z2eDhmZTlSSU5Da1RIMEZHZjJwMXQrd0VBNjBMNXRWc1lyQ3RCT1FNbHNGa04rejhzTW9mZjdPZldEZHF4UTRobW42OFR0UzF5SjQweU9qTmMyRFd1T1AxMk1QemppQ3RTbnkway8vaUxUVHFFay9WSnllV2Y5L2MrYU8wNWQvQitrbG9yMVJyUWhEVHM1eTB2aGdORWkvaGEvMzA0Vm1WWXJmQy91M0NMTGlyOGlZSUNlN3g1TEIyWE9VSXhqRzdVTEc5L29NdW5DaE9pMGZMVm5KT25obXVmcXYybHozelJDVXZiQXFyYzdrdy81ejgwZ0E3Z3l3cjZhMzBlWVpuNEViMFQ1aDFZZ1F1dlA0N0FaZUxCOTlMaSs0VS9xZEN6OFFMNUE5VngiLCJ0aW1lc3RhbXAiOiIyMDI0LTA4LTA3VDA2OjQzOjIxWiJ9",
            "siteId": "DEMO"
          }),
    );
    _fairplayController.setupDataSource(_fairplayDataSource);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DRM player"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Auth token based DRM.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _tokenController),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Widevine - license url based DRM. Works only for Android.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _widevineController),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Fairplay - certificate url based EZDRM. Works only for iOS.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _fairplayController),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
