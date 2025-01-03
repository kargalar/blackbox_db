import 'package:blackbox_db/3_Page/ManagerPanel/Widget/user_item.dart';
import 'package:blackbox_db/6_Provider/manager_panel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEditList extends StatefulWidget {
  const UserEditList({
    super.key,
  });

  @override
  State<UserEditList> createState() => _UserEditListState();
}

class _UserEditListState extends State<UserEditList> {
  @override
  Widget build(BuildContext context) {
    late final managerPanelProvider = context.read<ManagerPanelProvider>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 620,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: managerPanelProvider.userList.length,
          itemBuilder: (context, index) {
            // TODO: burada içeriğin bilgileri gösterilecek ve düzenlenebilecek veya silinebilecek. yapıaln değişikliklere göre güncellenmesi gerekenler güncellenecek
            return UserItem(
              userModel: managerPanelProvider.userList[index],
            );
          },
        ),
      ),
    );
  }
}
