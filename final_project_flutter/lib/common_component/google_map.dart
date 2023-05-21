// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import 'package:final_project_year/apis/apis_functions.dart';
import 'package:final_project_year/common_component/search_field.dart';

class GoogleMapComponentFarmScreen extends StatefulWidget {
  GoogleMapComponentFarmScreen({super.key});
  LatLng? point;
  String? file;
  List<LatLng> list1 = [];
  Polygon plogon = Polygon(points: []);
  bool draw = false;
  @override
  State<GoogleMapComponentFarmScreen> createState() =>
      _GoogleMapComponentFarmScreenState();
}

class _GoogleMapComponentFarmScreenState
    extends State<GoogleMapComponentFarmScreen> {
  Future<Style> _readStyle() => StyleReader(
        uri:
            'https://api.maptiler.com/maps/basic-v2/style.json?key=QYQUEU69gtldW1rv100f',
        apiKey: '',
      ).read();
  void _initStyle() async {
    try {} catch (e, stack) {
      // ignore: avoid_print
      print(e);
      // ignore: avoid_print
      print(stack);
    }
    setState(() {});
  }

  @override
  void initState() {
    _initStyle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                widget.draw = !widget.draw;
                widget.draw ? widget.point = null : null;
                setState(() {});
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => widget.draw ? Colors.green : Colors.blue)),
              child: const Icon(Icons.rectangle_sharp),
            ),
            Container(
              width: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue)),
              child: const Text(
                'اخذ الاحداث اللحالي',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Position p = await _determinePosition();
                widget.point = LatLng(p.latitude, p.longitude);
                widget.list1 = [];
                setState(() {});
              },
            ),
            Container(
              width: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue)),
              child: const Text(
                'تحميل ملف سيغه shape file',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: [
                      'geojson',
                      'json',
                      'zip',
                    ]);
                if (result is FilePickerResult) {
                  PlatformFile r1 = result.files[0];
                  widget.file = r1.path;
                  if (widget.file is String) {
                    widget.point = null;
                    widget.list1 = [];
                  }
                  setState(() {});
                }
              },
            )
          ],
        ),
        SizedBox(
          height: 330 - 18,
          child: FlutterMap(
            options: MapOptions(
              //bounds: LatLngBounds.fromPoints([]),
              center: LatLng(31.382677, 23.137003),
              maxZoom: 6,
              onMove: (tapPosition, point) {
                if (!widget.draw) return;
                widget.list1[2] = point;
                widget.list1[1] =
                    LatLng(point.latitude, widget.list1[0].longitude);
                widget.list1[3] =
                    LatLng(widget.list1[0].latitude, point.longitude);

                widget.plogon = Polygon(
                    points: widget.list1,
                    borderColor: Colors.black,
                    isFilled: true,
                    borderStrokeWidth: 2,
                    color: Colors.blue.withOpacity(0.2));
                //widget.draw = false;
                setState(() {});
              },
              onPointerDown: (event, point) {
                if (!widget.draw) return;
                widget.list1.clear();
                widget.list1 = <LatLng>[
                  LatLng(0, 0),
                  LatLng(0, 0),
                  LatLng(0, 0),
                  LatLng(0, 0),
                ];
                widget.list1[0] = point;
              },
              onLongPress: (tapPosition, point) {},
              absorbPanEventsOnScrollables: false,
              onPointerHover: (event, point) {},
              enableScrollWheel: true,
              interactiveFlags: widget.draw
                  ? InteractiveFlag.pinchZoom |
                      InteractiveFlag.none |
                      //InteractiveFlag.pinchMove |
                      InteractiveFlag.flingAnimation // |
                  // InteractiveFlag.pinchMove
                  : InteractiveFlag.all & ~InteractiveFlag.rotate,
              onPointerCancel: (event, point) {},
              onPositionChanged: (position, hasGesture) {},
              onTap: (tapPosition, point) {
                print(point);
                widget.point = point;
                widget.list1 = [];
                setState(() {});
              },
              onMapEvent: (p0) {},
              onPointerUp: (event, point) {
                widget.draw = false;
                setState(() {});
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              widget.point == null && widget.list1.isNotEmpty
                  ? PolygonLayer(polygons: () {
                      return [widget.plogon];
                    }())
                  : Container(),
              !(widget.point == null)
                  ? MarkerLayer(
                      markers: [
                        Marker(
                            height: 200,
                            width: 200,
                            point: widget.point!,
                            builder: (context) => const Icon(Icons.location_on))
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Future<Position> _determinePosition() async {
    Position p = await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
    );
    widget.point = LatLng(p.latitude, p.longitude);
    setState(() {});

    LocationPermission permission = await Geolocator.requestPermission();
    bool serviceEnabled;
    // Test if location services are enabled.

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return p;
  }
}

extension ComparelatLng on LatLng {
  bool operator <(LatLng l1) {
    if (longitude == -1) {
      return false;
    }
    return latitude < l1.latitude || longitude < l1.longitude;
  }

  bool operator >(LatLng l1) {
    if (longitude == -1) {
      return false;
    }
    return latitude > l1.latitude || longitude > l1.longitude;
  }
}

class GoogleMapComponentDashBoardScreen extends StatefulWidget {
  const GoogleMapComponentDashBoardScreen({super.key});

  @override
  State<GoogleMapComponentDashBoardScreen> createState() {
    return _GoogleMapComponentDashBoardScreenState();
  }
}

class _GoogleMapComponentDashBoardScreenState
    extends State<GoogleMapComponentDashBoardScreen> {
  MapController mapController = MapController();
  LatLng biggest = LatLng(-1, -1), smallest = LatLng(-1, -1);

  @override
  void initState() {
    super.initState();
  }

  LatLng handleLocation({required LatLng latLng, required double value}) {
    print("${(latLng.latitude + 90 + value) % 180} before ");
    print("${(latLng.latitude + 180 + value) % 360} before");
    double vlat = ((latLng.latitude + 90 + value) % 180) - 90;
    double vlng = ((latLng.longitude + 180 + value) % 360) - 180;
    return LatLng(vlat, vlng);
  }

  List<Marker> list1 = [];
  List<Polygon> plogon = [];
  bool draw = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 330,
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            center: LatLng(30, 30),
            onPositionChanged: (position, hasGesture) async {
              if ((position.zoom ?? 0) >= 5) {
                if (biggest < (position.bounds?.northEast)! ||
                    smallest > (position.bounds?.southWest)! ||
                    biggest.longitude == -1) {
                  print("done");
                  smallest = handleLocation(
                      latLng: position.bounds!.southWest!, value: -5);

                  biggest = handleLocation(
                      latLng: position.bounds!.northEast!, value: 5);

                  Map<String, dynamic> map1 = await get_data_map(
                      formData: FormData.fromMap({
                    "smallest":
                        json.encode([smallest.latitude, smallest.longitude]),
                    "biggest":
                        json.encode([biggest.latitude, biggest.longitude])
                  }));

                  plogon = map1["ploygons"];
                  list1 = map1["markers"];
                  print(list1);
                  setState(() {});
                }
              } else {
                plogon.clear();
                list1.clear();
              } /*else if (plogon.isNotEmpty) {
                plogon.clear();
                list1.clear();
              }*/
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            ),
            PolygonLayer(polygons: plogon),
            list1.isNotEmpty
                ? MarkerLayer(
                    markers: list1,
                  )
                : Container(),
            Wrap(
              children: [
                Container(
                    margin: const EdgeInsets.all(3),
                    width: 300,
                    child: SearchTextField(width: 100)),
                SizedBox(
                  height: 30,
                  child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.green)),
                      onPressed: () {},
                      child: const Text('search',
                          style: TextStyle(color: Colors.white))),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
