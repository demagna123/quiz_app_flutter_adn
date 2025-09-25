import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/pages/home/home.dart';
import 'package:quiz_app/providers/auth.dart';

class FinalRegister extends StatefulWidget {
 final UserModel? user;
  FinalRegister({required this.user});

  @override
  State<FinalRegister> createState() => _FinalRegisterState();
}

class _FinalRegisterState extends State<FinalRegister> {
  bool isLoading = false;
  bool errorMessage = false;
  bool sucessMesage = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController(
      text: widget.user?.email,
    );
    TextEditingController nameController = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xFF451E70),

      body: Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          // Centrage horizontal et vertical
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize
                .min, // pour que la colonne prenne juste la taille des enfants
            children: [
              Text(
                "Finissez votre inscription",
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
              SizedBox(height: 30), // espace vertical
              SizedBox(
                width: 400,
                child: TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    label: Text(
                      "Email:",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 400,
                child: TextField(
                  controller: nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    label: Text(
                      "Name:",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!isLoading &&
                        (emailController.text.isEmpty ||
                            nameController.text.isEmpty)) {
                      setState(() {
                        errorMessage = true;
                      });
                    } else {
                      setState(() {
                        errorMessage = false;
                        isLoading = true;
                      });

                      UserModel user = UserModel(
                        email: emailController.text,
                        name: nameController.text,
                      );

                      await authProvider.addUser(user);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen(user: user,)),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF451E70),
                          ),
                        )
                      : Text(
                          "Suivant",
                          style: TextStyle(
                            color: Color(0xFF451E70),
                            fontSize: 16,
                          ),
                        ),
                ),
              ), // espace vertical
            ],
          ),
        ),
      ),
    );
  }
}
