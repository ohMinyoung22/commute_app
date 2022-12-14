import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  //latitude - 위도 | longtitude - 경도
  static final LatLng companyLatLng = LatLng(
    37.5233273,
    126.921252,
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
      body: Column(
        children: [
          CustomGoogleMap(
            initialPosition: initialPosition,
          ),
          _CheckCommutingButton(),
        ],
      ),
    );
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
  final CameraPosition initialPosition;

  const CustomGoogleMap({
    super.key,
    required this.initialPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: GoogleMap(
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
