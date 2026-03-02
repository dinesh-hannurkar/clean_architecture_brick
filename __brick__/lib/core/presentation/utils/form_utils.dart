import 'package:flutter/material.dart';

class FormUtils {
  /// Validates the form and scrolls to the first invalid field if validation fails.
  /// Returns true if the form is valid, false otherwise.
  static bool validateAndScroll(GlobalKey<FormState> formKey) {
    if (formKey.currentState == null) return false;

    if (formKey.currentState!.validate()) {
      return true;
    }

    final context = formKey.currentContext;
    if (context != null) {
      scrollToFirstError(context);
    }
    return false;
  }

  /// Finds the first invalid FormField in the widget tree and scrolls to it.
  static void scrollToFirstError(BuildContext context) {
    final invalidWidget = _findFirstInvalidWidget(context);
    if (invalidWidget != null) {
      Scrollable.ensureVisible(
        invalidWidget,
        alignment:
            0.1, // Slightly offset from top for better visibility (labels, etc)
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  static BuildContext? _findFirstInvalidWidget(BuildContext context) {
    BuildContext? invalidContext;

    void visitor(Element element) {
      if (invalidContext != null) return;

      if (element.widget is FormField) {
        final state =
            (element as StatefulElement).state as FormFieldState<dynamic>?;
        if (state != null && state.hasError) {
          invalidContext = element;
          return;
        }
      }

      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);
    return invalidContext;
  }
}
