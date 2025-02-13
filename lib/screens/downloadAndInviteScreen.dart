import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadInviteWidget extends StatelessWidget {
  final String playStoreLink =
      "https://play.google.com/store/apps/details?id=com.oruphones";
  final String appStoreLink =
      "https://apps.apple.com/app/oruphones/id123456789";

  void openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Link copied to clipboard!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          color: Colors.amber,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Text(
                "Get Notified About Our Latest Offers and Price Drops",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter your email here",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.circular(25), // Rounded button
                        ),
                        child: const Text(
                          "Send",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

        SizedBox(
          height: 700,
          child: Stack(
            clipBehavior: Clip.none,
            children: [

              Container(
                color: Colors.black87,
                padding: EdgeInsets.symmetric(vertical: 20),
                height: 600,
                child: Column(
                  children: [
                    Text(
                      "Download App",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.black, width: 5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  "assets/images/qr_code_android_new.png",
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 150,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              child: Image.asset("assets/images/play_store.png",
                                  width: 40),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.black, width: 5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  "assets/images/qr_code_ios_new.png",
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 150,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Icon(Icons.apple, color: Colors.white, size: 40),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 130,
                    ),
                    Text(
                      "Invite a Friend",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),


              Positioned(
                top: 480,
                left: MediaQuery.of(context).size.width *
                    0.10, // Center horizontally
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width / 1.4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Invite a friend to ORUphones application.\nTap to copy the respective download link to the clipboard.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: 12),


                      GestureDetector(
                        onTap: () => openUrl(playStoreLink),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset("assets/images/google_play.png",
                                width: 120)),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => openUrl(appStoreLink),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset("assets/images/app_store.png",
                                width: 120)),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 20,
        ),

        Text("Or Share", style: TextStyle(fontSize: 18, color: Colors.black)),

        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 10),
            Image.asset("assets/images/instagram.png", width: 40),
            SizedBox(width: 10),
            Image.asset("assets/images/telegram.png", width: 40),
            SizedBox(width: 10),
            Image.asset("assets/images/twitter.png", width: 40),
            SizedBox(width: 10),
            Image.asset("assets/images/watsapp.png", width: 40),
            SizedBox(width: 10),
          ],
        ),

        SizedBox(
          height: 70,
        )
      ],
    );
  }
}
