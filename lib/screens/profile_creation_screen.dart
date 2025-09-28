import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_wallet2/l10n/l10n.dart';
import 'package:auto_wallet2/providers/app_provider.dart';
import 'package:auto_wallet2/providers/user_provider.dart';
import 'package:auto_wallet2/screens/main_screen.dart';
import 'package:auto_wallet2/utils/app_theme.dart';
import 'package:auto_wallet2/widgets/app_button.dart';
import 'package:auto_wallet2/widgets/photo_picker.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({Key? key}) : super(key: key);

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _photoPath;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.createProfile,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: AppTheme.paddingLarge * 2),
                
                // Center photo picker
                Center(
                  child: PhotoPicker(
                    currentPhotoPath: _photoPath,
                    onPhotoSelected: (path) {
                      setState(() {
                        _photoPath = path;
                      });
                    },
                    buttonText: context.l10n.selectPhoto,
                  ),
                ),
                const SizedBox(height: AppTheme.paddingLarge * 2),
                
                // Name input field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.enterName,
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пожалуйста, введите ваше имя';
                    }
                    return null;
                  },
                ),
                
                const Spacer(),
                
                // Next button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                        text: context.l10n.next,
                        onPressed: _createProfile,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        
        // Create user profile
        await userProvider.createUser(
          name: _nameController.text.trim(),
          photoPath: _photoPath,
          language: appProvider.language,
          currency: appProvider.currency,
        );
        
        // Navigate to main screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 