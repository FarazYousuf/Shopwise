import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shop_wise/data/services/location_service.dart';
import 'package:shop_wise/common/widgets/custom_market.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation = LatLng(0, 0);
  String _selectedLocationName = 'Fetching address...';
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  final LocationService _locationService =
      LocationService('AIzaSyAEKlapxJehOu3VV_2sYHv6VirpPx9VenA');
  Set<Marker> _markers = {};
  int _selectedIndex = 1;
  // double _hoverOffset = 0.0;
  List<String> _suggestions = [];
  bool _isSuggestionVisible = false;
  String _regionCode = 'us';
  // String _currentCity = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  //  @override
  // void initState() {
  //   super.initState();
  //   _getCurrentLocation();
  //   _searchController.addListener(() {
  //     _fetchSuggestions(_searchController.text);
  //   });
  // }

  // Future<void> _getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     await Geolocator.openLocationSettings();
  //     return;
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission != LocationPermission.whileInUse &&
  //         permission != LocationPermission.always) {
  //       return;
  //     }
  //   }

  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     _selectedLocation = LatLng(position.latitude, position.longitude);
  //     _isLoading = false;
  //   });

  //   await _updateAddressAndCity(_selectedLocation);
  // }

  // Future<void> _updateAddressAndCity(LatLng position) async {
  //   try {
  //     final address = await _locationService.getAddress(position);
  //     final city = _parseCityFromAddress(address);
  //     setState(() {
  //       _selectedLocationName = address;
  //       _currentCity = city;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _selectedLocationName = 'Address not found';
  //       _currentCity = '';
  //     });
  //   }
  // }

  // String _parseCityFromAddress(String address) {
  //   // Implement parsing logic based on your address format
  //   // Example: "123 Main St, Anytown, CA 12345, United States"
  //   // Extract the city name (assuming it's the second last part)
  //   List<String> parts = address.split(',');
  //   return parts.length >= 3 ? parts[parts.length - 3].trim() : '';
  // }

  //FOR SUGGESTION BASED ON COUNTRY / REGION

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });

    await _updateAddress(_selectedLocation);
    await _updateRegionCode(position);
  }

  Future<void> _updateAddress(LatLng position) async {
    try {
      final address = await _locationService.getAddress(position);
      setState(() {
        _selectedLocationName = address;
      });
    } catch (e) {
      setState(() {
        _selectedLocationName = 'Address not found';
      });
    }
  }

  Future<void> _updateRegionCode(Position position) async {
    try {
      final address = await _locationService
          .getAddress(LatLng(position.latitude, position.longitude));
      // You may need to parse this address to get the correct region code
      final country = _parseCountryFromAddress(address);
      final regionCode = _mapCountryToRegionCode(country);
      print('Updated region code: $regionCode');
      setState(() {
        _regionCode = regionCode;
      });
    } catch (e) {
      setState(() {
        _regionCode = 'us';
      });
    }
  }

  String _parseCountryFromAddress(String address) {
    // Implement parsing logic based on your address format
    // Example: "123 Main St, Anytown, CA 12345, United States"
    return address.split(',').last.trim();
  }

  String _mapCountryToRegionCode(String country) {
    final countryToRegion = {
      'Pakistan': 'pk',
      'United States': 'us',
      'Canada': 'ca',
    };
    return countryToRegion[country] ?? 'us';
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _selectedLocation = position.target;
  }

  Future<void> _searchLocation(String location) async {
    try {
      final result = await _locationService.searchLocation(location);
      final lat = result['lat'];
      final lng = result['lng'];
      final name = result['name'];

      _mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(lat, lng),
      ));

      setState(() {
        _selectedLocation = LatLng(lat, lng);
        _selectedLocationName = name;
        _markers = {
          Marker(
            markerId: MarkerId('selected_location'),
            position: _selectedLocation,
            infoWindow: InfoWindow(title: _selectedLocationName),
          ),
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location not found')),
      );
    }
  }

  Future<void> _onSearchChanged() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      await _fetchSuggestions(query);
    } else {
      setState(() {
        _suggestions = [];
        _isSuggestionVisible = false;
      });
    }
  }

  Future<void> _searchLocationDialog() async {
    final location = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Location'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter location',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).pop(_searchController.text);
                },
              ),
            ),
          ),
        );
      },
    );

    if (location != null && location.isNotEmpty) {
      await _searchLocation(location);
    }
  }

