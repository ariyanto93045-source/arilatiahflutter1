import 'package:flutter/material.dart';

class tugas3 extends StatelessWidget {
  const tugas3 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MY MOM KOST"),
        backgroundColor: Colors.blue,
        
      ),
      body: SingleChildScrollView(
        child: Column(

          children: [
            Text( "Nama",
            style:TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            ),
            
            TextField(),
            Text( "Alamat email",
            style:TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )
            ),
            TextField(),
            Text( "Nomor HP",
            style:TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )
            ),
            TextField(),

            
            Text( "Diskripsi",
            style:TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )
            ),
            
            

            
          ],
        ),
      ),
    );
  }
}