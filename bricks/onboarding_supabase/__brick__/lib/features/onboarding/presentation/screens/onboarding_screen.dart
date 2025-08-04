import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/local/models/onboarding_data.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../../../../core/routes/route_names.dart';

/// 온보딩 화면을 표시하는 StatefulWidget
/// 
/// 앱을 처음 실행하는 사용자에게 주요 기능과 사용법을 안내하는 화면입니다.
/// PageView를 사용하여 여러 페이지를 스와이프로 탐색할 수 있으며,
/// 각 페이지는 제목, 설명, 이미지로 구성됩니다.
class OnboardingScreen extends StatefulWidget {
  /// 온보딩 페이지 리스트 (선택적)
  /// 
  /// 제공되지 않으면 기본 온보딩 페이지를 사용합니다.
  final List<OnboardingPage>? pages;

  /// 온보딩 완료 후 이동할 라우트 (선택적)
  /// 
  /// 제공되지 않으면 기본 로그인 화면으로 이동합니다.
  final String? nextRoute;

  /// 온보딩을 건너뛸 수 있는지 여부 (선택적)
  /// 
  /// 기본값은 true입니다.
  final bool? allowSkip;

  const OnboardingScreen({
    super.key,
    this.pages,
    this.nextRoute,
    this.allowSkip,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  /// 페이지 컨트롤러
  late PageController _pageController;
  
  /// 현재 페이지 인덱스
  int _currentPage = 0;
  
  /// 온보딩 페이지 리스트
  late List<OnboardingPage> _pages;
  
  /// 페이지 인디케이터 애니메이션 컨트롤러
  late AnimationController _indicatorAnimationController;
  
  /// 버튼 애니메이션 컨트롤러
  late AnimationController _buttonAnimationController;
  
  /// 페이드 애니메이션
  late Animation<double> _fadeAnimation;
  
  /// 슬라이드 애니메이션
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // 페이지 데이터 초기화
    _pages = widget.pages ?? OnboardingData.defaultPages;
    
    // 컨트롤러 초기화
    _pageController = PageController();
    
    // 애니메이션 컨트롤러 초기화
    _indicatorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // 애니메이션 설정
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    // 초기 애니메이션 시작
    _buttonAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 건너뛰기 버튼
            _buildTopBar(),
            
            // 메인 페이지뷰 영역
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            
            // 하단 네비게이션 영역
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  /// 상단 건너뛰기 버튼 영역
  Widget _buildTopBar() {
    final allowSkip = widget.allowSkip ?? OnboardingData.allowSkip;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 로고나 제목 공간
          Text(
            'Welcome',
            style: ThemeTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: ThemeColors.primary,
            ),
          ),
          
          // 건너뛰기 버튼
          if (allowSkip && _currentPage < _pages.length - 1)
            TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                '건너뛰기',
                style: ThemeTextStyles.bodyLarge.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 개별 온보딩 페이지 위젯
  Widget _buildPage(OnboardingPage page) {
    // 배경색 파싱
    Color? backgroundColor;
    if (page.backgroundColor != null) {
      try {
        backgroundColor = Color(
          int.parse(page.backgroundColor!.replaceFirst('#', '0xFF')),
        );
      } catch (e) {
        // 잘못된 색상 코드인 경우 기본색 사용
        backgroundColor = null;
      }
    }

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: backgroundColor != null
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          backgroundColor.withOpacity(0.1),
                          backgroundColor.withOpacity(0.05),
                        ],
                      ),
                    )
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 이미지 영역
                  _buildImage(page.imagePath),
                  
                  const SizedBox(height: 48),
                  
                  // 제목
                  Text(
                    page.title,
                    style: ThemeTextStyles.headlineLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: backgroundColor ?? ThemeColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 설명
                  Text(
                    page.description,
                    style: ThemeTextStyles.bodyLarge.copyWith(
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 이미지 위젯 생성
  Widget _buildImage(String imagePath) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _buildImageWidget(imagePath),
      ),
    );
  }

  /// 실제 이미지 위젯
  /// 
  /// 이미지 파일이 없는 경우 플레이스홀더 아이콘을 표시합니다.
  Widget _buildImageWidget(String imagePath) {
    // 실제 앱에서는 Image.asset을 사용하지만,
    // 템플릿에서는 아이콘을 사용하여 플레이스홀더로 대체
    return Container(
      color: ThemeColors.primary.withOpacity(0.1),
      child: Center(
        child: Icon(
          _getIconForPage(_currentPage),
          size: 120,
          color: ThemeColors.primary,
        ),
      ),
    );
  }

  /// 페이지별 아이콘 반환
  IconData _getIconForPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return Icons.waving_hand;
      case 1:
        return Icons.rocket_launch;
      case 2:
        return Icons.check_circle;
      default:
        return Icons.star;
    }
  }

  /// 하단 네비게이션 영역
  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // 페이지 인디케이터
          _buildPageIndicator(),
          
          const SizedBox(height: 32),
          
          // 네비게이션 버튼
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  /// 페이지 인디케이터
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? ThemeColors.primary
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  /// 네비게이션 버튼들
  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == _pages.length - 1;
    
    return Row(
      children: [
        // 이전 버튼
        if (_currentPage > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousPage,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: ThemeColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '이전',
                style: TextStyle(
                  color: ThemeColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        
        if (_currentPage > 0) const SizedBox(width: 16),
        
        // 다음/시작하기 버튼
        Expanded(
          child: ElevatedButton(
            onPressed: isLastPage ? _completeOnboarding : _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              isLastPage ? '시작하기' : '다음',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 페이지 변경 시 호출되는 콜백
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    
    // 페이지 변경 애니메이션
    _buttonAnimationController.reset();
    _buttonAnimationController.forward();
  }

  /// 다음 페이지로 이동
  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 이전 페이지로 이동
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 온보딩 완료 처리
  Future<void> _completeOnboarding() async {
    try {
      // SharedPreferences에 온보딩 완료 상태 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      
      // 지정된 라우트로 이동
      final nextRoute = widget.nextRoute ?? 
                      OnboardingData.defaultNextRoute;
      
      if (mounted) {
        // 온보딩 화면을 스택에서 완전히 제거하고 다음 화면으로 이동
        context.go(nextRoute);
      }
    } catch (e) {
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('온보딩 완료 처리 중 오류가 발생했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}