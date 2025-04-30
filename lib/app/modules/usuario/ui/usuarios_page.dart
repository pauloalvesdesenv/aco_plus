import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/usuario/ui/usuario_create_page.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:aco_plus/app/modules/usuario/usuario_view_model.dart';
import 'package:flutter/material.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Usuarios',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => push(context, const UsuarioCreatePage()),
            icon: Icon(Icons.add, color: AppColors.white),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<UsuarioModel>>(
        stream: FirestoreClient.usuarios.dataStream.listen,
        builder:
            (_, __) => StreamOut<UsuarioUtils>(
              stream: usuarioCtrl.utilsStream.listen,
              builder: (_, utils) {
                final usuarios = usuarioCtrl.getUsuariosFiltered(
                  utils.search.text,
                  __,
                );

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: AppField(
                        hint: 'Pesquisar',
                        controller: utils.search,
                        suffixIcon: Icons.search,
                        onChanged: (_) => usuarioCtrl.utilsStream.update(),
                      ),
                    ),
                    Expanded(
                      child:
                          usuarios.isEmpty
                              ? const EmptyData()
                              : ListView.separated(
                                itemCount: usuarios.length,
                                separatorBuilder: (_, i) => const Divisor(),
                                itemBuilder:
                                    (_, i) => _itemUsuarioWidget(usuarios[i]),
                              ),
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }

  ListTile _itemUsuarioWidget(UsuarioModel usuario) {
    return ListTile(
      onTap: () => push(UsuarioCreatePage(usuario: usuario)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(usuario.nome, style: AppCss.mediumBold),
      subtitle: Text(usuario.role.label ?? ''),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.neutralMedium,
      ),
    );
  }
}
