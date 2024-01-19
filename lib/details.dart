import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:product_api/product.dart';
import 'package:http/http.dart' as http;

class details extends StatefulWidget {
  const details({super.key});

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  Future getHttp() async {
    var url = Uri.https('dummyjson.com', 'products');
    var response = await http.get(url);
    Map m = jsonDecode(response.body);
    return m;
  }

  late List<String> imageList = [];

  @override
  Widget build(BuildContext context) {
    product p = ModalRoute.of(context)!.settings.arguments as product;

    dynamic orignal_price =
        (p.price! / (1 - p.discountPercentage! / 100)).floor() as dynamic;
    print(orignal_price);

    int a = p.images!.length;
    for (int i = 1; i < a; i++) {
      imageList.add("https://cdn.dummyjson.com/product-images/${p.id}/$i.jpg");
    }
    // final List<String> imageList = [
    //
    //
    //   // "https://cdn.dummyjson.com/product-images/${p.id}/1.jpg",
    //   "https://cdn.dummyjson.com/product-images/${p.id}/2.jpg",
    //   "https://cdn.dummyjson.com/product-images/${p.id}/3.jpg",
    //   "https://cdn.dummyjson.com/product-images/${p.id}/4.jpg",
    //   "https://cdn.dummyjson.com/product-images/${p.id}/thumbnail.jpg"
    // ];
    return Scaffold(
      appBar: AppBar(title: Text("${p.title}")),
      body: FutureBuilder(
        future: getHttp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.redAccent,
                            ),
                          ],
                        ),
                      ),  
                      GFCarousel(
                        height: 400,
                        items: imageList.map(
                          (url) {
                            return Container(
                              margin: EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                child: Image.network(url,
                                    fit: BoxFit.cover, width: 600.0),
                              ),
                            );
                          },
                        ).toList(),
                        onPageChanged: (index) {
                          // setState(() {
                          //   index;
                          // });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text("${p.title}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("₹${orignal_price}   ",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 18,
                                  color: Colors.black38)),
                          Text("₹${p.price}  ",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          Text("${p.discountPercentage}% OFF",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                        ],
                      ),
                      GFRating(
                        size: 20,
                        value: p.rating,
                        onChanged: (value) {
                          p.rating = value;
                        },
                      ),
                      Container(
                          height: 50,
                          color: Colors.green,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart),
                              Text("ADD TO CART",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          )),
                      Container(margin: EdgeInsets.all(50),alignment: Alignment.center,
                        child: Text(
                          "${p.description}",
                          style: TextStyle(fontSize: 15,wordSpacing: 5,),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Text(" no data");
            }
          }
        },
      ),
    );
  }
}
