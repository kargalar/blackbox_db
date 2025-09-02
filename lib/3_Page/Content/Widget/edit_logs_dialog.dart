import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/6_Provider/content_page_provider.dart';
import 'package:blackbox_db/7_Enum/content_status_enum.dart';
import 'package:blackbox_db/8_Model/content_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditLogsDialog extends StatefulWidget {
  final int contentId;
  const EditLogsDialog({super.key, required this.contentId});

  @override
  State<EditLogsDialog> createState() => _EditLogsDialogState();
}

class _EditLogsDialogState extends State<EditLogsDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContentPageProvider>().fetchUserLogsForContent(widget.contentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContentPageProvider>();
    final logs = provider.userLogs;
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Your Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) {
                          ContentStatusEnum? status;
                          double rating = 0;
                          bool fav = false;
                          bool later = false;
                          final reviewCtrl = TextEditingController();
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Add Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 12),
                                      Row(children: [
                                        const Text('Status: '),
                                        const SizedBox(width: 8),
                                        DropdownButton<ContentStatusEnum?>(
                                          value: status,
                                          items: const [
                                            DropdownMenuItem(value: null, child: Text('No status')),
                                            DropdownMenuItem(value: ContentStatusEnum.CONSUMED, child: Text('Consumed')),
                                            DropdownMenuItem(value: ContentStatusEnum.CONSUMING, child: Text('Consuming')),
                                            DropdownMenuItem(value: ContentStatusEnum.UNFINISHED, child: Text('Unfinished')),
                                            DropdownMenuItem(value: ContentStatusEnum.ABONDONED, child: Text('Abondoned')),
                                          ],
                                          onChanged: (v) => setState(() => status = v),
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(children: [
                                        const Text('Rating: '),
                                        const SizedBox(width: 8),
                                        RatingBar.builder(
                                          initialRating: rating,
                                          minRating: 0,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 22,
                                          glow: false,
                                          itemBuilder: (_, __) => Icon(Icons.star, color: AppColors.main),
                                          onRatingUpdate: (v) => setState(() => rating = v),
                                        ),
                                      ]),
                                      const SizedBox(height: 8),
                                      Row(children: [
                                        const Text('Favorite'),
                                        const SizedBox(width: 8),
                                        Switch(value: fav, onChanged: (v) => setState(() => fav = v)),
                                        const SizedBox(width: 16),
                                        const Text('Watch later'),
                                        const SizedBox(width: 8),
                                        Switch(value: later, onChanged: (v) => setState(() => later = v)),
                                      ]),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: reviewCtrl,
                                        minLines: 2,
                                        maxLines: 4,
                                        decoration: const InputDecoration(
                                          hintText: 'Review (optional)',
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await provider.contentUserAction(
                                                contentType: provider.contentModel!.contentType,
                                                contentStatus: status,
                                                rating: rating > 0 ? rating : null,
                                                isFavorite: fav,
                                                isConsumeLater: later,
                                                review: reviewCtrl.text.trim().isEmpty ? null : reviewCtrl.text.trim(),
                                              );
                                              if (context.mounted) Navigator.of(context).pop();
                                            },
                                            child: const Text('Add'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                      await provider.fetchUserLogsForContent(widget.contentId);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Log'),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: logs.isEmpty
                    ? const Center(child: Text('No logs yet.'))
                    : ListView.separated(
                        itemCount: logs.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          return _LogRow(
                            log: log,
                            onSave: (updated) async {
                              await provider.updateUserLogEntry(
                                logId: log.id!,
                                contentId: widget.contentId,
                                contentStatus: updated.contentStatus,
                                rating: updated.rating,
                                isFavorite: updated.isFavorite,
                                isConsumeLater: updated.isConsumeLater,
                                reviewText: updated.review,
                              );
                            },
                            onDelete: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Are you sure?'),
                                  content: const Text('This will delete the selected log.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                    ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await provider.deleteUserLogEntry(logId: log.id!, contentId: widget.contentId);
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogRow extends StatefulWidget {
  final ContentLogModel log;
  final ValueChanged<ContentLogModel> onSave;
  final VoidCallback onDelete;
  const _LogRow({required this.log, required this.onSave, required this.onDelete});

  @override
  State<_LogRow> createState() => _LogRowState();
}

class _LogRowState extends State<_LogRow> {
  late ContentStatusEnum? status = widget.log.contentStatus;
  late double rating = widget.log.rating ?? 0;
  late bool fav = widget.log.isFavorite ?? false;
  late bool later = widget.log.isConsumeLater ?? false;
  late final TextEditingController reviewCtrl = TextEditingController(text: widget.log.review ?? '');
  bool editing = false;

  @override
  void dispose() {
    reviewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = widget.log.date != null ? DateFormat('y-MM-dd HH:mm').format(widget.log.date!) : '-';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(label: Text(dateStr)),
                    DropdownButton<ContentStatusEnum?>(
                      value: status,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('No status')),
                        DropdownMenuItem(value: ContentStatusEnum.CONSUMED, child: Text('Consumed')),
                        DropdownMenuItem(value: ContentStatusEnum.CONSUMING, child: Text('Consuming')),
                        DropdownMenuItem(value: ContentStatusEnum.UNFINISHED, child: Text('Unfinished')),
                        DropdownMenuItem(value: ContentStatusEnum.ABONDONED, child: Text('Abondoned')),
                      ],
                      onChanged: (v) async {
                        setState(() => status = v);
                        final effectiveLater = v == ContentStatusEnum.CONSUMED ? false : later;
                        await context.read<ContentPageProvider>().updateUserLogEntry(
                              logId: widget.log.id!,
                              contentId: widget.log.contentID,
                              contentStatus: v,
                              rating: rating > 0 ? rating : null,
                              isFavorite: fav,
                              isConsumeLater: effectiveLater,
                              reviewText: reviewCtrl.text.trim().isEmpty ? null : reviewCtrl.text.trim(),
                            );
                      },
                    ),
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 0,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 18,
                      glow: false,
                      itemBuilder: (_, __) => Icon(Icons.star, color: AppColors.main),
                      onRatingUpdate: (v) async {
                        setState(() => rating = v);
                        final effectiveLater = status == ContentStatusEnum.CONSUMED ? false : later;
                        await context.read<ContentPageProvider>().updateUserLogEntry(
                              logId: widget.log.id!,
                              contentId: widget.log.contentID,
                              contentStatus: status,
                              rating: v > 0 ? v : null,
                              isFavorite: fav,
                              isConsumeLater: effectiveLater,
                              reviewText: reviewCtrl.text.trim().isEmpty ? null : reviewCtrl.text.trim(),
                            );
                      },
                    ),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      const Text('Fav'),
                      Switch(
                        value: fav,
                        onChanged: (v) async {
                          setState(() => fav = v);
                          final effectiveLater = status == ContentStatusEnum.CONSUMED ? false : later;
                          await context.read<ContentPageProvider>().updateUserLogEntry(
                                logId: widget.log.id!,
                                contentId: widget.log.contentID,
                                contentStatus: status,
                                rating: rating > 0 ? rating : null,
                                isFavorite: v,
                                isConsumeLater: effectiveLater,
                                reviewText: reviewCtrl.text.trim().isEmpty ? null : reviewCtrl.text.trim(),
                              );
                        },
                      ),
                    ]),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      const Text('Later'),
                      Switch(
                        value: later,
                        onChanged: (v) async {
                          // If status is CONSUMED, force later=false
                          final nextLater = status == ContentStatusEnum.CONSUMED ? false : v;
                          setState(() => later = nextLater);
                          await context.read<ContentPageProvider>().updateUserLogEntry(
                                logId: widget.log.id!,
                                contentId: widget.log.contentID,
                                contentStatus: status,
                                rating: rating > 0 ? rating : null,
                                isFavorite: fav,
                                isConsumeLater: nextLater,
                                reviewText: reviewCtrl.text.trim().isEmpty ? null : reviewCtrl.text.trim(),
                              );
                        },
                      ),
                    ]),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
              // Save button removed: changes are auto-persisted on change
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: reviewCtrl,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Review (optional)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (text) async {
              final effectiveLater = status == ContentStatusEnum.CONSUMED ? false : later;
              await context.read<ContentPageProvider>().updateUserLogEntry(
                    logId: widget.log.id!,
                    contentId: widget.log.contentID,
                    contentStatus: status,
                    rating: rating > 0 ? rating : null,
                    isFavorite: fav,
                    isConsumeLater: effectiveLater,
                    reviewText: text.trim().isEmpty ? null : text.trim(),
                  );
            },
          ),
        ],
      ),
    );
  }
}
