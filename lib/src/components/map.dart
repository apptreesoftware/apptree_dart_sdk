/// Map settings initial zoom mode options
enum MapZoomMode { markers, custom }

/// Map type options
enum MapType { normal, satellite, hybrid, terrain }

/// Camera position for map initialization
class CameraPosition {
  final double latitude;
  final double longitude;
  final double? zoom;

  CameraPosition({required this.latitude, required this.longitude, this.zoom});

  Map<String, dynamic> toDict() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      if (zoom != null) 'zoom': zoom,
    };
  }
}

/// Settings for map display in a RecordList
class MapSettings {
  final String? longitudeKey;
  final String? latitudeKey;
  final String? markerTitle;
  final String? markerSummary;
  final bool? showCurrentLocation;
  final bool? showIndoorMaps;
  final MapZoomMode? initialZoomMode;
  final MapType? mapType;
  final CameraPosition? initialCameraPosition;

  MapSettings({
    this.longitudeKey,
    this.latitudeKey,
    this.markerTitle,
    this.markerSummary,
    this.showCurrentLocation,
    this.showIndoorMaps,
    this.initialZoomMode,
    this.mapType,
    this.initialCameraPosition,
  });

  Map<String, dynamic> toDict() {
    return {
      if (longitudeKey != null) 'longitudeKey': longitudeKey,
      if (latitudeKey != null) 'latitudeKey': latitudeKey,
      if (markerTitle != null) 'markerTitle': markerTitle,
      if (markerSummary != null) 'markerSummary': markerSummary,
      if (showCurrentLocation != null)
        'showCurrentLocation': showCurrentLocation,
      if (showIndoorMaps != null) 'showIndoorMaps': showIndoorMaps,
      if (initialZoomMode != null)
        'initialZoomMode': initialZoomMode.toString().split('.').last,
      if (mapType != null) 'mapType': mapType.toString().split('.').last,
      if (initialCameraPosition != null)
        'initialCameraPosition': initialCameraPosition!.toDict(),
    };
  }
}
