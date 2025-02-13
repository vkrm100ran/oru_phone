import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oru_phones/provider/filterProvider.dart';
import 'package:oru_phones/provider/homeProvider.dart';
import 'package:oru_phones/provider/likeProvider.dart';
import 'package:oru_phones/provider/sort_provider.dart';
import 'package:oru_phones/provider/userProvider.dart';
import 'package:oru_phones/screens/FAQScreen.dart';
import 'package:oru_phones/screens/downloadAndInviteScreen.dart';
import 'package:oru_phones/screens/filterBottomSheet.dart';
import 'package:oru_phones/screens/profileScreen.dart';
import 'package:oru_phones/screens/sortBottomSheet.dart';
import 'package:oru_phones/utils/appBar.dart';
import 'package:oru_phones/utils/productGrid.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Item> faqData = [
    Item(
      header: "Why should you buy used phones on ORUphones?",
      body:
          "Buying used phones on ORUphones ensures quality-checked, affordable devices with verified sellers.",
    ),
    Item(
      header: "How to sell phone on ORUphones?",
      body:
          "You can sell used phones online through ORUphones in 3 easy steps.\n\n"
          "**Step 1: Add your Device**\n"
          "Click on the 'Sell Now' button available at the top right corner of the ORUphones homepage, select your location, enter the mobile details on the listing page, and enter your expected price for the device.\n\n"
          "**Step 2: Device Verification**\n"
          "After listing your device, we recommend you verify your device to sell it quickly. To verify your device, download the ORUphones app on the device you want to sell. Follow the simple instructions in the app & perform diagnostics to complete the verification process. After verification, a 'verified' badge will be displayed along with your listing.\n\n"
          "**Step 3: Get Cash**\n"
          "You will start receiving offers for your listing. If the offer is right, you can arrange a meet-up with the buyer at a secure location. The buyer will go through a buyer verification process on the ORUphones app & if satisfied, you can conclude the deal and get instant payment from the buyer directly.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.loadInitialData();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print("home screen ----------     rebuild    -----------------");
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
            ),
            Spacer(),
            Text("India", style: TextStyle(color: Colors.black, fontSize: 16)),
            SizedBox(width: 5),
            Icon(Icons.location_on_outlined, color: Colors.black),
            SizedBox(width: 15),
            Consumer<UserProvider>(builder: (context, user, child) {
              return user.sessionCookie == null || user.sessionCookie.isEmpty
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      ),
                      child:
                          Text("Login", style: TextStyle(color: Colors.black)),
                    )
                  : Text("");
            })
          ],
        ),
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search phones with make, model...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryButton('Sell Used Phones'),
                      _buildCategoryButton('Buy Used Phones'),
                      _buildCategoryButton('Compare Prices'),
                      _buildCategoryButton('My Profile'),
                      _buildCategoryButton('My Listings'),
                      _buildCategoryButton('Services'),
                      _buildCategoryButton('Register your Store'),
                      _buildCategoryButton('Get the App'),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildBanner("assets/images/Banner 1.png"),
                      _buildBanner("assets/images/Banner 2.png"),
                      _buildBanner("assets/images/Banner 3.png"),
                      _buildBanner("assets/images/Banner 4.png"),
                      _buildBanner("assets/images/Banner 5.png"),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text('What’s on your mind?',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                _buildFeatureIcons(),
                SizedBox(height: 20),
                Text('Top brands',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                _buildBrandLogos(),
                SizedBox(height: 10),
                ProductGrid(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: FAQWidget(faqItems: faqData),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: DownloadInviteWidget(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement sell action
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.black, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.amber, width: 3),
                  ),
                  elevation: 10, // Shadow effect
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Sell",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.add, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text, style: TextStyle(color: Colors.black, fontSize: 15)),
      ),
    );
  }

  Widget _buildBanner(String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          width: MediaQuery.of(context).size.width * 0.9,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFeatureIcons() {
    List<Map<String, String>> features = [
      {'icon': 'assets/images/Buy_used_phones.png', 'label': 'Buy Used Phones'},
      {
        'icon': 'assets/images/Sell_Used_Phones.png',
        'label': 'Sell Used Phones'
      },
      {'icon': 'assets/images/compare_prices.png', 'label': 'Compare Prices'},
      {'icon': 'assets/images/my_profile.png', 'label': 'My Profile'},
      {'icon': 'assets/images/my_listings.png', 'label': 'My Listings'},
      {'icon': 'assets/images/open_store.png', 'label': 'Open Store'},
      {'icon': 'assets/images/services.png', 'label': 'Services'},
      {
        'icon': 'assets/images/device_health_check.png',
        'label': 'Device Health Check'
      },
      {
        'icon': 'assets/images/battery_health_check.png',
        'label': 'Battery Health Check'
      },
      {
        'icon': 'assets/images/imei_verification.png',
        'label': 'IMEI Verification'
      },
      {'icon': 'assets/images/device_details.png', 'label': 'Device Details'},
      {'icon': 'assets/images/data_wipe.png', 'label': 'Data Wipe'},
      {
        'icon': 'assets/images/under_warrenty_phones.png',
        'label': 'Under Warrenty Phones'
      },
      {'icon': 'assets/images/premium_phones.png', 'label': 'Premium Phones'},
      {'icon': 'assets/images/like_new_phones.png', 'label': 'Like New Phones'},
      {
        'icon': 'assets/images/refurbished_phones.png',
        'label': 'Refurbished Phones'
      },
      {'icon': 'assets/images/verified_phones.png', 'label': 'Verified Phones'},
      {'icon': 'assets/images/my_negotiations.png', 'label': 'My Negotiations'},
      {'icon': 'assets/images/my_favourites.png', 'label': 'My Favourites'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: features.map((feature) {
          return Column(
            children: [
              Container(
                height: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: Image.asset(feature['icon']!, height: 80),
                ),
              ),
              SizedBox(height: 5),
              Container(
                  width: 75,
                  child: Text(feature['label']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12))),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBrandLogos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              if (homeProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (homeProvider.brands.isEmpty) {
                return Center(child: Text("No brands available"));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeProvider.brands.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.network(
                            homeProvider.brands[index]['imagePath'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.image, size: 70, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) => ChangeNotifierProvider.value(
                      value: Provider.of<SortProvider>(context, listen: false),
                      child: SortBottomSheet(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.swap_vert,
                  size: 16,
                  color: Colors.black,
                ),
                label: Text(
                  "Sort",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) {
                      return Consumer<FilterProvider>(
                        builder: (context, filterProvider, child) {
                          return FilterBottomSheet();
                        },
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.filter_list,
                  size: 16,
                  color: Colors.black,
                ),
                label: Text(
                  "Filters",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