//FOR SUGGESTION BASED ON CITY
  // Future<void> _fetchSuggestions(String query) async {
  //   try {
  //     final suggestions =
  //         await _locationService.searchSuggestions(query, _currentCity);
  //     setState(() {
  //       _suggestions = suggestions;
  //       _isSuggestionVisible = suggestions.isNotEmpty;
  //     });
  //   } catch (e) {
  //     print('Error fetching suggestions: $e');
  //     setState(() {
  //       _suggestions = [];
  //       _isSuggestionVisible = false;
  //     });
  //   }
  // }

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   super.dispose();
  // }

//FOR SUGGESTION BASED ON COUNTRY / REGION

  // Future<void> _fetchSuggestions(String query) async {
  //   try {
  //     final suggestions =
  //         await _locationService.searchSuggestions(query, _regionCode);
  //     setState(() {
  //       _suggestions = suggestions;
  //       _isSuggestionVisible = suggestions.isNotEmpty;
  //     });
  //   } catch (e) {
  //     print('Error fetching suggestions: $e');
  //     setState(() {
  //       _suggestions = [];
  //       _isSuggestionVisible = false;
  //     });
  //   }
  // }

  Future<void> _fetchSuggestions(String query) async {
  try {
    final suggestions =
        await _locationService.searchSuggestions(query, _regionCode);
    setState(() {
      _suggestions = suggestions;
      _isSuggestionVisible = suggestions.isNotEmpty;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching suggestions: $e')),
    );
    setState(() {
      _suggestions = [];
      _isSuggestionVisible = false;
    });
  }
}


  void _confirmLocation() {
    Navigator.pop(context, _selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final activeTabBackgroundColor =  isDarkMode ? Colors.grey.shade900 : Colors.black;
    final searchBarBackgroundColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final suggestionBackgroundColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final suggestionTextColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: textColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Text(
            'Pick your Location',
            style: TextStyle(color: textColor),
          ),
        ),
        toolbarHeight: kToolbarHeight,
        backgroundColor: Color.fromARGB(31, 172, 170, 170),
      ),

      // Google Maps as Base Layer
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  onCameraMove: (position) {
                    _onCameraMove(position);
                    _updateAddress(position.target);
                  },
                  markers: _markers,
                ),
          Center(
            child: CustomMarker(address: _selectedLocationName),
          ),
          if (_isSuggestionVisible)
            Positioned(
              top: 70,
              left: 16,
              right: 16,
              child: Container(
                height: 216.0,
                decoration: BoxDecoration(
                  color: suggestionBackgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: _suggestions.length,
                        separatorBuilder: (context, index) => Divider(
                          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                          height: 1.0,
                        ),
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_suggestions[index],
                            style: TextStyle(color: suggestionTextColor),
                            ),
                            onTap: () {
                              _searchController.text = _suggestions[index];
                              _searchLocation(_suggestions[index]);
                              setState(() {
                                _isSuggestionVisible = false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 8.0,
            left: 16.0,
            right: 60.0,
            child: Container(
              decoration: BoxDecoration(
                color: searchBarBackgroundColor,
                borderRadius: BorderRadius.circular(18.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _fetchSuggestions(value);
                  } else {
                    setState(() {
                      _suggestions = [];
                      _isSuggestionVisible = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search Location',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: textColor),
                    onPressed: () {
                      _searchLocation(_searchController.text);
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                style: TextStyle(color: textColor),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 80.0,
            right: 80.0,
            child: SizedBox(
              width: 190.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(33.0),
                child: Container(
                  color: Colors.grey.shade400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 13.5, horizontal: 11.0),
                    child: GNav(
                      backgroundColor: Colors.grey.shade400,
                      color: Colors.white,
                      activeColor: Colors.white,
                      tabBackgroundColor: activeTabBackgroundColor,
                      tabBorderRadius: 22.0,
                      padding:
                          EdgeInsets.symmetric(vertical: 13, horizontal: 11.0),
                      gap: 7,
                      selectedIndex: _selectedIndex,
                      tabs: [
                        GButton(
                          icon: Icons.cancel,
                          text: 'Dismiss',
                          iconColor: Colors.black,
                          iconSize: 25,
                          textColor: Colors.grey.shade500,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        GButton(
                          icon: Icons.check,
                          text: 'Confirm',
                          iconColor: Colors.grey.shade800,
                          iconSize: 25,
                          textColor: Colors.white,
                          onPressed: _confirmLocation,
                        ),
                      ],
                      onTabChange: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
