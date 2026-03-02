import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:{{project_name}}/core/presentation/theme/app_spacing.dart';

class AppInputField extends FormField<String> {
  AppInputField({
    required this.label,
    super.key,
    this.controller,
    super.initialValue,
    this.value,
    this.hint,
    this.isRequired = false,
    this.isDropdown = false,
    this.isDatePicker = false,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
    this.prefixText,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onChanged,
    this.inputFormatters,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : assert(
         initialValue == null || controller == null,
         'Provide either initialValue or controller, not both',
       ),
       super(
         builder: (FormFieldState<String> field) {
           final state = field as _AppInputFieldState;

           final content = Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               Container(
                 padding: const EdgeInsets.symmetric(
                   horizontal: AppSpacing.sm,
                   vertical: 8,
                 ),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(12),
                   border: Border.all(
                     color: state.hasError
                         ? Colors.red
                         : Colors.grey[300]!.withOpacity(0.5),
                   ),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Row(
                       children: [
                         Expanded(
                           child: Padding(
                             padding: const EdgeInsets.only(
                               left: AppSpacing.xs * 0.6,
                             ),
                             child: Text(
                               label,
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                               style: TextStyle(
                                 color: Colors.grey[500],
                                 fontSize: 10,
                                 fontWeight: FontWeight.w600,
                                 letterSpacing: 0.2,
                               ),
                             ),
                           ),
                         ),
                         if (isRequired)
                           const Text(
                             ' *',
                             style: TextStyle(color: Colors.red, fontSize: 11),
                           ),
                       ],
                     ),
                     Row(
                       children: [
                         Expanded(
                           child: TextField(
                             controller: state._effectiveController,
                             focusNode: state.widget.focusNode,
                             readOnly: readOnly || isDropdown || isDatePicker,
                             maxLines: maxLines,
                             keyboardType: keyboardType,
                             textInputAction: textInputAction,
                             inputFormatters: state.widget.inputFormatters,
                             onChanged: (val) {
                               state.didChange(val);
                               if (state.widget.onChanged != null) {
                                 state.widget.onChanged!(val);
                               }
                             },
                             style: const TextStyle(
                               color: Colors.black,
                               fontSize: 15,
                               fontWeight: FontWeight.w600,
                               height: 1.2,
                             ),
                             decoration: InputDecoration(
                               prefixText: prefixText != null
                                   ? '$prefixText  '
                                   : null,
                               prefixStyle: const TextStyle(
                                 color: Colors.black,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 14,
                               ),
                               hintText: hint ?? 'Enter $label',
                               hintStyle: TextStyle(
                                 color: Colors.grey.withValues(alpha: 0.5),
                                 fontSize: 14,
                                 fontWeight: FontWeight.normal,
                               ),
                               filled: true,
                               fillColor: Colors.transparent,
                               isDense: true,
                               contentPadding: EdgeInsets.zero,
                               border: InputBorder.none,
                               enabledBorder: InputBorder.none,
                               focusedBorder: InputBorder.none,
                             ),
                           ),
                         ),
                         if (isDropdown)
                           const Icon(
                             Icons.arrow_drop_down,
                             color: Colors.black87,
                             size: 18,
                           ),
                         if (isDatePicker)
                           const Icon(
                             Icons.calendar_today,
                             color: Colors.black54,
                             size: 16,
                           ),
                       ],
                     ),
                   ],
                 ),
               ),
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsets.only(top: 4, left: 4),
                   child: Text(
                     state.errorText!,
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                     style: const TextStyle(color: Colors.red, fontSize: 10),
                   ),
                 ),
             ],
           );

           if (onTap != null) {
             return GestureDetector(
               onTap: onTap,
               behavior: HitTestBehavior.opaque,
               child: AbsorbPointer(child: content),
             );
           }
           return content;
         },
       );
  final String label;
  final TextEditingController? controller;
  final String? value;
  final String? hint;
  final bool isRequired;
  final bool isDropdown;
  final bool isDatePicker;
  final int maxLines;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;
  final String? prefixText;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  @override
  FormFieldState<String> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!;

  @override
  AppInputField get widget => super.widget as AppInputField;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(
        text: widget.value ?? widget.initialValue,
      );
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }

    // Sync initial controller value with FormFieldState.value
    // This fixes the issue where pre-populated controllers show validation errors
    if (_effectiveController.text.isNotEmpty && value == null) {
      setValue(_effectiveController.text);
    }
  }

  @override
  void didUpdateWidget(AppInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller = TextEditingController.fromValue(
          oldWidget.controller!.value,
        );
      }
      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }

    // Handle 'value' prop for dropdowns/pickers
    if (widget.value != oldWidget.value && widget.value != null) {
      _effectiveController.text = widget.value!;
      setValue(widget.value);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
    }
  }

  @override
  void reset() {
    super.reset();
    _effectiveController.text = widget.initialValue ?? '';
    setState(() {
      _effectiveController.text = widget.initialValue ?? '';
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}
