import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DetailTipsScreen extends StatelessWidget {
  const DetailTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroImage(),
                  _buildArticleContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.8),
        border: const Border(
          bottom: BorderSide(color: AppTheme.outlineVariant, width: 0.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
            ),
            const Expanded(
              child: Text(
                'Tips Kesehatan',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 280),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAahMCqsUOYWipIzQZ35uweZT0si_-Qt4snylr9Jbj1laxv7RdgmsMLAW7u13xa2hSYceO2Uq-l-sm58eRMW_36d3jcMfU2TxHaqKrFGQp-0tAAyHuVh7dC7WwvptUiqS1xI1LTB1yhHugpk9U87_-LuvkjLPLWCCpJ259n3btpPgUJhIN0mn19cbZTQsbvGXGOOKZW_AXAJaamE97AmiDP3k6FAmRdCslRo06LMQbaL-vCjo7JrJSW2qYb7nGq4H3hmimUBkbFuw',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryContainer,
                    AppTheme.primary,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.self_improvement,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildArticleContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildCategoryAndReadTime(),
          const SizedBox(height: 16),
          const Text(
            'Cara Mengurangi Kram Menstruasi',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurface,
              height: 1.29,
              letterSpacing: -0.01,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Kram menstruasi, atau dismenore, adalah rasa sakit yang dialami banyak wanita sebelum atau selama masa menstruasi. Hal ini terjadi karena kontraksi pada rahim yang dipicu oleh hormon prostaglandin. Rasa nyeri ini bisa sangat mengganggu aktivitas, namun ada beberapa cara alami yang bisa membantu menenangkan tubuh Anda.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildTipCard(
            icon: Icons.thermostat,
            title: 'Kompres Hangat',
            description: 'Mengaplikasikan bantal pemanas atau botol air hangat ke perut bagian bawah dan punggung bawah dapat membantu merilekskan otot-otot rahim yang berkontraksi. Rasa hangat meningkatkan aliran darah dan mengurangi ketegangan saraf penyebab nyeri.',
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            icon: Icons.coffee,
            title: 'Minum Jahe Hangat',
            description: 'Jahe memiliki sifat anti-inflamasi alami yang bekerja serupa dengan obat pereda nyeri komersial. Secangkir teh jahe hangat dapat membantu menurunkan kadar prostaglandin yang menyebabkan rasa sakit dan mual saat menstruasi.',
          ),
          const SizedBox(height: 16),
          _buildTipCard(
            icon: Icons.self_improvement,
            title: 'Posisi Yoga',
            description: "Gerakan ringan seperti 'Child's Pose' atau 'Cat-Cow' sangat efektif untuk meregangkan panggul dan melepaskan ketegangan di punggung bawah. Fokuslah pada pernapasan perut yang dalam untuk memberikan sinyal relaksasi pada sistem saraf Anda.",
          ),
          const SizedBox(height: 32),
          _buildCTASection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCategoryAndReadTime() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Kesehatan Fisik',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Row(
          children: [
            Icon(
              Icons.schedule,
              size: 14,
              color: AppTheme.onSurfaceVariant,
            ),
            SizedBox(width: 4),
            Text(
              '5 menit baca',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A6f3347),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
        border: Border.all(
          color: AppTheme.outlineAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryContainer.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.secondary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.onSurfaceVariant,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -32,
            right: -32,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: AppTheme.onPrimaryContainer.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -32,
            left: -32,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppTheme.onPrimaryContainer.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              const Text(
                'Bermanfaat bagi orang lain?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Kesehatan reproduksi adalah topik yang perlu kita diskusikan lebih terbuka. Bagikan tips ini kepada teman atau keluarga Anda.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppTheme.onPrimaryContainer.withValues(alpha: 0.9),
                  height: 1.43,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.surfaceWhite,
                  foregroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 4,
                  shadowColor: AppTheme.primary.withValues(alpha: 0.2),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Bagikan tips ini',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
