import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/speaker_button.dart';
import 'caregiver_registration_data.dart';
import 'caregiver_auth_service.dart';
import 'create_pin_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final CaregiverRegistrationData registrationData;
  final String? verificationId;
  final int? resendToken;
  final bool alreadyVerified;

  const OtpVerificationScreen({
  super.key,
  required this.registrationData,
  required this.verificationId,
  required this.resendToken,
  this.alreadyVerified = false,
});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 30;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  Timer? _timer;
  int _secondsRemaining = _resendSeconds;
  String? _errorText;
  bool _isVerifying = false;
  bool _isResending = false;
  String? _verificationId;
  int? _resendToken;  

  @override
void initState() {
  super.initState();

  _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );

  _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  _verificationId = widget.verificationId;
  _resendToken = widget.resendToken;

  _startResendTimer();
}

Future<void> _resendOtp() async {
  if (_isResending) return;

  setState(() {
    _isResending = true;
    _errorText = null;
  });

  try {
    await CaregiverAuthService.instance.sendOtp(
      phoneNumber: widget.registrationData.phoneNumber,
      forceResendingToken: _resendToken,
      onCodeSent: (verificationId, resendToken) {
        if (!mounted) return;

        setState(() {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _isResending = false;
        });

        for (final controller in _controllers) {
          controller.clear();
        }

        _focusNodes.first.requestFocus();
        _startResendTimer();
      },
      onVerificationFailed: (FirebaseAuthException error) {
        if (!mounted) return;

        setState(() {
          _isResending = false;
          _errorText =
              error.message ?? 'Could not resend OTP. Please try again.';
        });
      },
      onVerificationCompleted: (PhoneAuthCredential credential) {
        if (!mounted) return;

        setState(() {
          _isResending = false;
        });
      },
    );
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _isResending = false;
      _errorText = 'Could not resend OTP. Please try again.';
    });
  }
}

 void _startResendTimer() {
  _timer?.cancel();

  if (!mounted) return;

  setState(() => _secondsRemaining = _resendSeconds);

  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }

    if (_secondsRemaining <= 1) {
      timer.cancel();
      setState(() => _secondsRemaining = 0);
    } else {
      setState(() => _secondsRemaining--);
    }
  });
}

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredCode => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (mounted) {
      setState(() => _errorText = null);
    }
  }

 Future<void> _onVerify(AppLocalizations l10n) async {
  if (_enteredCode.length < _otpLength) {
    setState(() => _errorText = l10n.otpIncomplete);
    return;
  }

  void goToCreatePin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreatePinScreen(
          registrationData: widget.registrationData,
        ),
      ),
    );
  }

  if (widget.alreadyVerified) {
    goToCreatePin();
    return;
  }

  if (_verificationId == null || _verificationId!.isEmpty) {
    setState(() {
      _errorText = 'OTP session expired. Please resend the OTP.';
    });
    return;
  }

  if (_isVerifying) return;

  setState(() {
    _isVerifying = true;
    _errorText = null;
  });

  try {
    await CaregiverAuthService.instance.verifyOtp(
      verificationId: _verificationId!,
      smsCode: _enteredCode,
    );

    if (!mounted) return;

    goToCreatePin();
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    setState(() {
      _isVerifying = false;

      if (e.code == 'invalid-verification-code') {
        _errorText = 'The OTP is incorrect. Please try again.';
      } else if (e.code == 'session-expired') {
        _errorText = 'The OTP has expired. Please resend a new OTP.';
      } else {
        _errorText = e.message ?? 'OTP verification failed. Please try again.';
      }
    });
  } catch (_) {
    if (!mounted) return;

    setState(() {
      _isVerifying = false;
      _errorText = 'Something went wrong. Please try again.';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguageController.instance,
      builder: (context, _) {
        final l10n = AppLocalizations.current();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Navigator.pop(context),
                      ),
                      SpeakerButton(
                        text: '${l10n.enterOtp}. ${l10n.weveSentCodeTo} '
                            '${widget.registrationData.phoneNumber}',
                        size: 48,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.enterOtp,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.weveSentCodeTo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.registrationData.phoneNumber,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_otpLength, (index) {
                      return SizedBox(
                        width: 44,
                        height: 54,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.primaryGreen, width: 2),
                            ),
                          ),
                          onChanged: (value) => _onDigitChanged(index, value),
                        ),
                      );
                    }),
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _errorText!,
                      style: const TextStyle(color: AppColors.error, fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text(
                    _secondsRemaining > 0
                        ? '${l10n.resendOtpIn} '
                            '00:${_secondsRemaining.toString().padLeft(2, '0')}'
                        : '',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _onVerify(l10n),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isVerifying
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              l10n.verify,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Icon(Icons.mark_email_read_outlined,
                      size: 48, color: AppColors.primaryGreen),
                  const SizedBox(height: 10),
                  Text(
                    l10n.didntReceiveCode,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: _secondsRemaining == 0 && !_isResending
                        ? _resendOtp
                        : null,
                    child: Text(
                      l10n.resendOtp,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Icon(icon, size: 20, color: AppColors.textDark),
        ),
      ),
    );
  }
}