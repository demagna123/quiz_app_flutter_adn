import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/pages/home/home.dart';
import 'package:quiz_app/providers/auth.dart';

class ProfilScreen extends StatefulWidget {
  final UserModel? user;
  ProfilScreen({required this.user});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool isLoading = false;
  bool errorMessage = false;
  bool sucessMesage = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController(
      text: widget.user?.email,
    );
    TextEditingController nameController = TextEditingController(
      text: widget.user?.name,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),

      body: Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          // Centrage horizontal et vertical
          child: Column(
            spacing: 30,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize
                .min, // pour que la colonne prenne juste la taille des enfants
            children: [
              Text(
                "Modifier votre profile",
                style: TextStyle(color: Color(0xFF451E70), fontSize: 23),
              ),
              SizedBox(height: 30), // espace vertical

              if (errorMessage)
                Container(
                  width: 300,
                  height: 50,
                  color: Colors.red,
                  child: Text(
                    "Veillez remplire bien les champs",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              SizedBox(
                width: 400,
                child: TextField(
                  controller: emailController,
                  style: TextStyle(color: Color(0xFF451E70)),
                  decoration: InputDecoration(
                    label: Text(
                      "Email:",
                      style: TextStyle(color: Color(0xFF451E70), fontSize: 18),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF451E70)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF451E70)),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 400,
                child: TextField(
                  controller: nameController,
                  style: TextStyle(color: Color(0xFF451E70)),
                  decoration: InputDecoration(
                    label: Text(
                      "Name:",
                      style: TextStyle(color: Color(0xFF451E70), fontSize: 18),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF451E70)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF451E70)),
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
                        id: widget.user?.id,
                        email: emailController.text,
                        name: nameController.text,
                      );

                      await authProvider.updateUser(user);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(user: user),
                        ),
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
                          "Modifier",
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
