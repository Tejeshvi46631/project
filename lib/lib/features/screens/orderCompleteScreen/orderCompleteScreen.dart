import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/widgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// for product cart

class Slider extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productPrice;

  Slider({
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin:EdgeInsets.all(15.0),
      width: 200, // Set a fixed width for each ProductCard
      margin: const EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            width: 200,
            height: 120, // Adjust the height as needed
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(productName, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(productPrice, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class HorizontalScrollingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Slider(
            imageUrl:
                'https://www.cookwithkushi.com/wp-content/uploads/2022/10/motichoor_ladoo_indian_sweet_03.jpg',
            productName: 'Ladoo',
            productPrice: '₹10',
          ),
          Slider(
            imageUrl:
                'https://vcard-bucket.s3.us-east-2.amazonaws.com/A12/2621/1654496559703.png',
            productName: 'Prashad',
            productPrice: '₹20',
          ),
          Slider(
            imageUrl:
                'https://media.istockphoto.com/id/506620395/photo/pakistani-mithai.jpg?s=1024x1024&w=is&k=20&c=iaFkyyXipnXPtpTThTDujYWAU6KNTZYNNyGVqT52RVw=',
            productName: 'mithayi',
            productPrice: '₹30',
          ),
          Slider(
            imageUrl:
                'https://www.shutterstock.com/shutterstock/photos/2192693269/display_1500/stock-photo-indian-namkeen-snacks-served-in-traditional-namkeen-food-mixture-peanuts-indian-spicy-snacks-2192693269.jpg',
            productName: 'Namkeen',
            productPrice: '₹40',
          ),
          Slider(
            imageUrl:
                'https://freepngimg.com/thumb/ice_cream/8-2-ice-cream-picture.png',
            productName: 'Icecream',
            productPrice: '₹50',
          ),
        ],
      ),
    );
  }
}

class OrderCompleteScreen extends StatefulWidget {
  // Map<String, String> params = {};
  // OrderCompleteScreen({super.key,required this.params});

  @override
  State<OrderCompleteScreen> createState() => _OrderCompleteScreenState();
}

class _OrderCompleteScreenState extends State<OrderCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            // Search bar in the app bar
            Center(
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Handle search functionality
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return (cartProvider.cartState == CartState.initial ||
                    cartProvider.cartState == CartState.loading)
                ? getCartListShimmer(
                    context: context,
                  )
                : (cartProvider.cartState == CartState.loaded)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                            margin: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(248, 255, 255, 255),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "",
                                  // 'Order ID: '+cartProvider.cartData.data.cart.first,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(209, 11, 0, 0)),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Payment Mode: COD',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color.fromARGB(255, 51, 48, 48)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                            margin: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(248, 255, 255, 255),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
// Text for Product Details
                                const Text(
                                  'Product Details',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
// Order Tracking Title
                                Container(
                                  height: 80,
                                  padding: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
// Left side - Product Image
                                      Container(
                                        width: 60.0,
                                        height: 60.0,
                                        margin:
                                            const EdgeInsets.only(right: 16.0),
                                        decoration: BoxDecoration(
// Replace with your image or placeholder
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade100,
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                'https://www.cookwithkushi.com/wp-content/uploads/2022/10/motichoor_ladoo_indian_sweet_03.jpg'),
                                            fit: BoxFit
                                                .cover, // Adjust the BoxFit property based on your needs
                                          ),
                                        ),
                                      ),
// Right side - Product Information
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Ladoo',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              'Size: 500g',
                                            ),
                                            Text('Quantity: 1'),
// Add more product information as needed
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
// Horizontal Line for Separation
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  height: 1.0,
                                  color: const Color.fromARGB(255, 83, 82, 82),
                                ),
// Text for Track Order
                                const Text(
                                  'Order Tracking',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
// Track Order Button
                                ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color: Colors.black)))),
                                  onPressed: () {
// Handle track order functionality
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Track Order',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 16),
                                        )
                                      ]),
                                ),
                                const SizedBox(
                                  height: 4.0,
                                  width: 10,
                                ),
// Container for Product Image and Information
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
                            margin: const EdgeInsets.fromLTRB(6, 2, 6, 4),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(248, 255, 255, 255),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
// Handle download invoice functionality
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Download Invoice',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.all(10.0),
                              color: Colors.white,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      'Order Details',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Price Details(1 Item)',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
// const SizedBox(height: 8),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Total Price',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey)),
                                        Text('₹320',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Delivery charges',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey)),
                                        Text('₹40',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey))
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Taxes',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey)),
                                        Text('₹14',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey))
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Total Discounts',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green)),
                                        Text('- ₹42',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green))
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Order Total',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text('₹332',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      color: Colors.green[100],
                                      child: const Row(
                                        children: <Widget>[
                                          Icon(Icons.star, color: Colors.green),
                                          SizedBox(width: 8),
                                          Center(
                                            child: Text(
                                              'Yay! Your total discount is ₹42',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 3, 3, 3)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(6, 4, 6, 4),
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Delivery Address',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            'eharshal\n13B Ashok Nagar Near LIC Colony Ashok Nagar\nDhule-424001 India\n8999322698',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Text("Season's best seller",
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.black)),
                                    const SizedBox(height: 16),
                                    HorizontalScrollingContainer(),
                                  ])) // Your scrollable content goes here
                        ],
                      )
                    : DefaultBlankItemMessageScreen(
                        title: getTranslatedValue(
                          context,
                          "lblEmptyCartListMessage",
                        ),
                        description: getTranslatedValue(
                          context,
                          "lblEmptyCartListDescription",
                        ),
                        btntext: getTranslatedValue(
                          context,
                          "lblEmptyCartListButtonName",
                        ),
                        callback: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            mainHomeScreen,
                            (Route<dynamic> route) => false,
                          );
                        },
                        image: "no_product_icon",
                      );
          },
        )));
  }
}

getCartListShimmer({required BuildContext context}) {
  return ListView(
    children: List.generate(10, (index) {
      return const Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
        child: CustomShimmer(
          width: double.maxFinite,
          height: 125,
        ),
      );
    }),
  );
}
