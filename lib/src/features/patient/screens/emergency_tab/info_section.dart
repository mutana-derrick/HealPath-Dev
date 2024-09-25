import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.info_outline, color: Colors.blue),
              title: Text('When to Call Emergency'),
              subtitle: Text('Call immediately if you experience:'),
            ),
            const SizedBox(height: 10),
            _buildInfoItem('Severe chest pain or difficulty breathing'),
            _buildInfoItem('Sudden severe headache or loss of consciousness'),
            _buildInfoItem('Uncontrolled bleeding'),
            _buildInfoItem('Severe allergic reaction'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}