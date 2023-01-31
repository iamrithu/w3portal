import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomContainer extends StatelessWidget {
  final height;
  final widht;
  final String? content;
  final Function click;
  final IconData icon;
  const CustomContainer(
      {Key? key,
      this.height,
      this.widht,
      this.content,
      required this.click,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        click();
      },
      child: Card(
        color: Colors.blue[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 10,
        child: Container(
          width: widht,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Color.fromARGB(255, 27, 24, 73),
                size: widht * 0.1,
              ),
              Text(
                content!,
                style: GoogleFonts.ptSans(
                    color: Color.fromARGB(255, 27, 24, 73),
                    fontSize: widht < 700 ? widht / 24 : widht / 45,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
