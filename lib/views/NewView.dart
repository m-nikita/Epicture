import 'package:flutter/material.dart';
import 'dart:io';
import 'package:epicture/Image.dart' as ImgurImage;
import 'dart:ui';

class NewView extends StatefulWidget {
    final File imageData;

    NewView({Key key, this.imageData}) : super(key: key);

    @override
    _NewView createState() => _NewView();
}

class _NewView extends State<NewView> with SingleTickerProviderStateMixin {
    bool isUploading = false;
    Animation<double> isAnimated;
    AnimationController animationController;

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        if (this.widget.imageData == null) {
            Navigator.pop(context);
        }
        return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: AppBar(
                    backgroundColor: Colors.black,
                    title: Text("New"),
                    centerTitle: true,
                ),
            ),
            body: createView(context),
        );
    }

    Widget createView(BuildContext context) {
        if (this.isUploading == false) {
            return SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                        createImageUpload(context),
                        createImageUploadInformation(context)
                    ],
                ),
            );
        } else {
            return Column(
                children: <Widget>[
                    Stack(
                        children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(25),
                                child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    elevation: 7,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Image.file(
                                        this.widget.imageData,
                                    ),
                                ),
                            ),
                            Positioned(
                                left: MediaQuery.of(context).size.width / 2 - 20,
                                top: MediaQuery.of(context).size.height / 2 - 180,
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                    child: CircularProgressIndicator(),
                                ),
                            )
                        ],
                    ),
                    Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
                        // child: AnimatedDefaultTextStyle(
                        //     duration: Duration(milliseconds: 200),
                        //     style: (this.isAnimated.value >= 22) ? TextStyle(
                        //         fontSize: this.isAnimated.value,
                        //         color: Colors.lightBlueAccent
                        //     ) : TextStyle(
                        //         fontSize: this.isAnimated.value,
                        //         color: Colors.blueAccent
                        //     ),
                        // )
                    )
                ],
            );
        }
    }

    Widget createImageUploadInformation(BuildContext context) {
        return Container(
            padding: EdgeInsets.all(10),
            child: Column(
                children: <Widget>[
                    Container(
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Titre :",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(),
                                ),
                            ),
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Description :",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(),
                                )
                            ),
                        ),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                                Container(
                                    child: IconButton(
                                        icon: Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
                                        onPressed: () {
                                            setState(() {
                                              this.isUploading = true;
                                            });
                                            ImgurImage.Image().uploadImage({
                                                "image": this.widget.imageData,
                                                "title": "",
                                                "description": ""
                                            }).then((Map<String, dynamic> json) {
                                                setState(() {
                                                    this.isUploading = false;
                                                });
                                                Navigator.pop(context);
                                            });
                                        },
                                    ),
                                ),
                                Container(
                                    child: IconButton(
                                        icon: Icon(Icons.cancel, size: 60, color: Colors.red[800]),
                                        onPressed: () {
                                            Navigator.pop(context);
                                        },
                                    ),
                                )
                            ],
                        ),
                    )
                ],
            ),
        );
    }

    Widget createImageUpload(BuildContext context) {
        return Container(
            padding: EdgeInsets.all(25),
            child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 7,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Image.file(
                    this.widget.imageData,
                ),
            ),
        );
    }
}
