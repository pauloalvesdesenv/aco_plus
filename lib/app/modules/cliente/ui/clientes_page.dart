import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/enums/user_permission_type.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/drawer/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/cliente/cliente_controller.dart';
import 'package:aco_plus/app/modules/cliente/cliente_view_model.dart';
import 'package:aco_plus/app/modules/cliente/ui/cliente_create_page.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  @override
  void initState() {
    FirestoreClient.clientes.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => baseCtrl.key.currentState!.openDrawer(),
          icon: Icon(Icons.menu, color: AppColors.white),
        ),
        title: Text(
          'Clientes',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          if (usuario.permission.cliente.contains(UserPermissionType.create))
            IconButton(
              onPressed: () => push(context, const ClienteCreatePage()),
              icon: Icon(Icons.add, color: AppColors.white),
            ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<ClienteModel>>(
        stream: FirestoreClient.clientes.dataStream.listen,
        builder: (_, __) => StreamOut<ClienteUtils>(
          stream: clienteCtrl.utilsStream.listen,
          builder: (_, utils) {
            final clientes = clienteCtrl
                .getClienteesFiltered(utils.search.text, __)
                .toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppField(
                    hint: 'Pesquisar',
                    controller: utils.search,
                    suffixIcon: Icons.search,
                    onChanged: (_) => clienteCtrl.utilsStream.update(),
                  ),
                ),
                Expanded(
                  child: clientes.isEmpty
                      ? const EmptyData()
                      : RefreshIndicator(
                          onRefresh: () async =>
                              FirestoreClient.clientes.fetch(),
                          child: ListView.separated(
                            itemCount: clientes.length,
                            separatorBuilder: (_, i) => const Divisor(),
                            itemBuilder: (_, i) =>
                                _itemClienteWidget(clientes[i]),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ListTile _itemClienteWidget(ClienteModel usuario) {
    return ListTile(
      onTap: () => push(ClienteCreatePage(cliente: usuario)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(usuario.nome, style: AppCss.mediumBold),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tel: ${usuario.telefone} - Qtd. Obras: ${usuario.obras.length}',
          ),
          Text(
            usuario.endereco.name,
            style: AppCss.minimumRegular
                .setSize(12)
                .setColor(AppColors.neutralMedium),
          ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.neutralMedium,
      ),
    );
  }
}
