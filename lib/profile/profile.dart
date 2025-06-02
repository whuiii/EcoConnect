import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigate/color.dart';
import 'package:navigate/profile/editProfile.dart';
import 'package:navigate/mainpage.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('assets/images/EcoConnect_Logo.png'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child:Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade300, // color of the circle
                      ),
                      child: Icon(Icons.edit, size: 18, color: Colors.grey.shade800,),
                    ),),

                  ],
                ),
                SizedBox(height: 10,),
                Text("EcoConnect",
                  style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700),),
                Text("Bio Data: Recycle, Reuse, Reduce",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                SizedBox(height: 20,),
                SizedBox(width: 200,
                  child: MaterialButton(onPressed: (){
                    // Edit Profile
                    Get.to(EditProfile());
                  },
                    color: button,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  child: Text("Edit Profile",
                    style: TextStyle(fontSize: 16, color: Colors.white),),),),
                SizedBox(height: 30,),
                const Divider(), // a line of divider
                SizedBox(height: 10,),
                ProfileMenuWidget(title: "Settings",icon: Icons.settings,onPress: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile()));
                },),
                const Divider(),
                SizedBox(height: 10,),
                ProfileMenuWidget(
                    title: "About Us",
                    icon: Icons.info,
                    onPress: (){}),
                ProfileMenuWidget(
                    title: "Rating",
                    icon: Icons.star,
                    onPress: (){}),

                ProfileMenuWidget(
                  title: "Logout",
                  icon: Icons.logout_rounded,
                  textColor: Colors.red,
                  endIcon: false, // does not have the right arrow
                  onPress: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MainPage()));
                },),
                
              ],
            ),
              ),
        )

      ),
    );
  }

  //
  Widget topContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.20,
      padding: EdgeInsets.only(left: 16, bottom: 15, top: 20),
      color: Colors.green.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back),
          ),
          Spacer(),
          Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    //super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }): super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,height: 40, // size of the circle
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: button, // not sure function
        ),
        child: Icon(icon, color: Colors.white,size: 30,), //size of the icon
      ),
      title: Text(title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: textColor),),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.shade300, // color of the circle
        ),
        child: Icon(Icons.keyboard_arrow_right, size: 18, color: Colors.grey.shade800,),
      ): null,
    );
  }
}
