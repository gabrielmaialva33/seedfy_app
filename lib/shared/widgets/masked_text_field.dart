import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:brasil_fields/brasil_fields.dart';

class MaskedTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final MaskType maskType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const MaskedTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    required this.maskType,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  List<TextInputFormatter> _getFormatters() {
    switch (maskType) {
      case MaskType.cpf:
        return [
          FilteringTextInputFormatter.digitsOnly,
          CpfInputFormatter(),
        ];
      case MaskType.cnpj:
        return [
          FilteringTextInputFormatter.digitsOnly,
          CnpjInputFormatter(),
        ];
      case MaskType.cpfCnpj:
        return [
          FilteringTextInputFormatter.digitsOnly,
          CpfOuCnpjFormatter(),
        ];
      case MaskType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          TelefoneInputFormatter(),
        ];
      case MaskType.cep:
        return [
          FilteringTextInputFormatter.digitsOnly,
          CepInputFormatter(),
        ];
      case MaskType.date:
        return [
          FilteringTextInputFormatter.digitsOnly,
          DataInputFormatter(),
        ];
      case MaskType.creditCard:
        return [
          FilteringTextInputFormatter.digitsOnly,
          CartaoBancarioInputFormatter(),
        ];
      case MaskType.money:
        return [
          FilteringTextInputFormatter.digitsOnly,
          RealInputFormatter(moeda: true),
        ];
      case MaskType.weight:
        return [
          FilteringTextInputFormatter.digitsOnly,
          PesoInputFormatter(),
        ];
      case MaskType.height:
        return [
          FilteringTextInputFormatter.digitsOnly,
          AlturaInputFormatter(),
        ];
      case MaskType.hour:
        return [
          FilteringTextInputFormatter.digitsOnly,
          HoraInputFormatter(),
        ];
      case MaskType.plateVehicle:
        return [
          PlacaVeiculoInputFormatter(),
        ];
      case MaskType.custom:
        return [];
      case MaskType.none:
        return [];
    }
  }

  TextInputType? _getKeyboardType() {
    if (keyboardType != null) return keyboardType;
    
    switch (maskType) {
      case MaskType.cpf:
      case MaskType.cnpj:
      case MaskType.cpfCnpj:
      case MaskType.phone:
      case MaskType.cep:
      case MaskType.date:
      case MaskType.creditCard:
      case MaskType.money:
      case MaskType.weight:
      case MaskType.height:
      case MaskType.hour:
        return TextInputType.number;
      case MaskType.plateVehicle:
        return TextInputType.text;
      case MaskType.custom:
      case MaskType.none:
        return TextInputType.text;
    }
  }

  String? _getHintText() {
    if (hint != null) return hint;
    
    switch (maskType) {
      case MaskType.cpf:
        return '000.000.000-00';
      case MaskType.cnpj:
        return '00.000.000/0000-00';
      case MaskType.cpfCnpj:
        return 'CPF ou CNPJ';
      case MaskType.phone:
        return '(00) 00000-0000';
      case MaskType.cep:
        return '00000-000';
      case MaskType.date:
        return 'DD/MM/AAAA';
      case MaskType.creditCard:
        return '0000 0000 0000 0000';
      case MaskType.money:
        return 'R\$ 0,00';
      case MaskType.weight:
        return '0,00 kg';
      case MaskType.height:
        return '0,00 m';
      case MaskType.hour:
        return '00:00';
      case MaskType.plateVehicle:
        return 'ABC-1234';
      case MaskType.custom:
      case MaskType.none:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: _getKeyboardType(),
      inputFormatters: _getFormatters(),
      enabled: enabled,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        hintText: _getHintText(),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
    );
  }
}

enum MaskType {
  cpf,
  cnpj,
  cpfCnpj,
  phone,
  cep,
  date,
  creditCard,
  money,
  weight,
  height,
  hour,
  plateVehicle,
  custom,
  none,
}

class CustomMaskedTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String mask;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final TextInputAction? textInputAction;

  const CustomMaskedTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    required this.mask,
    this.validator,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.focusNode,
    this.onChanged,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final maskFormatter = MaskTextInputFormatter(
      mask: mask,
      filter: {"#": RegExp(r'[0-9]'), "@": RegExp(r'[a-zA-Z]')},
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: [maskFormatter],
      enabled: enabled,
      focusNode: focusNode,
      onChanged: onChanged,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint ?? mask.replaceAll('#', '0').replaceAll('@', 'A'),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
    );
  }
}