import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:product_api/product.dart';
import 'package:http/http.dart' as http;

class first extends StatefulWidget {
  const first({super.key});

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  Future getHttp() async {
    var url = Uri.https('dummyjson.com', 'products');
    var response = await http.get(url);
    Map m = jsonDecode(response.body);
    return m;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getHttp();
  }

  @override
  Widget build(BuildContext context) {
    // product p = ModalRoute.of(context)!.settings.arguments as product;

    return Scaffold(
        appBar: AppBar(title: Text("Product List")),
        body: FutureBuilder(
          future: getHttp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("object");
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                Map m = snapshot.data;
                List l = m['products'];
                return ListView.builder(
                  itemCount: l.length,
                  itemBuilder: (context, index) {
                    product s = product.fromJson(l[index]);
                    print("${s}");
                    return Card(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        // decoration: BoxDecoration(
                        //     border:
                        //         Border.all(style: BorderStyle.solid, width: 2),
                        //     borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Column(children: [
                          Text("${s.category}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          GFListTile(onTap: () {
                            print("${s.id}");
                            Navigator.pushNamed(context, "details",arguments: s);
                          },
                            avatar: GFAvatar(
                              backgroundImage: NetworkImage("${s.thumbnail}"),
                              shape: GFAvatarShape.standard,
                              size: 80,
                            ),
                            titleText: '${s.title}',
                            subTitle: Text("₹ ${s.price}"),
                            description: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  maxLines: 3,
                                  '${s.description}',
                                  style: TextStyle(
                                      color: Colors.black38,
                                      decorationStyle:
                                          TextDecorationStyle.dashed),
                                ),
                                // GFRating(
                                //   size: 12,
                                //   value: s.rating,
                                //   onChanged: (value) {
                                //     s.rating = value;
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text("data"),
                );
              }
            }
          },
        ),);
  }
}
