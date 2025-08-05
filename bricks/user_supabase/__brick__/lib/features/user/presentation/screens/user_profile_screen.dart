import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/user_provider.dart';
import '../widgets/profile_completion_indicator.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_text_styles.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).subscribeToUserProfile(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        backgroundColor: ThemeColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _navigateToEditProfile();
                  break;
                case 'delete':
                  _showDeleteDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('프로필 수정'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('프로필 삭제', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final userState = ref.watch(userProvider);
          return userState.when(
            data: (state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '오류가 발생했습니다',
                        style: ThemeTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.error!,
                        style: ThemeTextStyles.bodyMedium?.copyWith(
                          color: Colors.red[300],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(userProvider.notifier).getUserProfile(widget.userId),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                );
              }

              if (state.userProfile == null) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text('프로필을 찾을 수 없습니다'),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref.read(userProvider.notifier).getUserProfile(widget.userId),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildProfileHeader(state.userProfile!),
                      const SizedBox(height: 24),
                      ProfileCompletionIndicator(
                        userProfile: state.userProfile!,
                        onTap: _navigateToEditProfile,
                      ),
                      const SizedBox(height: 24),
                      _buildProfileInfo(state.userProfile!),
                      const SizedBox(height: 24),
                      _buildPersonalInfo(state.userProfile!),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '오류가 발생했습니다',
                    style: ThemeTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: ThemeTextStyles.bodyMedium?.copyWith(
                      color: Colors.red[300],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.read(userProvider.notifier).getUserProfile(widget.userId),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile userProfile) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ThemeColors.primary.withOpacity(0.3),
              width: 3,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: userProfile.photoUrl != null
                ? Image.network(
                    userProfile.profileImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildDefaultAvatar();
                    },
                  )
                : _buildDefaultAvatar(),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userProfile.fullName,
          style: ThemeTextStyles.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        if (userProfile.bio?.isNotEmpty == true) ...[
          Text(
            userProfile.bio!,
            style: ThemeTextStyles.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.email_outlined,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              userProfile.email,
              style: ThemeTextStyles.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        if (userProfile.location?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                userProfile.location!,
                style: ThemeTextStyles.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeColors.primary.withOpacity(0.1),
      ),
      child: Icon(
        Icons.person,
        size: 60,
        color: ThemeColors.primary,
      ),
    );
  }

  Widget _buildProfileInfo(UserProfile userProfile) {
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
                Icon(
                  Icons.info_outline,
                  color: ThemeColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '기본 정보',
                  style: ThemeTextStyles.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('이메일', userProfile.email, Icons.email_outlined),
            if (userProfile.phoneNumber?.isNotEmpty == true)
              _buildInfoRow('전화번호', userProfile.phoneNumber!, Icons.phone_outlined),
            if (userProfile.website?.isNotEmpty == true)
              _buildInfoRow('웹사이트', userProfile.website!, Icons.language_outlined),
            if (userProfile.age != null)
              _buildInfoRow('나이', '${userProfile.age}세', Icons.cake_outlined),
            _buildInfoRow('가입 경과', '${userProfile.daysSinceJoined}일', Icons.calendar_today_outlined),
            if (userProfile.daysSinceLastSignIn != null)
              _buildInfoRow('마지막 로그인', '${userProfile.daysSinceLastSignIn}일 전', Icons.access_time_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(UserProfile userProfile) {
    if (userProfile.interests.isEmpty && 
        userProfile.gender == UserGender.notSpecified &&
        userProfile.privacyLevel == UserPrivacyLevel.public) {
      return const SizedBox.shrink();
    }

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
                Icon(
                  Icons.person_outline,
                  color: ThemeColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '개인 정보',
                  style: ThemeTextStyles.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (userProfile.gender != UserGender.notSpecified)
              _buildInfoRow('성별', _getGenderText(userProfile.gender), Icons.person_outline),
            _buildInfoRow('프로필 공개', _getPrivacyText(userProfile.privacyLevel), Icons.visibility_outlined),
            if (userProfile.interests.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '관심사',
                style: ThemeTextStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: userProfile.interests.map((interest) {
                  return Chip(
                    label: Text(
                      interest,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: ThemeColors.primary.withOpacity(0.1),
                    side: BorderSide(color: ThemeColors.primary.withOpacity(0.3)),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ThemeTextStyles.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: ThemeTextStyles.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGenderText(UserGender gender) {
    switch (gender) {
      case UserGender.male:
        return '남성';
      case UserGender.female:
        return '여성';
      case UserGender.nonBinary:
        return '논바이너리';
      case UserGender.notSpecified:
        return '미지정';
    }
  }

  String _getPrivacyText(UserPrivacyLevel level) {
    switch (level) {
      case UserPrivacyLevel.public:
        return '공개';
      case UserPrivacyLevel.friendsOnly:
        return '친구만';
      case UserPrivacyLevel.private:
        return '비공개';
    }
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _navigateToEditProfile,
            icon: const Icon(Icons.edit),
            label: const Text('프로필 수정'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showDeleteDialog,
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('프로필 삭제', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToEditProfile() {
    // Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('프로필 수정 화면으로 이동')),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로필 삭제'),
        content: const Text('정말로 프로필을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteProfile();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _deleteProfile() async {
    await ref.read(userProvider.notifier).deleteUserProfile(widget.userId);

    if (mounted) {
      final currentState = ref.read(userProvider);
      currentState.whenData((state) {
        if (state.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('프로필이 삭제되었습니다')),
          );
          Navigator.of(context).pop();
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}