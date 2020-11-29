import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_final/homepage.dart';
import 'package:tiktok_final/signuppage.dart';
import 'package:tiktok_final/variables.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool isSigned = false;

//to send the app to homepage after signed is true
  initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen(
            (user)
        {
          if(user != null)
          {
            setState(() {
              isSigned = true;
            });
          }
          else{
            setState(() {
              isSigned = false;
            });
          }

        });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSigned == false ? Login():HomePage(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to TikTok",style: mystyle(25,Colors.black,FontWeight.w600),),
            SizedBox(height: 10,),
            Text("Login",style: mystyle(25,Colors.black,FontWeight.w600),),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20.00,right: 20.0),
              child: TextField(
                controller: emailcontroller,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Email',
                  labelStyle: mystyle(20),
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  )
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20.00,right: 20.0),
              child: TextField(
                controller: passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Password',
                    labelStyle: mystyle(20),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    )
                ),
              ),
            ),
            SizedBox(height: 10.00,),
            InkWell(
              onTap: (){
               try{
                 FirebaseAuth.instance.signInWithEmailAndPassword(
                     email: emailcontroller.text,
                     password: passwordcontroller.text);
               }catch(e){
                 SnackBar snackBar = SnackBar(
                     content: Text("Try again email or password are wrong"));
                 Scaffold.of(context).showSnackBar(snackBar);
               }
              },
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Center(
                  child: Text("Login",style: mystyle(20,Colors.white,FontWeight.w700),),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account?",style: mystyle(20),),
                SizedBox(width: 10,),
                InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => signuppage())),
                    child: Text("Register",style: mystyle(20,Colors.purple),))
              ],
            )
          ],
        ),
      ),

    );
  }
}

