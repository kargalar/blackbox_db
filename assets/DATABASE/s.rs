// Enum Tabloları
Table content_type_enum {
  id integer [pk]
  name varchar
}

Table showcase_type_enum {
  id integer [pk]
  name varchar
}

Table content_status_enum {
  id integer [pk]
  name varchar
}

// Kullanıcı ve Sosyal Özellikler
Table user {
  id integer [pk]
  username varchar [unique]
  email varchar [unique]
  password_hash varchar
  picture_path varchar
  bio text
  personality_analyze text
  created_at timestamp
  last_login timestamp
}

Table user_follow {
  follower_id integer [ref: > user.id]
  following_id integer [ref: > user.id]
  created_at timestamp
  indexes {
    (follower_id, following_id) [pk]
  }
}

// Ana İçerik Tabloları
Table content {
  id integer [pk]
  title varchar
  cover_path varchar
  content_type_id integer [ref: > content_type_enum.id]
  release_date timestamp
  description text
  length integer
  consume_count integer
  favori_count integer
  list_count integer
  review_count integer
  average_rating decimal
  rating_distribution json
  content_status_id integer [ref: > content_status_enum.id]
  created_at timestamp
}

// Kategorilendirme Tabloları
Table theme {
  id integer [pk]
  name varchar
}

Table language {
  id integer [pk]
  name varchar
}

Table country {
  id integer [pk]
  name varchar
}

Table content_theme {
  content_id integer [ref: > content.id]
  theme_id integer [ref: > theme.id]
  indexes {
    (content_id, theme_id) [pk]
  }
}

Table content_language {
  content_id integer [ref: > content.id]
  language_id integer [ref: > language.id]
  indexes {
    (content_id, language_id) [pk]
  }
}

Table content_country {
  content_id integer [ref: > content.id]
  country_id integer [ref: > country.id]
  indexes {
    (content_id, country_id) [pk]
  }
}

// Var olan tablolar güncellendi
Table user_content_interaction {
  user_id integer [ref: > user.id]
  content_id integer [ref: > content.id]
  consumed_at timestamp
  rating decimal
  is_favorite boolean [default: false]
  is_consume_later boolean [default: false]
  created_at timestamp
  updated_at timestamp
  indexes {
    (user_id, content_id) [pk]
  }
}

// Review Sistemi
Table review {
  id integer [pk]
  user_id integer [ref: > user.id]
  content_id integer [ref: > content.id]
  text text
  rating decimal
  like_count integer [default: 0]
  comment_count integer [default: 0]
  created_at timestamp
  updated_at timestamp
}

Table review_like {
  user_id integer [ref: > user.id]
  review_id integer [ref: > review.id]
  created_at timestamp
  indexes {
    (user_id, review_id) [pk]
  }
}

Table review_comment {
  id integer [pk]
  review_id integer [ref: > review.id]
  user_id integer [ref: > user.id]
  text text
  created_at timestamp
}

// Liste Sistemi
Table user_list {
  id integer [pk]
  user_id integer [ref: > user.id]
  title varchar
  description text
  is_public boolean [default: true]
  created_at timestamp
  updated_at timestamp
}

Table list_content {
  list_id integer [ref: > user_list.id]
  content_id integer [ref: > content.id]
  added_at timestamp
  indexes {
    (list_id, content_id) [pk]
  }
}

// Vitrin Sistemi
Table showcase_content {
  id integer [pk]
  content_id integer [ref: > content.id]
  content_type_id integer [ref: > content_type_enum.id]
  showcase_type_id integer [ref: > showcase_type_enum.id]
  order_index integer
  start_date timestamp
  end_date timestamp
}

// Diğer İlişki Tabloları (önceden var olanlar)
Table creator {
  id integer [pk]
  name varchar
  profile_path varchar
}

Table content_creator {
  content_id integer [ref: > content.id]
  creator_id integer [ref: > creator.id]
  role_type varchar
  indexes {
    (content_id, creator_id) [pk]
  }
}

Table genre {
  id integer [pk]
  name varchar
}

Table content_genre {
  content_id integer [ref: > content.id]
  genre_id integer [ref: > genre.id]
  indexes {
    (content_id, genre_id) [pk]
  }
}

Table platform {
  id integer [pk]
  name varchar
  logo_path varchar
}

Table content_platform {
  content_id integer [ref: > content.id]
  platform_id integer [ref: > platform.id]
  indexes {
    (content_id, platform_id) [pk]
  }
}

Table cast {
  id integer [pk]
  name varchar
  profile_path varchar
}

Table content_cast {
  content_id integer [ref: > content.id]
  cast_id integer [ref: > cast.id]
  character_name varchar
  indexes {
    (content_id, cast_id) [pk]
  }
}