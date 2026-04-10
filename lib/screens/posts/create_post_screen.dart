import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../graphql/mutations/post_mutations.dart';
import '../../widgets/common/kamili_button.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  final Set<String> _selectedPlatforms = {};
  bool _schedulePost = false;
  DateTime _scheduledDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _scheduledTime = TimeOfDay.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Content field
                _buildContentField(),
                const SizedBox(height: 20),

                // Media section
                _buildMediaSection(),
                const SizedBox(height: 20),

                // Platform selector
                _buildPlatformSelector(),
                const SizedBox(height: 20),

                // Schedule section
                _buildScheduleSection(),
              ],
            ),
          ),

          // Bottom action bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildContentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Content',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: KamiliColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _contentController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'What would you like to share?',
            hintStyle: const TextStyle(color: KamiliColors.textSecondary),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KamiliColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KamiliColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: KamiliColors.primary, width: 2),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_contentController.text.length} characters',
            style: const TextStyle(
              fontSize: 12,
              color: KamiliColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Media',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: KamiliColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: integrate image_picker
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Media picker coming soon')),
            );
          },
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: const Text('Add Media'),
          style: OutlinedButton.styleFrom(
            foregroundColor: KamiliColors.primary,
            side: const BorderSide(color: KamiliColors.primary),
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platforms',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: KamiliColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.socialPlatforms.map((platform) {
            final isSelected = _selectedPlatforms.contains(platform);
            final displayName =
                AppConstants.platformDisplayNames[platform] ?? platform;
            return FilterChip(
              label: Text(displayName),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedPlatforms.add(platform);
                  } else {
                    _selectedPlatforms.remove(platform);
                  }
                });
              },
              selectedColor: KamiliColors.primary.withValues(alpha: 0.15),
              checkmarkColor: KamiliColors.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? KamiliColors.primary
                    : KamiliColors.textPrimary,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? KamiliColors.primary
                      : KamiliColors.border,
                ),
              ),
              backgroundColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KamiliColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'When to post',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: KamiliColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ScheduleOption(
                  label: 'Post Now',
                  isSelected: !_schedulePost,
                  onTap: () => setState(() => _schedulePost = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ScheduleOption(
                  label: 'Schedule',
                  isSelected: _schedulePost,
                  onTap: () => setState(() => _schedulePost = true),
                ),
              ),
            ],
          ),
          if (_schedulePost) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: KamiliColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18,
                              color: KamiliColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(
                            '${_scheduledDate.month}/${_scheduledDate.day}/${_scheduledDate.year}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: KamiliColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickTime(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: KamiliColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 18,
                              color: KamiliColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(
                            _scheduledTime.format(context),
                            style: const TextStyle(
                              fontSize: 14,
                              color: KamiliColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: KamiliColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _scheduledDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _scheduledTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: KamiliColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => _scheduledTime = time);
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: KamiliColors.borderLight),
        ),
      ),
      child: SafeArea(
        child: Mutation(
          options: MutationOptions(
            document: gql(createPostMutation),
            onCompleted: (data) {
              if (data == null) return;
              final result = data['createPost'];
              if (result?['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_schedulePost
                        ? 'Post scheduled successfully'
                        : 'Post created successfully'),
                    backgroundColor: KamiliColors.success,
                  ),
                );
                context.pop();
              } else {
                final errorMsg =
                    result?['error']?['message'] as String? ??
                        result?['message'] as String? ??
                        'Failed to create post';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMsg),
                    backgroundColor: KamiliColors.error,
                  ),
                );
                setState(() => _isSubmitting = false);
              }
            },
            onError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      error?.toString() ?? 'Failed to create post'),
                  backgroundColor: KamiliColors.error,
                ),
              );
              setState(() => _isSubmitting = false);
            },
          ),
          builder: (runMutation, result) {
            return Row(
              children: [
                Expanded(
                  child: KamiliButton(
                    label: 'Save Draft',
                    variant: KamiliButtonVariant.text,
                    isLoading: _isSubmitting,
                    onPressed: _contentController.text.trim().isEmpty
                        ? null
                        : () => _submit(runMutation, isDraft: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KamiliButton(
                    label: _schedulePost ? 'Schedule' : 'Publish',
                    isLoading: _isSubmitting,
                    onPressed: _contentController.text.trim().isEmpty
                        ? null
                        : () => _submit(runMutation, isDraft: false),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _submit(RunMutation runMutation, {required bool isDraft}) {
    setState(() => _isSubmitting = true);

    DateTime? scheduledAt;
    if (_schedulePost && !isDraft) {
      scheduledAt = DateTime(
        _scheduledDate.year,
        _scheduledDate.month,
        _scheduledDate.day,
        _scheduledTime.hour,
        _scheduledTime.minute,
      );
    }

    final data = <String, dynamic>{
      'content': {
        'default': {
          'text': _contentController.text.trim(),
        },
      },
      'status': isDraft
          ? 'DRAFT'
          : (_schedulePost ? 'SCHEDULED' : 'PUBLISHING'),
      if (_selectedPlatforms.isNotEmpty)
        'targetConnectionIds': _selectedPlatforms.toList(),
      if (scheduledAt != null)
        'scheduledAt': scheduledAt.toUtc().toIso8601String(),
    };

    runMutation({'data': data});
  }
}

class _ScheduleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScheduleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? KamiliColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? KamiliColors.primary
                : KamiliColors.border,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? KamiliColors.primary
                : KamiliColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
