import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:epicture/views/HomeView.dart';
import 'package:epicture/views/SearchView.dart';
import 'package:epicture/views/NewView.dart';
import 'package:image_picker/image_picker.dart';
import 'package:epicture/views/LoginView.dart';
import 'package:epicture/views/ProfileView.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class NavigationBarWidget extends StatefulWidget {
    bool byPassLogin = false;

    NavigationBarWidget({Key key, this.byPassLogin}) : super(key: key);

    @override
    _NavigationBarWidgetState createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
    int selectedIndex = 0;
    List<String> pageNames = ["Epicture", "Search", "Profile"];
    List<Widget> widgetOptions = <Widget>[
        HomeView(),
        SearchView(),
        ProfileView(),
    ];
    bool loggedOut = false;

    void _onItemTapped(int index) {
        setState(() {
            selectedIndex = index;
        });
    }

    Widget defaultAppBar(BuildContext context) {
        return PreferredSize(
            preferredSize: Size.fromHeight(40),               //taille hauteur topbar
            child: AppBar(
                backgroundColor: Color(0xFF1BB76E),          // couleur de l'appbar
                title: Text(pageNames[selectedIndex]),
                centerTitle: true,
            ),
        );
    }

    Widget profileAppBar(BuildContext context) {            //taille hauteur topbar
        return PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: AppBar(
                backgroundColor: Color(0xFF34373C),       // couleur de l'appbar
                title: Text(pageNames[selectedIndex]),
                centerTitle: true,
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.forward, color: Colors.white60),
                        onPressed: () {
                            setState(() {
                              this.loggedOut = true;
                            });
                        }
                    )
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        if (this.loggedOut == true && this.widget.byPassLogin == false) {
            return LoginView();
        }
        return Scaffold(
            backgroundColor: Color(0xFF34373C),
            resizeToAvoidBottomInset: false,
            appBar: (selectedIndex == 2) ? profileAppBar(context) : defaultAppBar(context),
            body: Center(
                child: widgetOptions.elementAt(selectedIndex),
            ),
            bottomNavigationBar: CurvedNavigationBar(     // notre super bottombar blob
              backgroundColor: Color(0xFF0A3E25),            // https://pub.dev/packages/curved_navigation_bar
              animationDuration: const Duration(milliseconds: 200),
              color: Color(0xFF1BB76E),
              height: 50,
              items: <Widget>[
              Icon(Icons.home, size: 30, color: Color(0xFF0A3E25)), //bouton home
              Icon(Icons.search, size: 30, color: Color(0xFF0A3E25)), //bouton search
              Icon(Icons.person, size: 30, color: Color(0xFF0A3E25)), //bouton profile
              ],
              onTap: _onItemTapped,
              ),
            floatingActionButton: SpeedDial(        //bouton pour upload une image
                marginRight: 10,                    //espace de droite du bouton pour upload une image
                marginBottom: 20,                   //espace inférieur du bouton pour upload une image
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                closeManually: false,
                curve: Curves.bounceIn,
                overlayColor: Color(0xFF34373C),          //couleur de l'ombre lors de l'appuie sur le bouton d'upload (shadow effect)
                overlayOpacity: 0,                        //opacité de l'ombre (actuellement désactivée)
                backgroundColor: Color(0xFF1BB76E),         // couleur du bouton d'upload
                foregroundColor: Color(0xFF34373C),        // couleur du picto du bouton d'upload
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                    SpeedDialChild(
                        child: Icon(Icons.camera_alt),
                        backgroundColor: Color(0xFF1BB76E), //couleur du bouton appareil photo
                        foregroundColor: Color(0xFF0A3E25), //couleur de l'icône appareil photo
                        onTap: () async {
                            var image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);

                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => NewView(imageData: image)
                                
                            ));
                        }
                    ),
                    SpeedDialChild(
                        child: Icon(Icons.image),
                        backgroundColor: Color(0xFF1BB76E), //couleur du bouton appareil photo
                        foregroundColor: Color(0xFF0A3E25), //couleur de l'icône album photo
                        onTap: () async {
                            var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);

                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => NewView(imageData: image)
                            ));
                        }
                    )
                ],
            ),
       );
    }
}
