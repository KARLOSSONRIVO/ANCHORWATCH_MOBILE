import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/contact/contact.dart';
import '../themes/app_theme.dart';
import '../widgets/loading_widget.dart';
import '../widgets/custom_snackbar.dart';

/// Contact screen with BLoC architecture
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactBloc()..add(const ContactLoadRequested()),
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
          icon: Icon(Icons.arrow_back, color: AppTheme.getTextPrimaryColor(context)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state.status == ContactStatus.submitted) {
            // Clear the text field when form is successfully submitted
            _questionController.clear();
            
            // Show success message
            SnackBarHelper.showSuccess(
              context,
              'Your question has been submitted successfully!',
              duration: const Duration(seconds: 3),
            );
          } else if (state.status == ContactStatus.failure) {
            // Show error message
            SnackBarHelper.showError(
              context,
              state.errorMessage,
              duration: const Duration(seconds: 3),
            );
          } else if (state.status == ContactStatus.navigatingToFaq) {
            // Navigate to FAQ and replace current screen in stack
            Navigator.of(context).pushReplacementNamed('/faq');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
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
                
                // Description
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
                
                // How can we help section
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
                
                // Question input field
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
                
                // Send button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isFormValid && state.status != ContactStatus.submitting
                        ? () {
                            context.read<ContactBloc>().add(const ContactFormSubmitted());
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
                
                // Go to FAQs link
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Trigger FAQ navigation through BLoC
                      context.read<ContactBloc>().add(const ContactNavigateToFaq());
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