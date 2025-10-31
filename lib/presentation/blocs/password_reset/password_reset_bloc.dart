import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/auth/forgot_password_usecase.dart';
import '../../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../../domain/usecases/auth/reset_password_usecase.dart';
import 'password_reset_event.dart';
import 'password_reset_state.dart';
@injectable
class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  PasswordResetBloc(
    this._forgotPasswordUseCase,
    this._verifyOtpUseCase,
    this._resetPasswordUseCase,
  ) : super(const PasswordResetState()) {
    on<PasswordResetEmailChanged>(_onEmailChanged);
    on<PasswordResetOtpChanged>(_onOtpChanged);
    on<PasswordResetNewPasswordChanged>(_onNewPasswordChanged);
    on<PasswordResetConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<PasswordResetEmailRequested>(_onEmailRequested);
    on<PasswordResetOtpVerified>(_onOtpVerified);
    on<PasswordResetConfirmed>(_onPasswordResetConfirmed);
    on<PasswordResetOtpResendRequested>(_onOtpResendRequested);
    on<PasswordResetNextStep>(_onNextStep);
    on<PasswordResetPreviousStep>(_onPreviousStep);
    on<PasswordResetFlowReset>(_onFlowReset);
  }

  Timer? _otpTimer;

  @override
  Future<void> close() {
    _otpTimer?.cancel();
    return super.close();
  }
  void _onEmailChanged(
    PasswordResetEmailChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    final isValid = _validateEmail(event.email);
    emit(state.copyWith(
      email: event.email,
      isEmailValid: isValid,
      errorMessage: null,
    ));
  }
  void _onOtpChanged(
    PasswordResetOtpChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    final isValid = _validateOtp(event.otp);
    emit(state.copyWith(
      otp: event.otp,
      isOtpValid: isValid,
      errorMessage: null,
    ));
  }
  void _onNewPasswordChanged(
    PasswordResetNewPasswordChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    final isValid = _validatePassword(event.password);
    final passwordsMatch = event.password == state.confirmPassword;
    
    emit(state.copyWith(
      newPassword: event.password,
      isNewPasswordValid: isValid,
      passwordsMatch: passwordsMatch,
      errorMessage: null,
    ));
  }
  void _onConfirmPasswordChanged(
    PasswordResetConfirmPasswordChanged event,
    Emitter<PasswordResetState> emit,
  ) {
    final isValid = _validatePassword(event.confirmPassword);
    final passwordsMatch = state.newPassword == event.confirmPassword;
    
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      isConfirmPasswordValid: isValid,
      passwordsMatch: passwordsMatch,
      errorMessage: null,
    ));
  }
  Future<void> _onEmailRequested(
    PasswordResetEmailRequested event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (!state.isEmailValid) return;

    emit(state.copyWith(status: PasswordResetStatus.loading));

    try {
      await _forgotPasswordUseCase.call(email: event.email);
      
      emit(state.copyWith(
        status: PasswordResetStatus.emailSent,
        step: PasswordResetStep.otp,
      ));
      _startOtpTimer(emit);
    } catch (e) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
  Future<void> _onOtpVerified(
    PasswordResetOtpVerified event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (!state.isOtpValid) return;

    emit(state.copyWith(status: PasswordResetStatus.loading));

    try {
      final result = await _verifyOtpUseCase.call(otp: event.otpCode);
      emit(state.copyWith(
        status: PasswordResetStatus.otpVerified,
        step: PasswordResetStep.newPassword,
        email: result.email, // Use the email from the API response
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
  Future<void> _onPasswordResetConfirmed(
    PasswordResetConfirmed event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (!state.isCurrentStepValid) return;

    emit(state.copyWith(status: PasswordResetStatus.loading));

    try {
      await _resetPasswordUseCase.call(
        email: state.email,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );
      
      emit(state.copyWith(status: PasswordResetStatus.passwordReset));
    } catch (e) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
  Future<void> _onOtpResendRequested(
    PasswordResetOtpResendRequested event,
    Emitter<PasswordResetState> emit,
  ) async {
    if (!state.canResendOtp) return;

    emit(state.copyWith(status: PasswordResetStatus.loading));

    try {
      await _forgotPasswordUseCase.call(email: state.email);
      
      emit(state.copyWith(
        status: PasswordResetStatus.emailSent,
        canResendOtp: false,
      ));
      _startOtpTimer(emit);
    } catch (e) {
      emit(state.copyWith(
        status: PasswordResetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
  void _onNextStep(
    PasswordResetNextStep event,
    Emitter<PasswordResetState> emit,
  ) {
    switch (state.step) {
      case PasswordResetStep.email:
        if (state.status == PasswordResetStatus.emailSent) {
          emit(state.copyWith(step: PasswordResetStep.otp));
        }
        break;
      case PasswordResetStep.otp:
        if (state.status == PasswordResetStatus.otpVerified) {
          emit(state.copyWith(step: PasswordResetStep.newPassword));
        }
        break;
      case PasswordResetStep.newPassword:
        break;
    }
  }
  void _onPreviousStep(
    PasswordResetPreviousStep event,
    Emitter<PasswordResetState> emit,
  ) {
    switch (state.step) {
      case PasswordResetStep.email:
        break;
      case PasswordResetStep.otp:
        emit(state.copyWith(
          step: PasswordResetStep.email,
          status: PasswordResetStatus.initial,
        ));
        break;
      case PasswordResetStep.newPassword:
        emit(state.copyWith(
          step: PasswordResetStep.otp,
          status: PasswordResetStatus.emailSent,
        ));
        break;
    }
  }
  void _onFlowReset(
    PasswordResetFlowReset event,
    Emitter<PasswordResetState> emit,
  ) {
    _otpTimer?.cancel();
    emit(const PasswordResetState());
  }
  void _startOtpTimer(Emitter<PasswordResetState> emit) {
    _otpTimer?.cancel();
    
    const cooldownSeconds = 60;
    emit(state.copyWith(
      canResendOtp: false,
      otpResendCooldown: cooldownSeconds,
    ));

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingSeconds = cooldownSeconds - timer.tick;
      
      if (remainingSeconds <= 0) {
        timer.cancel();
        if (!isClosed) {
          emit(state.copyWith(
            canResendOtp: true,
            otpResendCooldown: 0,
          ));
        }
      } else {
        if (!isClosed) {
          emit(state.copyWith(otpResendCooldown: remainingSeconds));
        }
      }
    });
  }
  bool _validateEmail(String email) {
    return email.isNotEmpty && 
           email.contains('@') && 
           email.contains('.') &&
           RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  bool _validateOtp(String otp) {
    return otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);
  }
  bool _validatePassword(String password) {
    return password.length >= 8 &&
           RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password);
  }
}

