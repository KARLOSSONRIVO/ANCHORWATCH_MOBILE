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

import 'data/datasources/remote/alert_remote_data_source.dart' as _i944;
import 'data/datasources/remote/anchorwise_remote_datasource.dart' as _i465;
import 'data/datasources/remote/articles_remote_data_source.dart' as _i235;
import 'data/datasources/remote/auth_remote_datasource.dart' as _i86;
import 'data/datasources/remote/chart_summary_remote_data_source.dart' as _i694;
import 'data/datasources/remote/contact_remote_datasource.dart' as _i850;
import 'data/datasources/remote/dashboard_remote_datasource.dart' as _i807;
import 'data/datasources/remote/macro_trends_remote_data_source.dart' as _i743;
import 'data/datasources/remote/profile_remote_datasource.dart' as _i671;
import 'data/datasources/remote/stablecoin_remote_data_source.dart' as _i196;
import 'data/repositories/alert_repository_impl.dart' as _i976;
import 'data/repositories/anchorwise_repository_impl.dart' as _i348;
import 'data/repositories/articles_repository_impl.dart' as _i998;
import 'data/repositories/auth_repository_impl.dart' as _i145;
import 'data/repositories/chart_summary_repository_impl.dart' as _i651;
import 'data/repositories/contact_repository_impl.dart' as _i95;
import 'data/repositories/dashboard_repository_impl.dart' as _i855;
import 'data/repositories/macro_trends_repository_impl.dart' as _i461;
import 'data/repositories/profile_repository_impl.dart' as _i1059;
import 'data/repositories/stablecoin_repository_impl.dart' as _i658;
import 'domain/repositories/alert_repository.dart' as _i692;
import 'domain/repositories/anchorwise_repository.dart' as _i135;
import 'domain/repositories/articles_repository.dart' as _i976;
import 'domain/repositories/auth_repository.dart' as _i716;
import 'domain/repositories/chart_summary_repository.dart' as _i427;
import 'domain/repositories/contact_repository.dart' as _i654;
import 'domain/repositories/dashboard_repository.dart' as _i564;
import 'domain/repositories/macro_trends_repository.dart' as _i893;
import 'domain/repositories/profile_repository.dart' as _i172;
import 'domain/repositories/stablecoin_repository.dart' as _i58;
import 'domain/usecases/alerts/acknowledge_alert_usecase.dart' as _i928;
import 'domain/usecases/alerts/get_alert_history_usecase.dart' as _i241;
import 'domain/usecases/alerts/resolve_alert_usecase.dart' as _i267;
import 'domain/usecases/anchorwise/create_new_conversation_usecase.dart'
    as _i625;
import 'domain/usecases/anchorwise/delete_conversation_usecase.dart' as _i258;
import 'domain/usecases/anchorwise/get_conversation_by_id_usecase.dart'
    as _i539;
import 'domain/usecases/anchorwise/get_conversations_usecase.dart' as _i1011;
import 'domain/usecases/anchorwise/send_chat_message_usecase.dart' as _i1011;
import 'domain/usecases/anchorwise/send_feedback_usecase.dart' as _i920;
import 'domain/usecases/auth/forgot_password_usecase.dart' as _i512;
import 'domain/usecases/auth/login_usecase.dart' as _i289;
import 'domain/usecases/auth/register_usecase.dart' as _i339;
import 'domain/usecases/auth/reset_password_usecase.dart' as _i461;
import 'domain/usecases/auth/verify_otp_usecase.dart' as _i33;
import 'domain/usecases/chart_summary/get_chart_summary_usecase.dart' as _i209;
import 'domain/usecases/contact/contact_support_usecase.dart' as _i364;
import 'domain/usecases/dashboard/fetch_dashboard_metrics_usecase.dart'
    as _i711;
import 'domain/usecases/get_articles_usecase.dart' as _i913;
import 'domain/usecases/get_macro_trends_usecase.dart' as _i40;
import 'domain/usecases/profile/change_password_usecase.dart' as _i183;
import 'domain/usecases/profile/change_username_usecase.dart' as _i244;
import 'domain/usecases/profile/confirm_change_email_usecase.dart' as _i140;
import 'domain/usecases/profile/request_change_email_usecase.dart' as _i1027;
import 'domain/usecases/stablecoin/get_stablecoin_chart_data_usecase.dart'
    as _i711;
