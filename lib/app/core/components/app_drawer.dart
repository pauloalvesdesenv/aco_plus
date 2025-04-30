import 'package:aco_plus/app/core/client/firestore/collections/notificacao/notificacao_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/usuario_role.dart';
import 'package:aco_plus/app/core/client/firestore/collections/version/version_collection.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/enums/app_module.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/config/config_page.dart';
import 'package:aco_plus/app/modules/notificacao/ui/notificacoes_page.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamOut<AppModule>(
        stream: baseCtrl.moduleStream.listen,
        builder: (_, module) => Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        width: double.maxFinite,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(
                                'assets/images/logo.png',
                              ),
                            ),
                            Spacer(),
                            Text(
                              usuario.nome,
                              style: AppCss.minimumRegular.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            H(2),
                            Text(
                              usuario.email,
                              style: AppCss.minimumRegular.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'v',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              VersionCollection.version
                                  .toString()
                                  .split('')
                                  .join('.'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            if (usuario.role == UsuarioRole.administrador) ...[
                              const W(8),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  push(context, const ConfigPage());
                                },
                                child: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (usuario.role != UsuarioRole.operador)
                        StreamOut<List<NotificacaoModel>>(
                          stream:
                              FirestoreClient.notificacoes.dataStream.listen,
                          builder: (context, notificacoes) => Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () => push(context, NotificacoesPage()),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  16,
                                ).add(EdgeInsets.only(bottom: 16)),
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                    if (notificacoes
                                        .where((e) => !e.viewed)
                                        .toList()
                                        .isNotEmpty)
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  for (var item in AppModule.values)
                    Builder(
                      builder: (context) {
                        bool isEnabled = true;
                        if (usuario.role != UsuarioRole.operador) {
                          switch (item) {
                            case AppModule.cliente:
                              isEnabled = usuario.permission.cliente
                                  .contains(UserPermissionType.read);

                              break;
                            case AppModule.pedidos:
                              isEnabled = usuario.permission.pedido
                                  .contains(UserPermissionType.read);

                              break;
                            case AppModule.ordens:
                              isEnabled = usuario.permission.ordem.contains(
                                UserPermissionType.read,
                              );

                              break;
                            case AppModule.steps:
                              isEnabled =
                                  usuario.role == UsuarioRole.administrador;

                              break;
                            case AppModule.tags:
                              isEnabled =
                                  usuario.role == UsuarioRole.administrador;
                              break;
                            default:
                          }
                        } else {
                          isEnabled = item == AppModule.ordens;
                        }
                        if (!isEnabled) return const SizedBox();
                        return ListTile(
                          onTap: () {
                            pop(context);
                            baseCtrl.moduleStream.add(item);
                          },
                          leading: Icon(
                            item.icon,
                            color:
                                item == module ? AppColors.primaryMain : null,
                          ),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              color:
                                  item == module ? AppColors.primaryMain : null,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            ListTile(
              onTap: () => usuarioCtrl.clearCurrentUser(),
              leading: Icon(Icons.exit_to_app, color: AppColors.error),
              title: Text('Sair', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      ),
    );
  }
}
