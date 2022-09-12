import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/777.jpg"),
          fit: BoxFit.fill,
        ),
      ),

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(' About - Developer '),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/images/444.png'),
                      fit: BoxFit.fill
                  ),
                ),
              ),


              SizedBox(
                height: 20,
              ),
              Text('Rishi Raj', style: TextStyle(
                fontSize: 30,
                color: Colors.white
              ),),

              SizedBox(
                height: 100,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                  onTap: () async {
                    // final url = Uri.parse('https://www.instagram.com/_rishi_ryan_/');
                    // await launchUrl(url);
                    await launch('https://www.instagram.com/_rishi_ryan_/');

                  },

                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/insta.png'),
                            fit: BoxFit.fill
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () async {
                      // final url = Uri.parse('https://www.linkedin.com/in/rishi-raj-32648a196/');
                      // await launchUrl(url);
                      await launch('https://www.linkedin.com/in/rishi-raj-32648a196/');

                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/link.jpg'),
                            fit: BoxFit.fill
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
