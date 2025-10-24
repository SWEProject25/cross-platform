//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/api_response_dto.dart';
import 'package:openapi/src/model/check_email_dto.dart';
import 'package:openapi/src/model/create_post_dto.dart';
import 'package:openapi/src/model/create_post_response_dto.dart';
import 'package:openapi/src/model/create_user_dto.dart';
import 'package:openapi/src/model/delete_post_response_dto.dart';
import 'package:openapi/src/model/error_response_dto.dart';
import 'package:openapi/src/model/follow_response_dto.dart';
import 'package:openapi/src/model/follower_dto.dart';
import 'package:openapi/src/model/get_liked_posts_response_dto.dart';
import 'package:openapi/src/model/get_liked_posts_response_dto_data_inner.dart';
import 'package:openapi/src/model/get_likers_response_dto.dart';
import 'package:openapi/src/model/get_posts_response_dto.dart';
import 'package:openapi/src/model/get_profile_response_dto.dart';
import 'package:openapi/src/model/get_reposters_response_dto.dart';
import 'package:openapi/src/model/login_dto.dart';
import 'package:openapi/src/model/login_response_dto.dart';
import 'package:openapi/src/model/pagination_metadata.dart';
import 'package:openapi/src/model/post_response_dto.dart';
import 'package:openapi/src/model/profile_response_dto.dart';
import 'package:openapi/src/model/recaptcha_dto.dart';
import 'package:openapi/src/model/register_data_response_dto.dart';
import 'package:openapi/src/model/register_response_dto.dart';
import 'package:openapi/src/model/repost_user_dto.dart';
import 'package:openapi/src/model/search_profile_response_dto.dart';
import 'package:openapi/src/model/toggle_like_response_dto.dart';
import 'package:openapi/src/model/toggle_repost_response_dto.dart';
import 'package:openapi/src/model/update_email_dto.dart';
import 'package:openapi/src/model/update_profile_dto.dart';
import 'package:openapi/src/model/update_profile_response_dto.dart';
import 'package:openapi/src/model/update_username_dto.dart';
import 'package:openapi/src/model/user_dto.dart';
import 'package:openapi/src/model/user_info_dto.dart';
import 'package:openapi/src/model/user_response.dart';

part 'serializers.g.dart';

@SerializersFor([
  ApiResponseDto,
  CheckEmailDto,
  CreatePostDto,
  CreatePostResponseDto,
  CreateUserDto,
  DeletePostResponseDto,
  ErrorResponseDto,
  FollowResponseDto,
  FollowerDto,
  GetLikedPostsResponseDto,
  GetLikedPostsResponseDtoDataInner,
  GetLikersResponseDto,
  GetPostsResponseDto,
  GetProfileResponseDto,
  GetRepostersResponseDto,
  LoginDto,
  LoginResponseDto,
  PaginationMetadata,
  PostResponseDto,
  ProfileResponseDto,
  RecaptchaDto,
  RegisterDataResponseDto,
  RegisterResponseDto,
  RepostUserDto,
  SearchProfileResponseDto,
  ToggleLikeResponseDto,
  ToggleRepostResponseDto,
  UpdateEmailDto,
  UpdateProfileDto,
  UpdateProfileResponseDto,
  UpdateUsernameDto,
  UserDto,
  UserInfoDto,
  UserResponse,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(FollowerDto)]),
        () => ListBuilder<FollowerDto>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
