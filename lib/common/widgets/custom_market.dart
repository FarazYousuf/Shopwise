import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  final String address;

  CustomMarker({required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 250, 
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              address,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13, 
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        SizedBox(height: 4),
        Icon(
          Icons.location_on_sharp,
          size: 40, 
          color: Colors.black,
        ),
      ],
    );
  }
}