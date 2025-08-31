import 'package:brasil_fields/brasil_fields.dart';

class Validators {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );


  static final RegExp _nameRegex = RegExp(
    r'^[a-zA-ZÀ-ÿ\s]{2,50}$',
  );

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'A senha deve conter pelo menos uma letra maiúscula';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'A senha deve conter pelo menos uma letra minúscula';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'A senha deve conter pelo menos um número';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'A senha deve conter pelo menos um caractere especial';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != password) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    if (value.length > 50) {
      return 'Nome deve ter no máximo 50 caracteres';
    }
    if (!_nameRegex.hasMatch(value)) {
      return 'Nome inválido. Use apenas letras e espaços';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    String cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      return 'Telefone inválido';
    }
    
    return null;
  }

  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    
    if (!UtilBrasilFields.isCPFValido(value)) {
      return 'CPF inválido';
    }
    
    return null;
  }

  static String? validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }
    
    if (!UtilBrasilFields.isCNPJValido(value)) {
      return 'CNPJ inválido';
    }
    
    return null;
  }

  static String? validateCEP(String? value) {
    if (value == null || value.isEmpty) {
      return 'CEP é obrigatório';
    }
    
    String cleanCEP = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanCEP.length != 8) {
      return 'CEP inválido';
    }
    
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data é obrigatória';
    }
    
    try {
      List<String> parts = value.split('/');
      if (parts.length != 3) {
        return 'Data inválida';
      }
      
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      
      if (day < 1 || day > 31) {
        return 'Dia inválido';
      }
      
      if (month < 1 || month > 12) {
        return 'Mês inválido';
      }
      
      if (year < 1900 || year > DateTime.now().year) {
        return 'Ano inválido';
      }
      
      DateTime date = DateTime(year, month, day);
      if (date.day != day || date.month != month || date.year != year) {
        return 'Data inválida';
      }
      
      return null;
    } catch (e) {
      return 'Data inválida';
    }
  }

  static String? validateRequired(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength, {String fieldName = 'Campo'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    if (value.length < minLength) {
      return '$fieldName deve ter pelo menos $minLength caracteres';
    }
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength, {String fieldName = 'Campo'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    if (value.length > maxLength) {
      return '$fieldName deve ter no máximo $maxLength caracteres';
    }
    return null;
  }

  static String? validateNumeric(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    if (double.tryParse(value.replaceAll(',', '.')) == null) {
      return '$fieldName deve ser um número válido';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    try {
      Uri uri = Uri.parse(value);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return 'URL inválida';
      }
      return null;
    } catch (e) {
      return 'URL inválida';
    }
  }

  static String? validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return 'Área é obrigatória';
    }
    
    double? area = double.tryParse(value.replaceAll(',', '.'));
    if (area == null) {
      return 'Área deve ser um número válido';
    }
    
    if (area <= 0) {
      return 'Área deve ser maior que zero';
    }
    
    if (area > 1000000) {
      return 'Área parece estar incorreta';
    }
    
    return null;
  }
}