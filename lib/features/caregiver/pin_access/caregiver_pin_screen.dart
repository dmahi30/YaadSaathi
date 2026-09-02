import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/game_session.dart';
import '../dashboard/caregiver_dashboard_screen.dart';
import 'pin_controller.dart';

class CaregiverPinScreen extends StatefulWidget {
  final GameSession? session;
  const CaregiverPinScreen({super.key, this.session});

  @override
  State<CaregiverPinScreen> createState() => _CaregiverPinScreenState();
}

class _CaregiverPinScreenState extends State<CaregiverPinScreen> {
  late final PinController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PinController();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    if (!mounted) return;
    setState(() {});

    if (_controller.length == 4) {
      if (_controller.isCorrect) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const CaregiverDashboardScreen(),
            ),
          );
        });
      } else {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) _controller.reset();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onKeyTap(String key) {
    if (key == 'del') {
      _controller.removeDigit();
    } else {
      _controller.addDigit(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                ),
              ),
              const SizedBox(height: 12),
              const Icon(Icons.lock_outline, size: 48, color: AppColors.primaryGreen),
              const SizedBox(height: 16),
              Text('Caregiver Access', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Enter 4-digit PIN', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _controller.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.hasError
                          ? AppColors.error
                          : (filled ? AppColors.primaryGreen : AppColors.border),
                    ),
                  );
                }),
              ),
              if (_controller.hasError) ...[
                const SizedBox(height: 12),
                const Text('Incorrect PIN. Try again.',
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
              ],
              const SizedBox(height: 36),
              Expanded(child: _buildKeypad()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'];

    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.6,
      children: keys.map((key) {
        if (key.isEmpty) return const SizedBox.shrink();
        return Material(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _onKeyTap(key),
            child: Center(
              child: key == 'del'
                  ? const Icon(Icons.backspace_outlined, color: AppColors.textDark)
                  : Text(key,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
            ),
          ),
        );
      }).toList(),
    );
  }
}