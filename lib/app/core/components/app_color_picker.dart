import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/dialogs/color_picker_dialog.dart';
import 'package:aco_plus/app/core/extensions/color_ext.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class AppColorPicker extends StatefulWidget {
  final Color color;
  final String label;
  final Function(Color) onChanged;

  const AppColorPicker({
    required this.color,
    required this.label,
    required this.onChanged,
    super.key,
  });

  @override
  State<AppColorPicker> createState() => _AppColorPickerState();
}

class _AppColorPickerState extends State<AppColorPicker> {
  final MaskedTextController _controller = MaskedTextController(
    mask: '#******',
  );

  @override
  void initState() {
    _controller.updateText(widget.color.toHexadecimal());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppCss.smallBold),
        const H(4),
        Row(
          children: [
            InkWell(
              onTap: () async {
                final color = await showColorPicker();
                if (color != null) {
                  _controller.updateText(color.toHexadecimal());
                  widget.onChanged(color);
                }
              },
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.color_lens,
                    size: 18,
                    color:
                        widget.color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
              ),
            ),
            const W(8),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  // if (value.length == 7) {
                  //   widget.onChanged(Color(0xFF$value));
                  // }
                },
                decoration: const InputDecoration(
                  hintText: '#000000',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
