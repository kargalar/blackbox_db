import 'package:blackbox_db/2_General/Widget/profile_picture.dart';
import 'package:blackbox_db/2_General/app_colors.dart';
import 'package:blackbox_db/5_Service/migration_service.dart';
import 'package:blackbox_db/8_Model/review_model.dart';
import 'package:blackbox_db/8_Model/review_reply_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReviewItem extends StatefulWidget {
  const ReviewItem({
    super.key,
    required this.reviewModel,
  });

  final ReviewModel reviewModel;

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  List<ReviewReplyModel> replies = [];
  bool isLoadingReplies = false;
  bool showReplies = false;
  bool isAddingReply = false;
  final TextEditingController _replyController = TextEditingController();
  int? replyingToId; // For nested replies
  String? replyingToUsername; // To show "@username"

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> loadReplies() async {
    if (isLoadingReplies) return;

    setState(() {
      isLoadingReplies = true;
    });

    try {
      final fetchedReplies = await MigrationService().getReviewReplies(
        reviewId: widget.reviewModel.id,
      );
      setState(() {
        replies = fetchedReplies;
        showReplies = true;
        isLoadingReplies = false;
      });
    } catch (e) {
      debugPrint('Error loading replies: $e');
      setState(() {
        isLoadingReplies = false;
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
        final replyText = _replyController.text.trim();
        final parentId = replyingToId;

        // Clear input and state immediately for better UX
        _replyController.clear();
        setState(() {
          replyingToId = null;
          replyingToUsername = null;
        });

        // Create optimistic reply object
        final optimisticReply = ReviewReplyModel(
          id: -1, // Temporary ID
          reviewId: widget.reviewModel.id,
          userId: currentUser.id,
          userName: currentUser.username,
          userPicturePath: currentUser.picturePath,
          text: replyText,
          createdAt: DateTime.now(),
          parentReplyId: parentId,
          likeCount: 0,
          isLikedByCurrentUser: false,
        );

        // Add to UI immediately
        setState(() {
          if (parentId == null) {
            // Top-level reply
            replies.add(optimisticReply);
          } else {
            // Find parent and add as nested reply
            _addReplyToParent(replies, parentId, optimisticReply);
          }
          widget.reviewModel.commentCount++;
        });

        // Then add to database
        final newReply = await MigrationService().addReviewReply(
          reviewId: widget.reviewModel.id,
          userId: currentUser.id,
          text: replyText,
          parentReplyId: parentId,
        );

        if (newReply != null) {
          // Replace optimistic reply with real one
          setState(() {
            if (parentId == null) {
              final index = replies.indexWhere((r) => r.id == -1);
              if (index != -1) {
                replies[index] = newReply;
              }
            } else {
              _replaceOptimisticReply(replies, optimisticReply, newReply);
            }
          });
        } else {
          // Remove optimistic reply on failure
          setState(() {
            if (parentId == null) {
              replies.removeWhere((r) => r.id == -1);
            } else {
              _removeOptimisticReply(replies, optimisticReply);
            }
            widget.reviewModel.commentCount--;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Yorum eklenirken hata oluştu')),
          );
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

  void _addReplyToParent(List<ReviewReplyModel> replyList, int parentId, ReviewReplyModel newReply) {
    for (var reply in replyList) {
      if (reply.id == parentId) {
        reply.replies.add(newReply);
        return;
      }
      _addReplyToParent(reply.replies, parentId, newReply);
    }
  }

  void _replaceOptimisticReply(List<ReviewReplyModel> replyList, ReviewReplyModel optimistic, ReviewReplyModel real) {
    for (int i = 0; i < replyList.length; i++) {
      if (replyList[i].id == -1 && replyList[i].text == optimistic.text) {
        replyList[i] = real;
        return;
      }
      _replaceOptimisticReply(replyList[i].replies, optimistic, real);
    }
  }

  void _removeOptimisticReply(List<ReviewReplyModel> replyList, ReviewReplyModel optimistic) {
    replyList.removeWhere((r) => r.id == -1 && r.text == optimistic.text);
    for (var reply in replyList) {
      _removeOptimisticReply(reply.replies, optimistic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.4.sw,
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main review
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePicture.review(
                  imageUrl: widget.reviewModel.picturePath,
                  userId: widget.reviewModel.userId,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
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
                      SizedBox(height: 5),
                      Text(
                        widget.reviewModel.text,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          // Like button
                          InkWell(
                            onTap: () async {
                              try {
                                final currentUser = await MigrationService().getCurrentUserProfile();
                                if (currentUser != null) {
                                  // Optimistic update
                                  setState(() {
                                    widget.reviewModel.isLikedByCurrentUser = !widget.reviewModel.isLikedByCurrentUser;
                                    widget.reviewModel.likeCount += widget.reviewModel.isLikedByCurrentUser ? 1 : -1;
                                  });

                                  // Database update
                                  final isLiked = await MigrationService().toggleReviewLike(
                                    reviewId: widget.reviewModel.id,
                                    userId: currentUser.id,
                                  );

                                  final actualLikeCount = await MigrationService().getReviewLikeCount(widget.reviewModel.id);

                                  // Update with actual values
                                  setState(() {
                                    widget.reviewModel.isLikedByCurrentUser = isLiked;
                                    widget.reviewModel.likeCount = actualLikeCount;
                                  });
                                }
                              } catch (e) {
                                debugPrint('Error toggling like: $e');
                                // Revert optimistic update on error
                                setState(() {
                                  widget.reviewModel.isLikedByCurrentUser = !widget.reviewModel.isLikedByCurrentUser;
                                  widget.reviewModel.likeCount += widget.reviewModel.isLikedByCurrentUser ? 1 : -1;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Beğeni işlemi başarısız oldu')),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  widget.reviewModel.isLikedByCurrentUser ? Icons.thumb_up : Icons.thumb_up_outlined,
                                  color: widget.reviewModel.isLikedByCurrentUser ? AppColors.main : Colors.grey,
                                  size: 16,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  widget.reviewModel.likeCount.toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          // Comment toggle button
                          InkWell(
                            onTap: () {
                              if (showReplies) {
                                setState(() {
                                  showReplies = false;
                                });
                              } else {
                                loadReplies();
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  showReplies ? Icons.expand_less : Icons.expand_more,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '${widget.reviewModel.commentCount} yorum',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
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
                ),
              ],
            ),
          ),

          // Replies section
          if (showReplies) ...[
            SizedBox(height: 10),

            // Reply input area
            if (replyingToUsername != null)
              Container(
                margin: EdgeInsets.only(left: 40, bottom: 10),
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
                        fontSize: 12,
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
                      child: Text('İptal', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),

            Container(
              margin: EdgeInsets.only(left: 40),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
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
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      style: TextStyle(fontSize: 14),
                      maxLines: null,
                      minLines: 1,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isAddingReply ? null : addReply,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    ),
                    child: isAddingReply
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Gönder', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Replies list
            if (isLoadingReplies)
              Container(
                margin: EdgeInsets.only(left: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (replies.isNotEmpty)
              ...replies.map((reply) => _buildReplyItem(reply, 0)),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyItem(ReviewReplyModel reply, int level) {
    const double indentWidth = 40.0;
    final leftMargin = indentWidth + (level * 20.0);

    return Container(
      margin: EdgeInsets.only(left: leftMargin, bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: level % 2 == 0 ? Colors.grey.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfilePicture.review(
                imageUrl: reply.userPicturePath,
                userId: reply.userId,
              ),
              SizedBox(width: 8),
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
                          Icon(Icons.reply, size: 12, color: Colors.grey),
                          SizedBox(width: 3),
                          Text(
                            '@${reply.parentUserName}',
                            style: TextStyle(
                              color: AppColors.main,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        Spacer(),
                        Text(
                          DateFormat('dd MMM').format(reply.createdAt),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      reply.text,
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        // Like button for reply
                        InkWell(
                          onTap: () async {
                            try {
                              final currentUser = await MigrationService().getCurrentUserProfile();
                              if (currentUser != null) {
                                // Optimistically update UI first
                                setState(() {
                                  reply.isLikedByCurrentUser = !reply.isLikedByCurrentUser;
                                  reply.likeCount += reply.isLikedByCurrentUser ? 1 : -1;
                                });

                                // Then update database
                                final isLiked = await MigrationService().toggleReviewReplyLike(
                                  replyId: reply.id,
                                  userId: currentUser.id,
                                );

                                // Get actual like count to ensure consistency
                                final actualLikeCount = await MigrationService().getReviewReplyLikeCount(reply.id);

                                // Update with actual values
                                setState(() {
                                  reply.isLikedByCurrentUser = isLiked;
                                  reply.likeCount = actualLikeCount;
                                });
                              }
                            } catch (e) {
                              debugPrint('Error toggling reply like: $e');
                              // Revert optimistic update on error
                              setState(() {
                                reply.isLikedByCurrentUser = !reply.isLikedByCurrentUser;
                                reply.likeCount += reply.isLikedByCurrentUser ? 1 : -1;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Beğeni işlemi başarısız oldu')),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                reply.isLikedByCurrentUser ? Icons.thumb_up : Icons.thumb_up_outlined,
                                color: reply.isLikedByCurrentUser ? AppColors.main : Colors.grey,
                                size: 14,
                              ),
                              SizedBox(width: 3),
                              Text(
                                reply.likeCount.toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        // Reply button
                        InkWell(
                          onTap: () {
                            setState(() {
                              replyingToId = reply.id;
                              replyingToUsername = reply.userName;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.reply,
                                color: Colors.grey,
                                size: 14,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Yanıtla',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Child replies (recursive)
          if (reply.replies.isNotEmpty) ...[
            SizedBox(height: 10),
            ...reply.replies.map((childReply) => _buildReplyItem(childReply, level + 1)),
          ],
        ],
      ),
    );
  }
}
