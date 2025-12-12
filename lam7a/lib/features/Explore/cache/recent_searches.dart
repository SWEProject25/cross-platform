import 'package:hive/hive.dart';
import 'package:lam7a/core/models/user_model.dart';

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 3;

  @override
  UserModel read(BinaryReader reader) {
    // id (int?)
    final isIdNull = reader.readBool();
    final int? id = isIdNull ? null : reader.readInt();

    // name (String?)
    final isNameNull = reader.readBool();
    final String? name = isNameNull ? null : reader.readString();

    // username (String?)
    final isUsernameNull = reader.readBool();
    final String? username = isUsernameNull ? null : reader.readString();

    // profileImageUrl (String?)
    final isProfileUrlNull = reader.readBool();
    final String? profileImageUrl = isProfileUrlNull
        ? null
        : reader.readString();

    return UserModel(
      id: id,
      name: name,
      username: username,
      profileImageUrl: profileImageUrl,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    // id
    if (obj.id == null) {
      writer.writeBool(true);
    } else {
      writer.writeBool(false);
      writer.writeInt(obj.id!);
    }

    // name
    if (obj.name == null) {
      writer.writeBool(true);
    } else {
      writer.writeBool(false);
      writer.writeString(obj.name!);
    }

    // username
    if (obj.username == null) {
      writer.writeBool(true);
    } else {
      writer.writeBool(false);
      writer.writeString(obj.username!);
    }

    // profileImageUrl
    if (obj.profileImageUrl == null) {
      writer.writeBool(true);
    } else {
      writer.writeBool(false);
      writer.writeString(obj.profileImageUrl!);
    }
  }
}
