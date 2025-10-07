// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'data/datasources/remote/auth_remote_datasource.dart' as _i86;
import 'data/datasources/remote/dashboard_remote_datasource.dart' as _i807;
import 'data/datasources/remote/macro_trends_remote_data_source.dart' as _i743;
import 'data/datasources/remote/stablecoin_remote_data_source.dart' as _i196;
import 'data/repositories/auth_repository_impl.dart' as _i145;
import 'data/repositories/dashboard_repository_impl.dart' as _i855;
import 'data/repositories/macro_trends_repository_impl.dart' as _i461;
import 'data/repositories/stablecoin_repository_impl.dart' as _i658;
import 'domain/repositories/auth_repository.dart' as _i716;
import 'domain/repositories/dashboard_repository.dart' as _i564;
import 'domain/repositories/macro_trends_repository.dart' as _i893;
import 'domain/repositories/stablecoin_repository.dart' as _i58;
import 'domain/usecases/auth/forgot_password_usecase.dart' as _i512;
import 'domain/usecases/auth/login_usecase.dart' as _i289;
import 'domain/usecases/auth/register_usecase.dart' as _i339;
import 'domain/usecases/auth/reset_password_usecase.dart' as _i461;
import 'domain/usecases/auth/verify_otp_usecase.dart' as _i33;
import 'domain/usecases/dashboard/fetch_dashboard_metrics_usecase.dart'
    as _i711;
import 'domain/usecases/get_macro_trends_usecase.dart' as _i40;
import 'domain/usecases/stablecoin/get_stablecoin_chart_data_usecase.dart'
    as _i711;
import 'presentation/blocs/alerts/alerts_bloc.dart' as _i9;
import 'presentation/blocs/anchorwise/anchorwise_bloc.dart' as _i320;
import 'presentation/blocs/authentication/authentication_bloc.dart' as _i259;
import 'presentation/blocs/contact/contact_bloc.dart' as _i945;
import 'presentation/blocs/dashboard/dashboard_bloc.dart' as _i37;
import 'presentation/blocs/discover/articles/articles_bloc.dart' as _i100;
import 'presentation/blocs/discover/macro_trends/macro_trends_bloc.dart'
    as _i221;
import 'presentation/blocs/discover/stablecoin/stablecoin_bloc.dart' as _i379;
import 'presentation/blocs/faq/faq_bloc.dart' as _i855;
import 'presentation/blocs/navigation/navigation_bloc.dart' as _i62;
import 'presentation/blocs/onboarding/onboarding_bloc.dart' as _i131;
import 'presentation/blocs/password_reset/password_reset_bloc.dart' as _i580;
import 'presentation/blocs/profile/profile_bloc.dart' as _i226;
import 'services/authentication_service.dart' as _i460;
import 'services/dio_client.dart' as _i332;
import 'services/token_storage_service.dart' as _i646;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i9.AlertsBloc>(() => _i9.AlertsBloc());
    gh.factory<_i320.AnchorWiseBloc>(() => _i320.AnchorWiseBloc());
    gh.factory<_i945.ContactBloc>(() => _i945.ContactBloc());
    gh.factory<_i100.ArticlesBloc>(() => _i100.ArticlesBloc());
    gh.factory<_i855.FaqBloc>(() => _i855.FaqBloc());
    gh.factory<_i62.NavigationBloc>(() => _i62.NavigationBloc());
    gh.factory<_i131.OnboardingBloc>(() => _i131.OnboardingBloc());
    gh.lazySingleton<_i332.DioClient>(() => _i332.DioClient());
    gh.lazySingleton<_i807.DashboardRemoteDataSource>(
      () => _i807.LiveDashboardRemoteDataSource(gh<_i332.DioClient>()),
    );
    gh.lazySingleton<_i646.TokenStorageService>(
      () => _i646.TokenStorageService(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i196.StablecoinRemoteDataSource>(
      () => _i196.StablecoinRemoteDataSource(gh<_i332.DioClient>()),
    );
    gh.factory<_i743.MacroTrendsRemoteDataSource>(
      () => _i743.MacroTrendsRemoteDataSource(gh<_i332.DioClient>()),
    );
    gh.lazySingleton<_i86.AuthRemoteDataSource>(
      () => _i86.AuthRemoteDataSourceImpl(dioClient: gh<_i332.DioClient>()),
    );
    gh.factory<_i58.StablecoinRepository>(
      () => _i658.StablecoinRepositoryImpl(
        gh<_i196.StablecoinRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i564.DashboardRepository>(
      () =>
          _i855.DashboardRepositoryImpl(gh<_i807.DashboardRemoteDataSource>()),
    );
    gh.factory<_i893.MacroTrendsRepository>(
      () => _i461.MacroTrendsRepositoryImpl(
        gh<_i743.MacroTrendsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i460.AuthenticationService>(
      () => _i460.AuthenticationService(
        gh<_i646.TokenStorageService>(),
        gh<_i332.DioClient>(),
      ),
    );
    gh.lazySingleton<_i716.AuthRepository>(
      () => _i145.AuthRepositoryImpl(
        remoteDataSource: gh<_i86.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i711.FetchDashboardMetricsUseCase>(
      () => _i711.FetchDashboardMetricsUseCase(gh<_i564.DashboardRepository>()),
    );
    gh.factory<_i711.GetStablecoinChartDataUseCase>(
      () =>
          _i711.GetStablecoinChartDataUseCase(gh<_i58.StablecoinRepository>()),
    );
    gh.factory<_i40.GetMacroTrendsUseCase>(
      () => _i40.GetMacroTrendsUseCase(gh<_i893.MacroTrendsRepository>()),
    );
    gh.factory<_i379.StablecoinBloc>(
      () => _i379.StablecoinBloc(gh<_i711.GetStablecoinChartDataUseCase>()),
    );
    gh.factory<_i512.ForgotPasswordUseCase>(
      () => _i512.ForgotPasswordUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i289.LoginUseCase>(
      () => _i289.LoginUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i339.RegisterUseCase>(
      () => _i339.RegisterUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i461.ResetPasswordUseCase>(
      () => _i461.ResetPasswordUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i33.VerifyOtpUseCase>(
      () => _i33.VerifyOtpUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i226.ProfileBloc>(
      () => _i226.ProfileBloc(gh<_i460.AuthenticationService>()),
    );
    gh.factory<_i37.DashboardBloc>(
      () => _i37.DashboardBloc(gh<_i711.FetchDashboardMetricsUseCase>()),
    );
    gh.factory<_i221.MacroTrendsBloc>(
      () => _i221.MacroTrendsBloc(gh<_i40.GetMacroTrendsUseCase>()),
    );
    gh.factory<_i259.AuthenticationBloc>(
      () => _i259.AuthenticationBloc(
        gh<_i289.LoginUseCase>(),
        gh<_i339.RegisterUseCase>(),
        gh<_i460.AuthenticationService>(),
      ),
    );
    gh.factory<_i580.PasswordResetBloc>(
      () => _i580.PasswordResetBloc(
        gh<_i512.ForgotPasswordUseCase>(),
        gh<_i33.VerifyOtpUseCase>(),
        gh<_i461.ResetPasswordUseCase>(),
      ),
    );
    return this;
  }
}
