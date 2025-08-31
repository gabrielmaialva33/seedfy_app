import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:brasil_fields/brasil_fields.dart';

import '../../../../core/providers/locale_provider.dart';
import '../../../../shared/widgets/masked_text_field.dart';
import '../../../../shared/utils/validators.dart';
import '../bloc/auth_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _cepController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Brazilian states from brasil_fields
  final List<String> _brazilianStates = Estados.listaEstadosSigla;

  String? _selectedState;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      context.read<AuthBloc>().add(
            AuthEvent.signupRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              city: _cityController.text.trim(),
              state: _selectedState ?? _stateController.text.trim(),
            ),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          authenticated: (user) {
            // Navigate to onboarding for new users
            context.go('/onboarding');
          },
          unauthenticated: () {},
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          },
          passwordResetSent: () {},
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Header
                Text(
                  isPortuguese ? 'Criar Conta' : 'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                Text(
                  isPortuguese
                      ? 'Junte-se à comunidade Seedfy'
                      : 'Join the Seedfy community',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: isPortuguese ? 'Nome completo' : 'Full name',
                    hintText:
                        isPortuguese ? 'Seu nome completo' : 'Your full name',
                    prefixIcon: const Icon(Icons.person_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateName,
                ),

                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: isPortuguese ? 'seu@email.com' : 'your@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validateEmail,
                ),

                const SizedBox(height: 16),

                // Phone Field with Mask
                MaskedTextField(
                  controller: _phoneController,
                  label: isPortuguese ? 'Telefone' : 'Phone',
                  maskType: MaskType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  validator: Validators.validatePhone,
                ),

                const SizedBox(height: 16),

                // Location Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    isPortuguese ? 'Localização' : 'Location',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),

                // CEP Field (only for Portuguese)
                if (isPortuguese) ...[                  
                  MaskedTextField(
                    controller: _cepController,
                    label: 'CEP',
                    maskType: MaskType.cep,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    validator: Validators.validateCEP,
                  ),
                  const SizedBox(height: 16),
                ],

                // City Field
                TextFormField(
                  controller: _cityController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: isPortuguese ? 'Cidade' : 'City',
                    hintText: isPortuguese ? 'São Paulo' : 'New York',
                    prefixIcon: const Icon(Icons.location_city_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => Validators.validateRequired(value, fieldName: isPortuguese ? 'Cidade' : 'City'),
                ),

                const SizedBox(height: 16),

                // State Field - Dropdown for BR, Text field for others
                isPortuguese
                    ? DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Estado (UF)',
                          prefixIcon: const Icon(Icons.map_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _brazilianStates.map((String state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedState = value;
                          });
                        },
                        onSaved: (value) {
                          _selectedState = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecione seu estado';
                          }
                          return null;
                        },
                      )
                    : TextFormField(
                        controller: _stateController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'State/Province',
                          hintText: 'California',
                          prefixIcon: const Icon(Icons.map_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter your state/province';
                          }
                          return null;
                        },
                      ),

                const SizedBox(height: 24),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: isPortuguese ? 'Senha' : 'Password',
                    hintText: isPortuguese
                        ? 'Mínimo 8 caracteres, com maiúscula, número e símbolo'
                        : 'Min 8 chars, with uppercase, number and symbol',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: Validators.validatePassword,
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText:
                        isPortuguese ? 'Confirmar senha' : 'Confirm password',
                    hintText: isPortuguese
                        ? 'Digite a senha novamente'
                        : 'Enter password again',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
                ),

                const SizedBox(height: 32),

                // Sign Up Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignup,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            isPortuguese ? 'Criar Conta' : 'Create Account',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isPortuguese
                          ? 'Já tem uma conta? '
                          : 'Already have an account? ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        isPortuguese ? 'Entrar' : 'Sign In',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Language Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isPortuguese ? 'Idioma: ' : 'Language: ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () {
                        localeProvider.setLocale(isPortuguese
                            ? const Locale('en', 'US')
                            : const Locale('pt', 'BR'));
                      },
                      child: Text(
                        isPortuguese ? '🇺🇸 English' : '🇧🇷 Português',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
