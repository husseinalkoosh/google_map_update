import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
class Drawer_Widget extends StatelessWidget {
  const Drawer_Widget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void showToast(String msg, {int duration, int gravity}) {
      Toast.show(msg, context, duration: duration, gravity: gravity);
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.3,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 80),
          children: <Widget>[
            ListTile(title: Text('Hussein Samir',style: TextStyle(fontSize: 20),),
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage(
                    "img/profile.jpg"),

              ),),
            Padding(padding: EdgeInsets.only(top: 40),),
            ListTile(
              title: Text('Your Trips',style: TextStyle(fontSize: 23,fontStyle: FontStyle.normal),),
              onTap: () {
                showToast("Your Trips", duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
               },
            ),
            ListTile(
              title: Text('Wallet',style: TextStyle(fontSize: 23),),
              onTap: () {
                showToast("Wallet", duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);

              },
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left:10,right: 10),
                child: Container(


                  decoration: new BoxDecoration(
                    color: Colors.lightGreen[100],
                    borderRadius: new BorderRadius.all(
                       const Radius.circular(15.0),

                    )),child: Center(child: Text('0 EGP',style: TextStyle(color: const Color(0xff2B6F53),fontSize: 16),)),
                ),
              ),
              leading: Text('Payment',style: TextStyle(fontSize: 23),),

              onTap: () {
                showToast("Payment 0 EGP", duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);

              },
            ),
            ListTile(
              title: Text('Free Rides',style: TextStyle(fontSize: 23,color: Colors.red),),
              onTap: () {
                showToast("Free Rides", duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);

              },
            ),
            ListTile(
              title: Text('Settings',style: TextStyle(fontSize: 23),),
              onTap: () {
                showToast("Settings", duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);

              },
            ),
            ListTile(
              title: Text('Help',style: TextStyle(fontSize: 23),),
              onTap: () {
                showToast("Help", duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);

              },
            ),
          ],
        ),
      ),
    );
  }
}
