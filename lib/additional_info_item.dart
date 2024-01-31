import 'package:flutter/material.dart';

class AdditionalInformationItem extends StatelessWidget {
  const AdditionalInformationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.beach_access, size: 32),
        SizedBox(height: 10,),
        Text('Pressure'),
        SizedBox(height: 8,),
        Text('1006',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}