import 'presentation/blocs/alerts/alerts_bloc.dart' as _i9;
import 'presentation/blocs/anchorwise/anchorwise_bloc.dart' as _i320;
import 'presentation/blocs/authentication/authentication_bloc.dart' as _i259;
import 'presentation/blocs/change_email/change_email_bloc.dart' as _i625;
import 'presentation/blocs/change_password/change_password_bloc.dart' as _i192;
import 'presentation/blocs/change_username/change_username_bloc.dart' as _i673;
import 'presentation/blocs/contact/contact_bloc.dart' as _i945;
import 'presentation/blocs/contact_support/contact_support_bloc.dart' as _i688;
import 'presentation/blocs/dashboard/dashboard_bloc.dart' as _i37;
import 'presentation/blocs/discover/articles/articles_bloc.dart' as _i100;
import 'presentation/blocs/discover/chart_summary/chart_summary_bloc.dart'
    as _i981;
import 'presentation/blocs/discover/macro_trends/macro_trends_bloc.dart'
    as _i221;
import 'presentation/blocs/discover/stablecoin/stablecoin_bloc.dart' as _i379;
import 'presentation/blocs/faq/faq_bloc.dart' as _i855;
import 'presentation/blocs/navigation/navigation_bloc.dart' as _i62;
import 'presentation/blocs/onboarding/onboarding_bloc.dart' as _i131;
import 'presentation/blocs/password_reset/password_reset_bloc.dart' as _i580;
import 'presentation/blocs/profile/profile_bloc.dart' as _i226;
import 'presentation/blocs/profile_picture/profile_picture_bloc.dart' as _i945;
import 'services/alert_websocket_service.dart' as _i459;
import 'services/authentication_service.dart' as _i460;
import 'services/dio_client.dart' as _i332;
import 'services/email_service.dart' as _i146;
import 'services/s3_upload_service.dart' as _i408;
import 'services/token_storage_service.dart' as _i646;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i855.FaqBloc>(() => _i855.FaqBloc());
    gh.factory<_i62.NavigationBloc>(() => _i62.NavigationBloc());
    gh.factory<_i131.OnboardingBloc>(() => _i131.OnboardingBloc());
    gh.lazySingleton<_i332.DioClient>(() => _i332.DioClient());
    gh.lazySingleton<_i408.S3UploadService>(() => _i408.S3UploadService());
    gh.lazySingleton<_i807.DashboardRemoteDataSource>(
      () => _i807.LiveDashboardRemoteDataSource(gh<_i332.DioClient>()),
    );
    gh.lazySingleton<_i646.TokenStorageService>(
      () => _i646.TokenStorageService(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i235.ArticlesRemoteDataSource>(
      () => _i235.ArticlesRemoteDataSource(gh<_i332.DioClient>()),
    );
    gh.factory<_i694.ChartSummaryRemoteDataSource>(
      () => _i694.ChartSummaryRemoteDataSource(gh<_i332.DioClient>()),
    );
    gh.factory<_i743.MacroTrendsRemoteDataSource>(
      () => _i743.MacroTrendsRemoteDataSource(gh<_i332.DioClient>()),
    );
    gh.factory<_i196.StablecoinRemoteDataSource>(
      () => _i196.StablecoinRemoteDataSource(gh<_i332.DioClient>()),
    );
    gh.lazySingleton<_i146.EmailService>(
      () => _i146.EmailService(gh<_i332.DioClient>()),
    );
    gh.singleton<_i459.AlertWebSocketService>(
      () => _i459.AlertWebSocketService(gh<_i146.EmailService>()),
    );
    gh.lazySingleton<_i86.AuthRemoteDataSource>(
      () => _i86.AuthRemoteDataSourceImpl(dioClient: gh<_i332.DioClient>()),
    );
    gh.lazySingleton<_i671.ProfileRemoteDataSource>(
      () => _i671.ProfileRemoteDataSourceImpl(dioClient: gh<_i332.DioClient>()),
    );
    gh.lazySingleton<_i944.AlertRemoteDataSource>(
      () => _i944.AlertRemoteDataSourceImpl(gh<_i332.DioClient>()),
    );
    gh.factory<_i58.StablecoinRepository>(
      () => _i658.StablecoinRepositoryImpl(
        gh<_i196.StablecoinRemoteDataSource>(),
      ),
    );
    gh.factory<_i465.AnchorWiseRemoteDataSource>(
      () => _i465.AnchorWiseRemoteDataSourceImpl(gh<_i332.DioClient>()),
    );
    gh.lazySingleton<_i564.DashboardRepository>(
      () =>
          _i855.DashboardRepositoryImpl(gh<_i807.DashboardRemoteDataSource>()),
    );
    gh.factory<_i692.AlertRepository>(
      () => _i976.AlertRepositoryImpl(gh<_i944.AlertRemoteDataSource>()),
    );
    gh.lazySingleton<_i172.ProfileRepository>(
      () => _i1059.ProfileRepositoryImpl(
        remoteDataSource: gh<_i671.ProfileRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i850.ContactRemoteDataSource>(
      () => _i850.ContactRemoteDataSourceImpl(dioClient: gh<_i332.DioClient>()),
    );
    gh.factory<_i893.MacroTrendsRepository>(
      () => _i461.MacroTrendsRepositoryImpl(
        gh<_i743.MacroTrendsRemoteDataSource>(),
      ),
    );
    gh.factory<_i135.AnchorWiseRepository>(
      () => _i348.AnchorWiseRepositoryImpl(
        gh<_i465.AnchorWiseRemoteDataSource>(),
      ),
    );
    gh.factory<_i945.ProfilePictureBloc>(
      () => _i945.ProfilePictureBloc(
        gh<_i671.ProfileRemoteDataSource>(),
        gh<_i408.S3UploadService>(),
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
    gh.factory<_i183.ChangePasswordUseCase>(
      () => _i183.ChangePasswordUseCase(gh<_i172.ProfileRepository>()),
    );
    gh.factory<_i244.ChangeUsernameUseCase>(
      () => _i244.ChangeUsernameUseCase(gh<_i172.ProfileRepository>()),
    );
    gh.factory<_i140.ConfirmChangeEmailUseCase>(
      () => _i140.ConfirmChangeEmailUseCase(gh<_i172.ProfileRepository>()),
    );
    gh.factory<_i1027.RequestChangeEmailUseCase>(
      () => _i1027.RequestChangeEmailUseCase(gh<_i172.ProfileRepository>()),
    );
    gh.factory<_i673.ChangeUsernameBloc>(
      () => _i673.ChangeUsernameBloc(gh<_i244.ChangeUsernameUseCase>()),
    );
    gh.factory<_i976.ArticlesRepository>(
      () => _i998.ArticlesRepositoryImpl(gh<_i235.ArticlesRemoteDataSource>()),
    );
    gh.factory<_i192.ChangePasswordBloc>(
      () => _i192.ChangePasswordBloc(gh<_i183.ChangePasswordUseCase>()),
    );
    gh.factory<_i625.CreateNewConversationUseCase>(
      () =>
          _i625.CreateNewConversationUseCase(gh<_i135.AnchorWiseRepository>()),
    );
    gh.factory<_i258.DeleteConversationUseCase>(
      () => _i258.DeleteConversationUseCase(gh<_i135.AnchorWiseRepository>()),
    );
    gh.factory<_i1011.GetConversationsUseCase>(
      () => _i1011.GetConversationsUseCase(gh<_i135.AnchorWiseRepository>()),
    );
    gh.factory<_i539.GetConversationByIdUseCase>(
      () => _i539.GetConversationByIdUseCase(gh<_i135.AnchorWiseRepository>()),
    );
    gh.factory<_i1011.SendChatMessageUseCase>(
      () => _i1011.SendChatMessageUseCase(gh<_i135.AnchorWiseRepository>()),
    );
    gh.factory<_i920.SendFeedbackUseCase>(
      () => _i920.SendFeedbackUseCase(gh<_i135.AnchorWiseRepository>()),
    );
    gh.factory<_i427.ChartSummaryRepository>(
      () => _i651.ChartSummaryRepositoryImpl(
        gh<_i694.ChartSummaryRemoteDataSource>(),
      ),
    );
    gh.factory<_i711.GetStablecoinChartDataUseCase>(
      () =>
          _i711.GetStablecoinChartDataUseCase(gh<_i58.StablecoinRepository>()),
    );
    gh.factory<_i625.ChangeEmailBloc>(
      () => _i625.ChangeEmailBloc(
        gh<_i1027.RequestChangeEmailUseCase>(),
        gh<_i140.ConfirmChangeEmailUseCase>(),
      ),
    );
    gh.factory<_i40.GetMacroTrendsUseCase>(
      () => _i40.GetMacroTrendsUseCase(gh<_i893.MacroTrendsRepository>()),
    );
    gh.factory<_i928.AcknowledgeAlertUseCase>(
      () => _i928.AcknowledgeAlertUseCase(gh<_i692.AlertRepository>()),
    );
    gh.factory<_i241.GetAlertHistoryUseCase>(
      () => _i241.GetAlertHistoryUseCase(gh<_i692.AlertRepository>()),
    );
    gh.factory<_i267.ResolveAlertUseCase>(
      () => _i267.ResolveAlertUseCase(gh<_i692.AlertRepository>()),
    );
    gh.factory<_i379.StablecoinBloc>(
      () => _i379.StablecoinBloc(gh<_i711.GetStablecoinChartDataUseCase>()),
    );
    gh.lazySingleton<_i654.ContactRepository>(
      () => _i95.ContactRepositoryImpl(
        remoteDataSource: gh<_i850.ContactRemoteDataSource>(),
      ),
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
    gh.factory<_i209.GetChartSummaryUseCase>(
      () => _i209.GetChartSummaryUseCase(gh<_i427.ChartSummaryRepository>()),
    );
    gh.factory<_i913.GetArticlesUseCase>(
      () => _i913.GetArticlesUseCase(gh<_i976.ArticlesRepository>()),
    );
    gh.factory<_i320.AnchorWiseBloc>(
      () => _i320.AnchorWiseBloc(
        gh<_i1011.SendChatMessageUseCase>(),
        gh<_i625.CreateNewConversationUseCase>(),
        gh<_i1011.GetConversationsUseCase>(),
        gh<_i539.GetConversationByIdUseCase>(),
        gh<_i258.DeleteConversationUseCase>(),
        gh<_i920.SendFeedbackUseCase>(),
      ),
    );
    gh.factory<_i259.AuthenticationBloc>(
      () => _i259.AuthenticationBloc(
        gh<_i289.LoginUseCase>(),
        gh<_i339.RegisterUseCase>(),
        gh<_i460.AuthenticationService>(),
      ),
    );
    gh.factory<_i364.ContactSupportUseCase>(
      () => _i364.ContactSupportUseCase(gh<_i654.ContactRepository>()),
    );
    gh.factory<_i580.PasswordResetBloc>(
      () => _i580.PasswordResetBloc(
        gh<_i512.ForgotPasswordUseCase>(),
        gh<_i33.VerifyOtpUseCase>(),
        gh<_i461.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i9.AlertsBloc>(
      () => _i9.AlertsBloc(
        gh<_i241.GetAlertHistoryUseCase>(),
        gh<_i928.AcknowledgeAlertUseCase>(),
        gh<_i267.ResolveAlertUseCase>(),
        gh<_i692.AlertRepository>(),
      ),
    );
    gh.factory<_i100.ArticlesBloc>(
      () => _i100.ArticlesBloc(gh<_i913.GetArticlesUseCase>()),
    );
    gh.factory<_i981.ChartSummaryBloc>(
      () => _i981.ChartSummaryBloc(gh<_i209.GetChartSummaryUseCase>()),
    );
    gh.factory<_i945.ContactBloc>(
      () => _i945.ContactBloc(gh<_i364.ContactSupportUseCase>()),
    );
    gh.factory<_i688.ContactSupportBloc>(
      () => _i688.ContactSupportBloc(gh<_i364.ContactSupportUseCase>()),
    );
    return this;
  }
}
