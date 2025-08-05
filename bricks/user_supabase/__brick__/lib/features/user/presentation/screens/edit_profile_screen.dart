import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/user_provider.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_text_styles.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserProfile userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameController;
  late final TextEditingController _phoneNumberController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.userProfile.displayName ?? '',
    );
    _phoneNumberController = TextEditingController(
      text: widget.userProfile.phoneNumber ?? '',
    );

    _displayNameController.addListener(_onTextChanged);
    _phoneNumberController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasChanges =
        _displayNameController.text != (widget.userProfile.displayName ?? '') ||
        _phoneNumberController.text != (widget.userProfile.phoneNumber ?? '');

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 수정'),
        backgroundColor: ThemeColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                '저장',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImageSection(),
              const SizedBox(height: 32),
              _buildFormFields(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: ThemeColors.primary.withOpacity(0.1),
                backgroundImage: widget.userProfile.photoUrl != null
                    ? NetworkImage(widget.userProfile.photoUrl!)
                    : null,
                child: widget.userProfile.photoUrl == null
                    ? Icon(Icons.person, size: 60, color: ThemeColors.primary)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _changeProfileImage,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '프로필 사진 변경',
            style: ThemeTextStyles.bodySmall?.copyWith(
              color: ThemeColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('기본 정보', style: ThemeTextStyles.titleLarge),
        const SizedBox(height: 16),
        TextFormField(
          controller: _displayNameController,
          decoration: const InputDecoration(
            labelText: '이름',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '이름을 입력해주세요';
            }
            if (value.trim().length < 2) {
              return '이름은 2글자 이상이어야 합니다';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneNumberController,
          decoration: const InputDecoration(
            labelText: '전화번호',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
            hintText: '010-1234-5678',
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final phoneRegex = RegExp(r'^010-\d{4}-\d{4}$');
              if (!phoneRegex.hasMatch(value)) {
                return '올바른 전화번호 형식이 아닙니다 (010-1234-5678)';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.userProfile.email,
          decoration: const InputDecoration(
            labelText: '이메일',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !_hasChanges ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: ref
            .watch(userProvider)
            .when(
              data: (state) => state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('변경사항 저장'),
              loading: () => const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              error: (error, stack) => const Text('변경사항 저장'),
            ),
      ),
    );
  }

  void _changeProfileImage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('프로필 사진 변경 기능은 추후 구현 예정입니다')));
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedProfile = widget.userProfile.copyWith(
      displayName: _displayNameController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim().isEmpty
          ? null
          : _phoneNumberController.text.trim(),
      updatedAt: DateTime.now(),
    );

    await ref.read(userProvider.notifier).updateUserProfile(updatedProfile);

    if (mounted) {
      final userState = ref.read(userProvider);
      userState.whenData((state) {
        if (state.error == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('프로필이 성공적으로 업데이트되었습니다')));
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('업데이트 실패: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }
}
