import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  //latitude - 위도 | longtitude - 경도
  static final LatLng companyLatLng = LatLng(
    37.5233273,
    126.921252,
  );
  static final double distance = 100;
  static final Circle circle = Circle(
    circleId: CircleId('circle'),
    center: companyLatLng,
    fillColor: Colors.amber.withOpacity(0.4),
    radius: distance,
    strokeColor: Colors.amber,
    strokeWidth: 1,
  );

  static final CameraPosition initialPosition = CameraPosition(
    target: companyLatLng,
    zoom: 15,
  );

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder(
        future: checkPermission(), //Future가 반환하는 값이 바뀔 때마다 다시 그림
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == '위치 권한이 허가되었습니다.') {
            return Column(
              children: [
                CustomGoogleMap(
                  circle: circle,
                  initialPosition: initialPosition,
                ),
                _CheckCommutingButton(),
              ],
            );
          }

          return Center(
            child: Text(snapshot.data!),
          );
        }),
      ),
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요.';
    }
    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 세팅에서 허가해주세요.';
    }

    return '위치 권한이 허가되었습니다.';
  }

  AppBar renderAppBar() {
    return AppBar(
      title: Text(
        '오늘도 출근',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class CustomGoogleMap extends StatelessWidget {
  final Circle circle;
  final CameraPosition initialPosition;

  const CustomGoogleMap({
    super.key,
    required this.initialPosition,
    required this.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: GoogleMap(
        circles: {circle},
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
      ),
    );
  }
}

class _CheckCommutingButton extends StatelessWidget {
  const _CheckCommutingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text('출근'),
    );
  }
}
