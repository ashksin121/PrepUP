import 'package:flutter/material.dart';

class Bazaar extends StatefulWidget {
  @override
  _BazaarState createState() => _BazaarState();
}

class _BazaarState extends State<Bazaar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              item(
                  'https://images-na.ssl-images-amazon.com/images/I/61T7vSMjrAL._AC_SX425_.jpg',
                  'Amazon Kindle',
                  'SOON'),
              item(
                  'https://images-na.ssl-images-amazon.com/images/G/01/audiblemobile/store/image/favicons/icons310px.png',
                  'Audible',
                  'ACTIVE'),
              item(
                  'https://cdn.shopify.com/s/files/1/0057/8938/4802/products/1neon_eb475e1c-ea69-458d-84b7-9312355e80a8.png?v=1587724180',
                  'Boat Headphones',
                  'ACTIVE'),
            ],
          ),
        ),
      ),
    );
  }
}

Widget item(String imageURL, String name, String status) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Flexible(
            child: Image.network(
              imageURL,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(name, style: TextStyle(fontSize: 17)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  child: Text(status),
                  color: (status == 'SOON') ? Colors.grey : Colors.green,
                  onPressed: () {},
                ),
                CircleAvatar(
                  child: Icon(Icons.bookmark_border),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}
