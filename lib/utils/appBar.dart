import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final VoidCallback onMenuTap;
  CustomAppBar({required this.onMenuTap});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: widget.onMenuTap),
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 30,
          ),
          Spacer(),
          Text(
            "India",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          SizedBox(width: 5),
          Icon(Icons.location_on, color: Colors.black),
          SizedBox(width: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            ),
            child: Text(
              "Login",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
