import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/enums/obra_status.dart';
import 'package:aco_plus/app/core/models/endereco_model.dart';
import 'package:aco_plus/app/core/models/text_controller.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<ClienteModel?> showClienteCreateSimplifyBottom() async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => const ClienteCreateSimplifyBottom(),
    );

class ClienteCreateSimplifyBottom extends StatefulWidget {
  const ClienteCreateSimplifyBottom({super.key});

  @override
  State<ClienteCreateSimplifyBottom> createState() =>
      _ClienteCreateSimplifyBottomState();
}

class _ClienteCreateSimplifyBottomState
    extends State<ClienteCreateSimplifyBottom> {
  final TextController cliente = TextController();
  final TextController obra = TextController();

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => KeyboardVisibilityBuilder(
        builder: (context, isVisible) {
          return Container(
            height: isVisible ? 700 : 400,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: ListView(
              children: [
                const H(16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.all(16),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.white,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          AppColors.black,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.keyboard_backspace),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Adicionar Cliente', style: AppCss.largeBold),
                      const H(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppField(
                            label: 'Cliente',
                            controller: cliente,
                            onChanged: (_) => setState(() {}),
                          ),
                          const H(16),
                          AppField(
                            label: 'Obra',
                            controller: obra,
                            onChanged: (_) => setState(() {}),
                            onEditingComplete: () {
                              if (cliente.text.isNotEmpty &&
                                  obra.text.isNotEmpty) {
                                onConfirm(context);
                              }
                            },
                          ),
                          const H(16),
                          const H(16),
                          AppTextButton(
                            label: 'Confirmar',
                            isEnable:
                                cliente.text.isNotEmpty && obra.text.isNotEmpty,
                            onPressed: () async => await onConfirm(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> onConfirm(BuildContext context) async {
    final ClienteModel clienteModel = ClienteModel(
      id: HashService.get,
      telefone: '',
      cpf: '',
      endereco: EnderecoModel.empty(),
      nome: cliente.text,
      obras: [
        ObraModel(
          id: HashService.get,
          descricao: obra.text,
          telefoneFixo: '',
          endereco: EnderecoModel.empty(),
          status: ObraStatus.emAndamento,
        ),
      ],
    );
    await FirestoreClient.clientes.add(clienteModel);
    FirestoreClient.clientes.dataStream.update();
    Navigator.pop(context, clienteModel);
  }
}
