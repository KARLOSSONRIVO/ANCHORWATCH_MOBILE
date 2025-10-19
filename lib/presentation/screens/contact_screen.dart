import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/contact/contact.dart';
import '../themes/app_theme.dart';
import '../widgets/loading_widget.dart';
import '../widgets/custom_snackbar.dart';
import '../../injection_container.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return getIt<ContactBloc>()..add(const ContactLoadRequested());
      },
      child: const _ContactView(),
    );
  }
}

class _ContactView extends StatefulWidget {
  const _ContactView();

  @override
  State<_ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<_ContactView> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppTheme.getBackgroundColor(context),
        foregroundColor: AppTheme.getTextPrimaryColor(context),
        title: const Text(
          'Contact Support',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.getTextPrimaryColor(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<ContactBloc, ContactState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) {
          if (state.status == ContactStatus.submitted) {
            _questionController.clear();
            SnackBarHelper.showSuccess(
              context,
              'Your question has been submitted successfully!',
            );
            context.read<ContactBloc>().add(const ContactStatusReset());
          } else if (state.status == ContactStatus.failure) {
            SnackBarHelper.showError(context, state.errorMessage);
            context.read<ContactBloc>().add(const ContactStatusReset());
          } else if (state.status == ContactStatus.navigatingToFaq) {
            Navigator.of(context).pushNamed('/faq').then((_) {
              if (context.mounted) {
                context.read<ContactBloc>().add(const ContactStatusReset());
              }
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Questions, Answered.',
                  style: TextStyle(
                    color: AppTheme.getTextPrimaryColor(context),
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Strategy. Strengthened.',
                  style: TextStyle(
                    color: AppTheme.getTextPrimaryColor(context),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Our Help Desk is here to provide clear guidance and practical solutions to dedicated support to empower your financial decisions. Whether you\'re exploring strategic market moves, need help with your account, or want better insights into advanced trading strategies, we\'re here to help, making your AnchorWatch experience intuitive, secure, and precision trading.',
                  style: TextStyle(
                    color: AppTheme.getTextSecondaryColor(context),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'How can we help?',
                  style: TextStyle(
                    color: AppTheme.getTextPrimaryColor(context),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.getCardBackgroundColor(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.getBorderColor(context),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _questionController,
                      onChanged: (value) {
                        context.read<ContactBloc>().add(
                          ContactQuestionChanged(question: value),
                        );
                      },
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(
                        color: AppTheme.getTextPrimaryColor(context),
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your question here...',
                        hintStyle: TextStyle(
                          color: AppTheme.getTextSecondaryColor(context),
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        state.isFormValid &&
                            state.status != ContactStatus.submitting
                        ? () {
                            context.read<ContactBloc>().add(
                              const ContactFormSubmitted(),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.isFormValid
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF424242),
                      foregroundColor: state.isFormValid
                          ? Colors.white
                          : const Color(0xFFBBBBBB),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: state.isFormValid
                            ? BorderSide.none
                            : const BorderSide(
                                color: Color(0xFF666666),
                                width: 1,
                              ),
                      ),
                      elevation: 0,
                    ),
                    child: state.status == ContactStatus.submitting
                        ? const SimpleLoadingWidget(
                            size: 20,
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            'Send',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: state.isFormValid
                                  ? AppTheme.getTextPrimaryColor(context)
                                  : AppTheme.getTextSecondaryColor(context),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.read<ContactBloc>().add(
                        const ContactNavigateToFaq(),
                      );
                    },
                    child: const Text(
                      'Go to FAQs',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
