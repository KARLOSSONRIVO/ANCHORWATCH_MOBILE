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
import 'data/repositories/auth_repository_impl.dart' as _i145;
import 'domain/repositories/auth_repository.dart' as _i716;
import 'domain/use_cases/auth/login_use_case.dart' as _i613;
import 'presentation/blocs/alerts/alerts_bloc.dart' as _i9;
import 'presentation/blocs/anchorwise/anchorwise_bloc.dart' as _i320;
import 'presentation/blocs/authentication/authentication_bloc.dart' as _i259;
import 'presentation/blocs/contact/contact_bloc.dart' as _i945;
import 'presentation/blocs/faq/faq_bloc.dart' as _i855;
import 'presentation/blocs/navigation/navigation_bloc.dart' as _i62;
import 'presentation/blocs/onboarding/onboarding_bloc.dart' as _i131;
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
    gh.factory<_i855.FaqBloc>(() => _i855.FaqBloc());
    gh.factory<_i62.NavigationBloc>(() => _i62.NavigationBloc());
    gh.factory<_i131.OnboardingBloc>(() => _i131.OnboardingBloc());
    gh.factory<_i226.ProfileBloc>(() => _i226.ProfileBloc());
    gh.lazySingleton<_i332.DioClient>(() => _i332.DioClient());
    gh.lazySingleton<_i646.TokenStorageService>(
      () => _i646.TokenStorageService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i86.AuthRemoteDataSource>(
      () => _i86.AuthRemoteDataSourceImpl(dioClient: gh<_i332.DioClient>()),
    );
    gh.lazySingleton<_i460.AuthenticationService>(
      () => _i460.AuthenticationService(gh<_i646.TokenStorageService>()),
    );
    gh.lazySingleton<_i716.AuthRepository>(
      () => _i145.AuthRepositoryImpl(
        remoteDataSource: gh<_i86.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i613.LoginUseCase>(
      () => _i613.LoginUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i259.AuthenticationBloc>(
      () => _i259.AuthenticationBloc(
        gh<_i613.LoginUseCase>(),
        gh<_i460.AuthenticationService>(),
      ),
    );
    return this;
  }
}
