import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minifridge_app/screens/add_item/upload_status.dart';
import 'package:minifridge_app/providers/image_picker_notifier.dart';
import 'package:minifridge_app/providers/auth_notifier.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class ImageUploadPage extends StatelessWidget {
  static final routeName = '/image';

  @override
  Widget build(BuildContext context) {

    return Consumer2(
        builder: (BuildContext context, ImagePickerNotifier picker, AuthNotifier user, _) {
          final double height = MediaQuery.of(context).size.height - 200;

          return Scaffold (
            appBar: AppBar(
              title: Text('${picker.images.length } photo(s) selected', style: TextStyle(color: Colors.black))
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (!picker.uploading())
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => picker.clear()
                    ),
                  if (!picker.uploading())
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => picker.startUpload(user.user.uid)
                    ),
                ]
              )
            ),
            body: Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: height,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      picker.setCurrent(index);
                    }
                  ),
                  items: picker.bytes.map((item) {
                    return Container(
                      child: Center(
                        child: Image.memory(item.buffer.asUint8List(), fit: BoxFit.cover, height: height)
                      )
                    );
                  }).toList()
                ),
                UploadStatus(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text("Please ensure receipt fills most of image"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: picker.images.map((img) {
                              int index = picker.images.indexOf(img);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: picker.current == index
                                    ? Color.fromRGBO(0, 0, 0, 0.9)
                                    : Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    )
                  ],
                )
              ],
            )
          );
        }
      );
  }
}