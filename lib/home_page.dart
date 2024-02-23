import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:http/http.dart' as http;
import 'package:quotes_app/quotes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List? imageList;
  int? imageNumber = 0;

  var accessKey = 'MbZbkfNxlT8QP74gQvIXJoNT8YnBP32qw9L7d8VxZ-M';
  @override
  void initState() {
    super.initState();
    getImagesFromUnsplash();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: imageList != null
          ? Stack(
              children: [
                AnimatedSwitcher(
                  duration: Duration(seconds: 1),
                  child: BlurHash(
                    key: ValueKey(imageList?[imageNumber!]['blur_hash']),
                    hash: imageList![imageNumber!]['blur_hash'],
                    duration: Duration(milliseconds: 500),
                    image: imageList![imageNumber!]['urls']['regular'],
                    curve: Curves.easeInOut,
                    imageFit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: width,
                  height: height,
                  color: Colors.black.withOpacity(0.6),
                ),
                Container(
                  width: width,
                  height: height,
                  child: SafeArea(
                    child: CarouselSlider.builder(
                      itemCount: quotesList.length,
                      itemBuilder: (context, index1, index2) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                quotesList[index1][kQuote],
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Ubuntu',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              '- ${quotesList[index1][kAuthor]} -',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Ubuntu',
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        scrollDirection: Axis.vertical,
                        pageSnapping: true,
                        initialPage: 0,
                        enlargeCenterPage: true,
                        onPageChanged: (index, value) {
                          HapticFeedback.lightImpact();
                          imageNumber = index;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 50,
                    right: 30,
                    child: Row(
                      children: [
                        Text(
                          '${imageList![imageNumber!]['user']['username']}',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Ubuntu',
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          ' On ',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Ubuntu',
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Unsplash',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Ubuntu',
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ))
              ],
            )
          : Container(
              width: width,
              height: height,
              // child: Container(
              //   width: 100,
              //   height: 100,
              //   child: SpinKitFadingCircle(
              //       color: Colors.amber,
              //       duration: const Duration(milliseconds: 1200)),
              // ),
            ),
    );
  }

  void getImagesFromUnsplash() async {
    var url =
        'https://api.unsplash.com/search/photos?per_page=30&query=nature&order_by=relevant&client_id=$accessKey';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    print(response.statusCode);
    var unsplashData = json.decode(response.body);
    imageList = unsplashData['results'];
    print(unsplashData);
  }
}
