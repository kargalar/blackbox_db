import 'package:blackbox_db/2_General/Widget/profile_picture.dart';
import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/8_Model/review_model.dart';
import 'package:blackbox_db/8_Model/review_reply_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReviewDetailDialog extends StatefulWidget {
  const ReviewDetailDialog({
    super.key,
    required this.reviewModel,
  });

  final ReviewModel reviewModel;

  @override
  State<ReviewDetailDialog> createState() => _ReviewDetailDialogState();
}

class _ReviewDetailDialogState extends State<ReviewDetailDialog> {
  List<ReviewReplyModel> replies = [];
  bool isLoading = true;
  bool isAddingReply = false;
  final TextEditingController _replyController = TextEditingController();
  int? replyingToId; // For nested replies
  String? replyingToUsername; // To show "@username"

  @override
  void initState() {
    super.initState();
    loadReplies();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> loadReplies() async {
    try {
      final fetchedReplies = await MigrationService().getReviewReplies(
        reviewId: widget.reviewModel.id,
      );
      setState(() {
        replies = fetchedReplies;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading replies: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addReply() async {
    if (_replyController.text.trim().isEmpty) return;

    setState(() {
      isAddingReply = true;
    });

    try {
      final currentUser = await MigrationService().getCurrentUserProfile();
      if (currentUser != null) {
        final newReply = await MigrationService().addReviewReply(
          reviewId: widget.reviewModel.id,
          userId: currentUser.id,
          text: _replyController.text.trim(),
          parentReplyId: replyingToId,
        );

        if (newReply != null) {
          _replyController.clear();
          setState(() {
            replyingToId = null;
            replyingToUsername = null;
          });

          // Reload replies to get updated structure
          await loadReplies();

          // Update the original review's comment count
          widget.reviewModel.commentCount++;
        }
      }
    } catch (e) {
      debugPrint('Error adding reply: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yorum eklenirken hata oluştu')),
      );
    } finally {
      setState(() {
        isAddingReply = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.panelBackground,
      child: Container(
        width: 0.6.sw,
        height: 0.8.sh,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Yorum Detayı',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Divider(),

            // Original review
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.main.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProfilePicture.review(
                        imageUrl: widget.reviewModel.picturePath,
                        userId: widget.reviewModel.userId,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.reviewModel.userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 5),
                              if (widget.reviewModel.isFavorite)
                                Icon(
                                  Icons.favorite,
                                  color: AppColors.red,
                                  size: 15,
                                ),
                              if (widget.reviewModel.rating != null)
                                RatingBarIndicator(
                                  rating: widget.reviewModel.rating!,
                                  itemSize: 17,
                                  itemCount: 5,
                                  unratedColor: AppColors.transparent,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: AppColors.main,
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            DateFormat('dd MMMM yyyy').format(widget.reviewModel.createdAt),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.reviewModel.text,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        widget.reviewModel.isLikedByCurrentUser ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: widget.reviewModel.isLikedByCurrentUser ? AppColors.main : Colors.grey,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${widget.reviewModel.likeCount} beğeni',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.comment,
                        color: Colors.grey,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${widget.reviewModel.commentCount} yorum',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Reply input
            if (replyingToUsername != null)
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.main.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      '@$replyingToUsername kullanıcısına yanıt veriyorsunuz',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.main,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          replyingToId = null;
                          replyingToUsername = null;
                        });
                      },
                      child: Text('İptal'),
                    ),
                  ],
                ),
              ),

            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: replyingToUsername != null ? '@$replyingToUsername için yanıt yazın...' : 'Yorumunuzu yazın...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isAddingReply ? null : addReply,
                    child: isAddingReply
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Gönder'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Replies list
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : replies.isEmpty
                      ? Center(
                          child: Text(
                            'Henüz yorum yok',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: replies.length,
                          itemBuilder: (context, index) {
                            return ReviewReplyItem(
                              reply: replies[index],
                              onReply: (replyId, username) {
                                setState(() {
                                  replyingToId = replyId;
                                  replyingToUsername = username;
                                });
                              },
                              level: 0,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewReplyItem extends StatelessWidget {
  const ReviewReplyItem({
    super.key,
    required this.reply,
    required this.onReply,
    required this.level,
  });

  final ReviewReplyModel reply;
  final Function(int replyId, String username) onReply;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: level * 20.0, // Indent for nested replies
        bottom: 10,
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: level > 0 ? Colors.grey.withOpacity(0.05) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfilePicture.review(
                imageUrl: reply.userPicturePath,
                userId: reply.userId,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          reply.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (reply.parentUserName != null) ...[
                          SizedBox(width: 5),
                          Text(
                            '@${reply.parentUserName}',
                            style: TextStyle(
                              color: AppColors.main,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        Spacer(),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(reply.createdAt),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      reply.text,
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 5),
                    if (level < 2) // Limit nesting to 2 levels
                      TextButton(
                        onPressed: () => onReply(reply.id, reply.userName),
                        child: Text(
                          'Yanıtla',
                          style: TextStyle(
                            color: AppColors.main,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // Nested replies
          if (reply.replies.isNotEmpty) ...[
            SizedBox(height: 10),
            ...reply.replies.map((nestedReply) => ReviewReplyItem(
                  reply: nestedReply,
                  onReply: onReply,
                  level: level + 1,
                )),
          ],
        ],
      ),
    );
  }
}
