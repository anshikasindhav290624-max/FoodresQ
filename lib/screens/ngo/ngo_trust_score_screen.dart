import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class NgoTrustScoreScreen extends StatelessWidget {
  const NgoTrustScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final score = state.trustScore;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('NGO Trust Score Details'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score Header Hero Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.ngoPrimary,
                    AppColors.ngoPrimary.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ngoPrimary.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TRUST ACCOUNTABILITY METRIC',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white70,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '+${score.monthlyDelta} THIS MONTH',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '⭐ ${score.overallScore}',
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        ' / 100',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'STATUS LEVEL: ${score.trustLevel}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: score.levelColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6 Weighted Component Scoring Breakdown
            const Text(
              '6 Scoring Components Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'The Trust Score dynamically measures actual operational performance across 6 factors:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            _buildScoreItem('Successful Food Collections', score.collectionScore, 25, '25 Points Max', AppColors.ngoPrimary),
            _buildScoreItem('Successful Food Distribution', score.distributionScore, 30, '30 Points Max', AppColors.success),
            _buildScoreItem('Acceptance Reliability', score.acceptanceScore, 15, '15 Points Max', AppColors.info),
            _buildScoreItem('On-Time Pickup Rate', score.pickupScore, 15, '15 Points Max', AppColors.warning),
            _buildScoreItem('Completion Consistency', score.completionScore, 10, '10 Points Max', AppColors.aiAccent),
            _buildScoreItem('Verified Impact Reporting', score.verifiedImpactScore, 5, '5 Points Max', AppColors.ngoPrimary),

            const SizedBox(height: 24),

            // Trust Score Scale Levels Reference
            const Text(
              'Trust Level Tier Reference',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildLevelRow('🟢 90–100', 'EXCELLENT', 'Priority cascade dispatch & instant matching'),
                  const Divider(height: 16),
                  _buildLevelRow('🔵 75–89', 'TRUSTED', 'Verified active partner with high pickup rate'),
                  const Divider(height: 16),
                  _buildLevelRow('🟡 60–74', 'GOOD', 'Standard matching eligibility'),
                  const Divider(height: 16),
                  _buildLevelRow('🟠 40–59', 'DEVELOPING', 'Under performance review'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Score Audit Log
            const Text(
              'Recent Score Audit Log',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            ...score.recentImprovements.map((log) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle_outline, color: AppColors.success, size: 18),
                      const SizedBox(width: 10),
                      Text(log, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.success, fontSize: 13)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String title, int current, int max, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              Text('$current / $max pts', style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: current / max,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelRow(String range, String title, String desc) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(range, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        SizedBox(
          width: 100,
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
        ),
        Expanded(
          child: Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}
