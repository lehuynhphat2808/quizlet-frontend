import 'package:flutter/material.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(
              Icons.folder_outlined,
              color: Colors.grey,
            ),
            title: const Text(
              'This is folder',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Text('0 hoc phan'),
                SizedBox(
                  height: 18,
                  child: VerticalDivider(
                    thickness: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                const CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(
                      'https://vtv1.mediacdn.vn/zoom/640_400/562122370168008704/2023/6/14/photo1686714465501-16867144656101728954756.png'),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'This is username',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
