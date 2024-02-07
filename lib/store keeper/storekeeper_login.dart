import 'package:flutter/material.dart';

class Storekeeper_login extends StatefulWidget {
  const Storekeeper_login({super.key});

  @override
  State<Storekeeper_login> createState() => _Storekeeper_loginState();
}

class _Storekeeper_loginState extends State<Storekeeper_login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 140,
                        width: 140,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/store 1.jpg"),
                                fit: BoxFit.fill)),
                      )
                    ],
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                      20,
                    ),
                    child: Text(
                      "LOGIN",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 50),
                child: Row(
                  children: [
                    Text(
                      " User name",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 290,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: TextFormField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "  Enter username",
                              hintStyle: TextStyle(color: Colors.grey))),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 50, top: 30),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        " Password",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 290,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: TextFormField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "  Enter Password",
                              hintStyle: TextStyle(color: Colors.grey))),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 190,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff4D6877)),
                      child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Sing up",
                    style: TextStyle(color: Colors.black87),
                  ))
            ],
          ),
        ));
  }
}
