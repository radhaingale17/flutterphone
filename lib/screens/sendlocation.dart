import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class Sendlocation extends StatefulWidget {
  @override
  _SendlocationState createState() => _SendlocationState();
}

class _SendlocationState extends State<Sendlocation> {
  String _locationMessage = ""; 

  void _getCurrentLocation() async {

    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
    });

  }
  showAlert(BuildContext context) {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        
        title: Text('Are you sure you want to send your location ?'),
        
        actions: <Widget>[
          FlatButton(
            child: Text('YES',
              style: TextStyle(
                   color: Colors.green,
                   fontWeight: FontWeight.bold,
                   fontSize: 20)),
           
            onPressed: () {
              //Put your code here which you want to execute on Yes button click.
                   _getCurrentLocation();
                   Navigator.of(context).pop();
                   
                          },
                        ),
              
                         FlatButton(
                          child: Text('NO',
                            style: TextStyle(
                                 color: Colors.green,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 20)),
                          onPressed: () {
                            //Put your code here which you want to execute on No button click.
                            Navigator.of(context).pop();
                          },
                        ),
                       
                      ],
                       
                       
                    
                    elevation: 24.0,
                    
                    );
                   },
                  );
                }
  @override
   Widget build(BuildContext context) {
                  return Scaffold(
                    body:
                     Align(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            // Text(_locationMessage), 
            FlatButton(
              onPressed: () {
                  // _getCurrentLocation();
                   showAlert( context);
              },
              color: Colors.green,
              child: Text("Send Location")
            )
          ]),
        )
                    
                  );
                }
      
  
  
}