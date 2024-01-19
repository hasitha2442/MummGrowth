import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sih/Splash_screen.dart';
import 'package:sih/firebase.dart';
import 'package:sih/list.dart';
import 'package:video_player/video_player.dart';
import 'package:sih/videolist.dart';
import 'package:sih/diet.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD01E0fD0D4IToYpM41a1tXTbcEOMBQ2H4",
      projectId: "myapp-6f4eb",
      storageBucket: "myapp-6f4eb.appspot.com",
      messagingSenderId: "871000289792",
      appId: "1:871000289792:android:7981bbe598c88b2d271ee5",
    ),
  );
  runApp(LoginApp());

}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashscreen(
        child: WelcomePage(),
      ),
      routes: {
        '/second':(context)=>SecondPage(),
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Page'),
      ),
      body: Stack(
        fit: StackFit.expand, // Make the stack children fill the screen
        children: <Widget>[
          Image.asset(
            'assets/bgp.png', // Replace with your app background image
            fit: BoxFit.cover, // Cover the entire screen
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text('Sign Up'),
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      primarySwatch: Colors.pink,
      // Primary color for the app
      // You can customize more colors as needed.
    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Signup'),
        ),
        body: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth=FirebaseAuthService();
  bool showPassword = false;
  bool showConfirmPassword = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();
  TextEditingController _doorController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _panController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  String selectedTrimister = 'trimister one';
  final List<String> trimisterOptions = [
    'trimister one',
    'trimister two',
    'trimister three'
  ];
  void _navigateToSecondPage(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final dueDate = _dueDateController.text;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondPage()),
      );
    }
  }



  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool passwordsMatch() {
    return passwordController.text == confirmPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            // Wrapping the content in ListView
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Age',
                    ),
                    items: List.generate(
                      25,
                      (index) => DropdownMenuItem(
                        value: (21 + index).toString(),
                        child: Text((21 + index).toString() + ' years'),
                      ),
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    obscureText: !showPassword,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    obscureText: !showConfirmPassword,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please confirm your password';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _dueDateController,
                    decoration: InputDecoration(
                      labelText: 'Due Date (YYYY-MM-DD)',
                    ),
                    keyboardType: TextInputType.datetime,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please select the due date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Select Trimister',
                    ),
                    value: selectedTrimister,
                    items: trimisterOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {},
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your trimister';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _doorController,
                    decoration: InputDecoration(
                      labelText: 'Door No',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your Door number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _streetController,
                    decoration: InputDecoration(
                      labelText: 'Street',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your Street';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _panController,
                    decoration: InputDecoration(
                      labelText: 'Panchayat',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your panchayat';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'City/Village',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (passwordsMatch()) {
                        _signUp();
                      } else {
                        final snackBar = SnackBar(
                          content: Text("Passwords do not match"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text('Signup'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _signUp() async{
    String email=_nameController.text;
    String password= _passwordController.text;
    User? user=await _auth.signUpWithEmailAndPassword(email, password);

    if(user!=null){
      print("User is succesfully created");
      _navigateToSecondPage(context);
    }else{
      print("Some Error Happened");
    }
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth=FirebaseAuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image that occupies half of the screen
              Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                    // Change to your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Login form with name and password fields
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true, // Hide password
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // All fields are valid, proceed with form submission
                          _signIn();
                        }
                      },
                      child: Text('Login'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginForm()));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _signIn() async{
    String email=_nameController.text;
    String password= _passwordController.text;
    User? user=await _auth.signInWithEmailAndPassword(email, password);

    if(user!=null){
      print("User is succesfully SignedIn");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SecondPage()),
      );
    }else{
      print("Some Error Happened");
    }
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<OptionItem> options = [
      OptionItem('Diet Chart', 'assets/dietchart.jpeg', () {
        // Action for 'Diet Chart' option
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dietchart()),
        );
        // Add your custom logic here
      }),
      OptionItem('Exercises', 'assets/exercise.jpeg', () {
        // Action for 'Exercises' option
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoListScreen()),
        );
        // Add your custom logic here
      }),
      OptionItem('Details', 'assets/details.png', () {
        // Action for 'Details' option
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListDetails()),
        );
        // Add your custom logic here
      }),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Options Menu'),
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuItem(option: options[index]);
        },
      ),
    );
  }
}

class OptionItem {
  final String label;
  final String imagePath;
  final VoidCallback? onTap;

  OptionItem(this.label, this.imagePath, this.onTap);
}

class MenuItem extends StatelessWidget {
  final OptionItem option;

  MenuItem({required this.option});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Call the onTap function when the option is clicked
        if (option.onTap != null) {
          option.onTap!();
        }
      },
      child: Column(
        children: [
          Image.asset(
            option.imagePath,
            width: 100, // Adjust image size as needed
            height: 100,
          ),
          SizedBox(height: 10), // Add spacing between image and label
          Text(option.label),
        ],
      ),
    );
  }
}


