import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quizlet_frontend/folder/folder_model.dart';
import 'package:quizlet_frontend/services/api_service.dart';
import 'package:quizlet_frontend/utilities/page_response.dart';

import '../utilities/router_manager.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);
  @override
  State<FolderPage> createState() => FolderPageState();
}

class FolderPageState extends State<FolderPage> {
  void reset() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getPageFolder(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          PageResponse pageResponse = snapshot.data;
          List<FolderModel> folderModelList =
              FolderModel.getFolderModelList(pageResponse.items);
          print('folderModelList: $folderModelList');
          return ListView.builder(
            itemCount: folderModelList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  var updated = await Navigator.pushNamed(
                      context, Routes.folderDetailPage,
                      arguments: folderModelList[index].id);
                  if (updated != null) {
                    setState(() {});
                  }
                },
                child: Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.folder_outlined,
                      color: Colors.grey,
                    ),
                    title: Text(
                      folderModelList[index].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Text('${folderModelList[index].topicCount} topics'),
                        SizedBox(
                          height: 18,
                          child: VerticalDivider(
                            thickness: 1,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        CircleAvatar(
                          radius: 12,
                          backgroundImage:
                              NetworkImage(ApiService.userModel.avatar),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          ApiService.userModel.nickname,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.grey[300]!, size: 40));
        }
      },
    );
  }
}
