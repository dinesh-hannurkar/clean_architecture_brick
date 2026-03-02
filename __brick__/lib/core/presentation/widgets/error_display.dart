import 'package:flutter/material.dart';
import 'package:{{project_name}}/core/domain/failures/failure.dart';
import 'package:{{project_name}}/core/presentation/theme/app_colors.dart';
import 'package:{{project_name}}/core/presentation/theme/app_spacing.dart';

/// A widget that displays error messages in a user-friendly way.
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    required this.failure, super.key,
    this.onRetry,
    this.showIcon = true,
  });

  final Failure failure;
  final VoidCallback? onRetry;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getBorderColor(), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(), color: _getIconColor(), size: 32),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            _getTitle(),
            style: TextStyle(
              color: _getTextColor(),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            failure.message,
            style: TextStyle(
              color: _getTextColor().withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getTitle() {
    if (failure is TimeoutFailure) {
      return 'Connection Timeout';
    } else if (failure is NetworkFailure) {
      return 'Network Error';
    } else if (failure is ServerFailure) {
      return 'Server Error';
    } else if (failure is AuthenticationFailure) {
      return 'Authentication Failed';
    } else if (failure is ValidationFailure) {
      return 'Validation Error';
    }
    return 'Error';
  }

  IconData _getIcon() {
    if (failure is TimeoutFailure) {
      return Icons.access_time_filled;
    } else if (failure is NetworkFailure) {
      return Icons.wifi_off_rounded;
    } else if (failure is ServerFailure) {
      return Icons.dns_outlined;
    } else if (failure is AuthenticationFailure) {
      return Icons.lock_outline;
    } else if (failure is ValidationFailure) {
      return Icons.error_outline;
    }
    return Icons.error_outline;
  }

  Color _getBackgroundColor() {
    if (failure is TimeoutFailure) {
      return Colors.orange.withValues(alpha: 0.05);
    } else if (failure is NetworkFailure) {
      return Colors.blue.withValues(alpha: 0.05);
    } else if (failure is ServerFailure) {
      return Colors.red.withValues(alpha: 0.05);
    } else if (failure is AuthenticationFailure) {
      return Colors.purple.withValues(alpha: 0.05);
    }
    return Colors.grey.withValues(alpha: 0.05);
  }

  Color _getBorderColor() {
    if (failure is TimeoutFailure) {
      return Colors.orange.withValues(alpha: 0.2);
    } else if (failure is NetworkFailure) {
      return Colors.blue.withValues(alpha: 0.2);
    } else if (failure is ServerFailure) {
      return Colors.red.withValues(alpha: 0.2);
    } else if (failure is AuthenticationFailure) {
      return Colors.purple.withValues(alpha: 0.2);
    }
    return Colors.grey.withValues(alpha: 0.2);
  }

  Color _getIconBackgroundColor() {
    if (failure is TimeoutFailure) {
      return Colors.orange.withValues(alpha: 0.1);
    } else if (failure is NetworkFailure) {
      return Colors.blue.withValues(alpha: 0.1);
    } else if (failure is ServerFailure) {
      return Colors.red.withValues(alpha: 0.1);
    } else if (failure is AuthenticationFailure) {
      return Colors.purple.withValues(alpha: 0.1);
    }
    return Colors.grey.withValues(alpha: 0.1);
  }

  Color _getIconColor() {
    if (failure is TimeoutFailure) {
      return Colors.orange.shade700;
    } else if (failure is NetworkFailure) {
      return Colors.blue.shade700;
    } else if (failure is ServerFailure) {
      return Colors.red.shade700;
    } else if (failure is AuthenticationFailure) {
      return Colors.purple.shade700;
    }
    return Colors.grey.shade700;
  }

  Color _getTextColor() {
    if (failure is TimeoutFailure) {
      return Colors.orange.shade900;
    } else if (failure is NetworkFailure) {
      return Colors.blue.shade900;
    } else if (failure is ServerFailure) {
      return Colors.red.shade900;
    } else if (failure is AuthenticationFailure) {
      return Colors.purple.shade900;
    }
    return Colors.grey.shade900;
  }

  Color _getButtonColor() {
    if (failure is TimeoutFailure) {
      return Colors.orange.shade600;
    } else if (failure is NetworkFailure) {
      return Colors.blue.shade600;
    } else if (failure is ServerFailure) {
      return Colors.red.shade600;
    } else if (failure is AuthenticationFailure) {
      return AppColors.primary;
    }
    return AppColors.primary;
  }
}

/// A widget that displays a centered error message with optional retry.
class CenteredErrorDisplay extends StatelessWidget {
  const CenteredErrorDisplay({required this.failure, super.key, this.onRetry});

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ErrorDisplay(failure: failure, onRetry: onRetry),
      ),
    );
  }
}
