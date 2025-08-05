import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/user_provider.dart';
import '../widgets/profile_image_picker.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_text_styles.dart';

class EnhancedEditProfileScreen extends StatefulWidget {
  final UserProfile? userProfile;
  final bool isCreatingNew;

  const EnhancedEditProfileScreen({
    super.key,
    this.userProfile,
    this.isCreatingNew = false,
  });

  @override
  State<EnhancedEditProfileScreen> createState() => _EnhancedEditProfileScreenState();
}

class _EnhancedEditProfileScreenState extends State<EnhancedEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Form controllers
  late final TextEditingController _displayNameController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _bioController;
  late final TextEditingController _websiteController;
  late final TextEditingController _locationController;
  late final TextEditingController _interestsController;

  // Form state
  String? _selectedImagePath;
  DateTime? _selectedDateOfBirth;
  UserGender _selectedGender = UserGender.notSpecified;
  UserPrivacyLevel _selectedPrivacyLevel = UserPrivacyLevel.public;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupListeners();
  }

  void _initializeControllers() {
    final profile = widget.userProfile;
    
    _displayNameController = TextEditingController(text: profile?.displayName ?? '');
    _firstNameController = TextEditingController(text: profile?.firstName ?? '');
    _lastNameController = TextEditingController(text: profile?.lastName ?? '');
    _phoneNumberController = TextEditingController(text: profile?.phoneNumber ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _websiteController = TextEditingController(text: profile?.website ?? '');
    _locationController = TextEditingController(text: profile?.location ?? '');
    _interestsController = TextEditingController(text: profile?.interests.join(', ') ?? '');
    
    _selectedDateOfBirth = profile?.dateOfBirth;
    _selectedGender = profile?.gender ?? UserGender.notSpecified;
    _selectedPrivacyLevel = profile?.privacyLevel ?? UserPrivacyLevel.public;
  }

  void _setupListeners() {
    final controllers = [
      _displayNameController,
      _firstNameController,
      _lastNameController,
      _phoneNumberController,
      _bioController,
      _websiteController,
      _locationController,
      _interestsController,
    ];

    for (final controller in controllers) {
      controller.addListener(_onFormChanged);
    }
  }

  void _onFormChanged() {
    if (!mounted) return;
    
    final hasChanges = _hasFormChanges();
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  bool _hasFormChanges() {
    final profile = widget.userProfile;
    if (profile == null) return true; // Creating new profile

    return _displayNameController.text != (profile.displayName ?? '') ||
           _firstNameController.text != (profile.firstName ?? '') ||
           _lastNameController.text != (profile.lastName ?? '') ||
           _phoneNumberController.text != (profile.phoneNumber ?? '') ||
           _bioController.text != (profile.bio ?? '') ||
           _websiteController.text != (profile.website ?? '') ||
           _locationController.text != (profile.location ?? '') ||
           _interestsController.text != profile.interests.join(', ') ||
           _selectedDateOfBirth != profile.dateOfBirth ||
           _selectedGender != profile.gender ||
           _selectedPrivacyLevel != profile.privacyLevel ||
           _selectedImagePath != null;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    _interestsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCreatingNew ? 'Create Profile' : 'Edit Profile'),
        backgroundColor: ThemeColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_hasChanges)
            Consumer<UserProvider>(
              builder: (context, provider, child) {
                return TextButton(
                  onPressed: provider.isLoading ? null : _saveProfile,
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileImageSection(provider),
                  const SizedBox(height: 32),
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildPersonalInfoSection(),
                  const SizedBox(height: 24),
                  _buildContactInfoSection(),
                  const SizedBox(height: 24),
                  _buildPreferencesSection(),
                  const SizedBox(height: 32),
                  if (provider.error != null)
                    _buildErrorMessage(provider.error!),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImageSection(UserProvider provider) {
    return Center(
      child: ProfileImagePicker(
        currentImageUrl: widget.userProfile?.profileImageUrl,
        onImageSelected: (imagePath) {
          if (imagePath.isEmpty) {
            // Handle remove image
            setState(() {
              _selectedImagePath = '';
              _hasChanges = true;
            });
          } else {
            // Handle new image selected
            setState(() {
              _selectedImagePath = imagePath;
              _hasChanges = true;
            });
          }
        },
        isLoading: provider.isUploading,
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection(
      title: 'Basic Information',
      icon: Icons.person_outline,
      children: [
        _buildTextField(
          controller: _displayNameController,
          label: 'Display Name',
          hint: 'How you want to be shown to others',
          prefixIcon: Icons.badge_outlined,
          validator: _validateDisplayName,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                hint: 'Your first name',
                prefixIcon: Icons.person_outline,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                hint: 'Your last name',
                prefixIcon: Icons.person_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _bioController,
          label: 'Bio',
          hint: 'Tell others about yourself',
          prefixIcon: Icons.edit_note,
          maxLines: 3,
          maxLength: 500,
          validator: _validateBio,
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.info_outline,
      children: [
        _buildDatePicker(),
        const SizedBox(height: 16),
        _buildGenderDropdown(),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _locationController,
          label: 'Location',
          hint: 'City, Country',
          prefixIcon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _interestsController,
          label: 'Interests',
          hint: 'Comma-separated list of your interests',
          prefixIcon: Icons.interests_outlined,
          helperText: 'Example: Photography, Travel, Technology',
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return _buildSection(
      title: 'Contact Information',
      icon: Icons.contact_phone_outlined,
      children: [
        _buildTextField(
          controller: _phoneNumberController,
          label: 'Phone Number',
          hint: '+1 234 567 8900',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: _validatePhoneNumber,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _websiteController,
          label: 'Website',
          hint: 'https://yourwebsite.com',
          prefixIcon: Icons.language_outlined,
          keyboardType: TextInputType.url,
          validator: _validateWebsite,
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: 'Privacy Settings',
      icon: Icons.privacy_tip_outlined,
      children: [
        _buildPrivacyDropdown(),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: ThemeColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: ThemeTextStyles.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ThemeColors.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDateOfBirth,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          prefixIcon: const Icon(Icons.cake_outlined, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        child: Text(
          _selectedDateOfBirth != null
              ? _formatDate(_selectedDateOfBirth!)
              : 'Select your date of birth',
          style: _selectedDateOfBirth != null
              ? null
              : TextStyle(color: Theme.of(context).hintColor),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<UserGender>(
      value: _selectedGender,
      onChanged: (UserGender? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedGender = newValue;
          });
          _onFormChanged();
        }
      },
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(Icons.person_outline, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      items: UserGender.values.map((UserGender gender) {
        return DropdownMenuItem<UserGender>(
          value: gender,
          child: Text(_getGenderText(gender)),
        );
      }).toList(),
    );
  }

  Widget _buildPrivacyDropdown() {
    return DropdownButtonFormField<UserPrivacyLevel>(
      value: _selectedPrivacyLevel,
      onChanged: (UserPrivacyLevel? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedPrivacyLevel = newValue;
          });
          _onFormChanged();
        }
      },
      decoration: InputDecoration(
        labelText: 'Profile Visibility',
        prefixIcon: const Icon(Icons.visibility_outlined, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      items: UserPrivacyLevel.values.map((UserPrivacyLevel level) {
        return DropdownMenuItem<UserPrivacyLevel>(
          value: level,
          child: Text(_getPrivacyLevelText(level)),
        );
      }).toList(),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Validation methods
  String? _validateDisplayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Display name is required';
    }
    if (value.trim().length < 2) {
      return 'Display name must be at least 2 characters';
    }
    return null;
  }

  String? _validateBio(String? value) {
    if (value != null && value.length > 500) {
      return 'Bio must be less than 500 characters';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value != null && value.isNotEmpty) {
      final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
      if (!phoneRegex.hasMatch(value)) {
        return 'Please enter a valid phone number';
      }
    }
    return null;
  }

  String? _validateWebsite(String? value) {
    if (value != null && value.isNotEmpty) {
      try {
        final uri = Uri.parse(value);
        if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
          return 'Please enter a valid URL (http:// or https://)';
        }
      } catch (e) {
        return 'Please enter a valid URL';
      }
    }
    return null;
  }

  // Helper methods
  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
      _onFormChanged();
    }
  }

  String _getGenderText(UserGender gender) {
    switch (gender) {
      case UserGender.male:
        return 'Male';
      case UserGender.female:
        return 'Female';
      case UserGender.nonBinary:
        return 'Non-binary';
      case UserGender.notSpecified:
        return 'Prefer not to say';
    }
  }

  String _getPrivacyLevelText(UserPrivacyLevel level) {
    switch (level) {
      case UserPrivacyLevel.public:
        return 'Public - Everyone can see your profile';
      case UserPrivacyLevel.friendsOnly:
        return 'Friends Only - Only friends can see your profile';
      case UserPrivacyLevel.private:
        return 'Private - Only you can see your profile';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<String> _parseInterests(String interestsText) {
    return interestsText
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<UserProvider>();
    
    try {
      String? imageUrl;
      
      // Upload image if selected
      if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty) {
        final userId = widget.userProfile?.id ?? '';
        if (userId.isNotEmpty) {
          imageUrl = await provider.uploadProfileImage(userId, _selectedImagePath!);
          if (imageUrl == null) {
            // Error uploading image, but continue with profile update
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to upload image, but profile will be saved'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        }
      }

      // Create updated profile
      final updatedProfile = (widget.userProfile ?? 
          UserProfile(
            id: '',
            email: '',
            createdAt: DateTime.now(),
          )
      ).copyWith(
        displayName: _displayNameController.text.trim().isEmpty 
            ? null 
            : _displayNameController.text.trim(),
        firstName: _firstNameController.text.trim().isEmpty 
            ? null 
            : _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim().isEmpty 
            ? null 
            : _lastNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim().isEmpty 
            ? null 
            : _phoneNumberController.text.trim(),
        bio: _bioController.text.trim().isEmpty 
            ? null 
            : _bioController.text.trim(),
        website: _websiteController.text.trim().isEmpty 
            ? null 
            : _websiteController.text.trim(),
        location: _locationController.text.trim().isEmpty 
            ? null 
            : _locationController.text.trim(),
        dateOfBirth: _selectedDateOfBirth,
        gender: _selectedGender,
        privacyLevel: _selectedPrivacyLevel,
        interests: _parseInterests(_interestsController.text),
        photoUrl: imageUrl ?? widget.userProfile?.photoUrl,
        updatedAt: DateTime.now(),
      );

      // Save profile
      if (widget.isCreatingNew) {
        await provider.createUserProfile(updatedProfile);
      } else {
        await provider.updateUserProfile(updatedProfile);
      }

      if (mounted && provider.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isCreatingNew 
                ? 'Profile created successfully!' 
                : 'Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}