import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/automatizacao/ui/automatizacao_page.dart';
import 'package:aco_plus/app/modules/backup/ui/backups_page.dart';
import 'package:aco_plus/app/modules/checklist/ui/checklists_page.dart';
import 'package:aco_plus/app/modules/usuario/ui/usuarios_page.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () => push(context, const UsuariosPage()),
            title: const Text('Usuários'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400]!,
            ),
          ),
          const Divisor(),
          ListTile(
            onTap: () => push(context, const BackupsPage()),
            title: const Text('Backup'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400]!,
            ),
          ),
          const Divisor(),
          ListTile(
            onTap: () => push(context, const ChecklistsPage()),
            title: const Text('Modelos de checklist'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400]!,
            ),
          ),
          const Divisor(),
          ListTile(
            onTap: () => push(context, const AutomatizacaoPage()),
            title: const Text('Automatização de Etapas'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400]!,
            ),
          ),
          const Divisor(),
        ],
      ),
    );
  }
}
