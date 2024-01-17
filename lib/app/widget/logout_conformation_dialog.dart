import 'package:merocanteen/app/config/colors.dart';
import 'package:merocanteen/app/config/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final String heading;
  final String subheading;
  final String firstbutton;
  final String secondbutton;
  final VoidCallback onConfirm;
  final bool isbutton;

  const LogoutConfirmationDialog(
      {required this.heading,
      required this.subheading,
      required this.isbutton,
      required this.firstbutton,
      required this.secondbutton,
      required this.onConfirm,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    Text(heading,
                        style: TextStyle(
                            fontSize: 27.0,
                            fontFamily: FontStyles.poppinBold,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            subheading,
                            style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 119, 116, 116)),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: isbutton
                    ? Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: onConfirm,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text(
                                  firstbutton,
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 238, 235, 235),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text(
                                  secondbutton,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
