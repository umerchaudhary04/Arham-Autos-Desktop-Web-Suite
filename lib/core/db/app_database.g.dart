// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _failedAttemptsMeta =
      const VerificationMeta('failedAttempts');
  @override
  late final GeneratedColumn<int> failedAttempts = GeneratedColumn<int>(
      'failed_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lockedUntilMeta =
      const VerificationMeta('lockedUntil');
  @override
  late final GeneratedColumn<DateTime> lockedUntil = GeneratedColumn<DateTime>(
      'locked_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastLoginAtMeta =
      const VerificationMeta('lastLoginAt');
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
      'last_login_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        displayName,
        role,
        pinHash,
        passwordHash,
        failedAttempts,
        lockedUntil,
        lastLoginAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    }
    if (data.containsKey('failed_attempts')) {
      context.handle(
          _failedAttemptsMeta,
          failedAttempts.isAcceptableOrUnknown(
              data['failed_attempts']!, _failedAttemptsMeta));
    }
    if (data.containsKey('locked_until')) {
      context.handle(
          _lockedUntilMeta,
          lockedUntil.isAcceptableOrUnknown(
              data['locked_until']!, _lockedUntilMeta));
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
          _lastLoginAtMeta,
          lastLoginAt.isAcceptableOrUnknown(
              data['last_login_at']!, _lastLoginAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash']),
      failedAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}failed_attempts'])!,
      lockedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}locked_until']),
      lastLoginAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_login_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String? displayName;
  final String role;
  final String pinHash;
  final String? passwordHash;
  final int failedAttempts;
  final DateTime? lockedUntil;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User(
      {required this.id,
      required this.username,
      this.displayName,
      required this.role,
      required this.pinHash,
      this.passwordHash,
      required this.failedAttempts,
      this.lockedUntil,
      this.lastLoginAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['role'] = Variable<String>(role);
    map['pin_hash'] = Variable<String>(pinHash);
    if (!nullToAbsent || passwordHash != null) {
      map['password_hash'] = Variable<String>(passwordHash);
    }
    map['failed_attempts'] = Variable<int>(failedAttempts);
    if (!nullToAbsent || lockedUntil != null) {
      map['locked_until'] = Variable<DateTime>(lockedUntil);
    }
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      role: Value(role),
      pinHash: Value(pinHash),
      passwordHash: passwordHash == null && nullToAbsent
          ? const Value.absent()
          : Value(passwordHash),
      failedAttempts: Value(failedAttempts),
      lockedUntil: lockedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedUntil),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      role: serializer.fromJson<String>(json['role']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      passwordHash: serializer.fromJson<String?>(json['passwordHash']),
      failedAttempts: serializer.fromJson<int>(json['failedAttempts']),
      lockedUntil: serializer.fromJson<DateTime?>(json['lockedUntil']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'displayName': serializer.toJson<String?>(displayName),
      'role': serializer.toJson<String>(role),
      'pinHash': serializer.toJson<String>(pinHash),
      'passwordHash': serializer.toJson<String?>(passwordHash),
      'failedAttempts': serializer.toJson<int>(failedAttempts),
      'lockedUntil': serializer.toJson<DateTime?>(lockedUntil),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          Value<String?> displayName = const Value.absent(),
          String? role,
          String? pinHash,
          Value<String?> passwordHash = const Value.absent(),
          int? failedAttempts,
          Value<DateTime?> lockedUntil = const Value.absent(),
          Value<DateTime?> lastLoginAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        displayName: displayName.present ? displayName.value : this.displayName,
        role: role ?? this.role,
        pinHash: pinHash ?? this.pinHash,
        passwordHash:
            passwordHash.present ? passwordHash.value : this.passwordHash,
        failedAttempts: failedAttempts ?? this.failedAttempts,
        lockedUntil: lockedUntil.present ? lockedUntil.value : this.lockedUntil,
        lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      role: data.role.present ? data.role.value : this.role,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      failedAttempts: data.failedAttempts.present
          ? data.failedAttempts.value
          : this.failedAttempts,
      lockedUntil:
          data.lockedUntil.present ? data.lockedUntil.value : this.lockedUntil,
      lastLoginAt:
          data.lastLoginAt.present ? data.lastLoginAt.value : this.lastLoginAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      username,
      displayName,
      role,
      pinHash,
      passwordHash,
      failedAttempts,
      lockedUntil,
      lastLoginAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.role == this.role &&
          other.pinHash == this.pinHash &&
          other.passwordHash == this.passwordHash &&
          other.failedAttempts == this.failedAttempts &&
          other.lockedUntil == this.lockedUntil &&
          other.lastLoginAt == this.lastLoginAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String?> displayName;
  final Value<String> role;
  final Value<String> pinHash;
  final Value<String?> passwordHash;
  final Value<int> failedAttempts;
  final Value<DateTime?> lockedUntil;
  final Value<DateTime?> lastLoginAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.role = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    this.displayName = const Value.absent(),
    required String role,
    required String pinHash,
    this.passwordHash = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockedUntil = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : username = Value(username),
        role = Value(role),
        pinHash = Value(pinHash);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? role,
    Expression<String>? pinHash,
    Expression<String>? passwordHash,
    Expression<int>? failedAttempts,
    Expression<DateTime>? lockedUntil,
    Expression<DateTime>? lastLoginAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (role != null) 'role': role,
      if (pinHash != null) 'pin_hash': pinHash,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (failedAttempts != null) 'failed_attempts': failedAttempts,
      if (lockedUntil != null) 'locked_until': lockedUntil,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String?>? displayName,
      Value<String>? role,
      Value<String>? pinHash,
      Value<String?>? passwordHash,
      Value<int>? failedAttempts,
      Value<DateTime?>? lockedUntil,
      Value<DateTime?>? lastLoginAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      pinHash: pinHash ?? this.pinHash,
      passwordHash: passwordHash ?? this.passwordHash,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (failedAttempts.present) {
      map['failed_attempts'] = Variable<int>(failedAttempts.value);
    }
    if (lockedUntil.present) {
      map['locked_until'] = Variable<DateTime>(lockedUntil.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockedUntil: $lockedUntil, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SystemConfigsTable extends SystemConfigs
    with TableInfo<$SystemConfigsTable, SystemConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'system_configs';
  @override
  VerificationContext validateIntegrity(Insertable<SystemConfig> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SystemConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SystemConfig(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
    );
  }

  @override
  $SystemConfigsTable createAlias(String alias) {
    return $SystemConfigsTable(attachedDatabase, alias);
  }
}

class SystemConfig extends DataClass implements Insertable<SystemConfig> {
  final String key;
  final String? value;
  const SystemConfig({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  SystemConfigsCompanion toCompanion(bool nullToAbsent) {
    return SystemConfigsCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory SystemConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SystemConfig(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  SystemConfig copyWith(
          {String? key, Value<String?> value = const Value.absent()}) =>
      SystemConfig(
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
      );
  SystemConfig copyWithCompanion(SystemConfigsCompanion data) {
    return SystemConfig(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SystemConfig(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SystemConfig &&
          other.key == this.key &&
          other.value == this.value);
}

class SystemConfigsCompanion extends UpdateCompanion<SystemConfig> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const SystemConfigsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SystemConfigsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<SystemConfig> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SystemConfigsCompanion copyWith(
      {Value<String>? key, Value<String?>? value, Value<int>? rowid}) {
    return SystemConfigsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SystemConfigsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _usernameSnapshotMeta =
      const VerificationMeta('usernameSnapshot');
  @override
  late final GeneratedColumn<String> usernameSnapshot = GeneratedColumn<String>(
      'username_snapshot', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleSnapshotMeta =
      const VerificationMeta('roleSnapshot');
  @override
  late final GeneratedColumn<String> roleSnapshot = GeneratedColumn<String>(
      'role_snapshot', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, action, details, userId, usernameSnapshot, roleSnapshot, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('username_snapshot')) {
      context.handle(
          _usernameSnapshotMeta,
          usernameSnapshot.isAcceptableOrUnknown(
              data['username_snapshot']!, _usernameSnapshotMeta));
    }
    if (data.containsKey('role_snapshot')) {
      context.handle(
          _roleSnapshotMeta,
          roleSnapshot.isAcceptableOrUnknown(
              data['role_snapshot']!, _roleSnapshotMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      usernameSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}username_snapshot']),
      roleSnapshot: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role_snapshot']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final int id;
  final String action;
  final String? details;
  final int? userId;
  final String? usernameSnapshot;
  final String? roleSnapshot;
  final DateTime createdAt;
  const AuditLog(
      {required this.id,
      required this.action,
      this.details,
      this.userId,
      this.usernameSnapshot,
      this.roleSnapshot,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || usernameSnapshot != null) {
      map['username_snapshot'] = Variable<String>(usernameSnapshot);
    }
    if (!nullToAbsent || roleSnapshot != null) {
      map['role_snapshot'] = Variable<String>(roleSnapshot);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      action: Value(action),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      usernameSnapshot: usernameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(usernameSnapshot),
      roleSnapshot: roleSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(roleSnapshot),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<int>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      details: serializer.fromJson<String?>(json['details']),
      userId: serializer.fromJson<int?>(json['userId']),
      usernameSnapshot: serializer.fromJson<String?>(json['usernameSnapshot']),
      roleSnapshot: serializer.fromJson<String?>(json['roleSnapshot']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'action': serializer.toJson<String>(action),
      'details': serializer.toJson<String?>(details),
      'userId': serializer.toJson<int?>(userId),
      'usernameSnapshot': serializer.toJson<String?>(usernameSnapshot),
      'roleSnapshot': serializer.toJson<String?>(roleSnapshot),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditLog copyWith(
          {int? id,
          String? action,
          Value<String?> details = const Value.absent(),
          Value<int?> userId = const Value.absent(),
          Value<String?> usernameSnapshot = const Value.absent(),
          Value<String?> roleSnapshot = const Value.absent(),
          DateTime? createdAt}) =>
      AuditLog(
        id: id ?? this.id,
        action: action ?? this.action,
        details: details.present ? details.value : this.details,
        userId: userId.present ? userId.value : this.userId,
        usernameSnapshot: usernameSnapshot.present
            ? usernameSnapshot.value
            : this.usernameSnapshot,
        roleSnapshot:
            roleSnapshot.present ? roleSnapshot.value : this.roleSnapshot,
        createdAt: createdAt ?? this.createdAt,
      );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      action: data.action.present ? data.action.value : this.action,
      details: data.details.present ? data.details.value : this.details,
      userId: data.userId.present ? data.userId.value : this.userId,
      usernameSnapshot: data.usernameSnapshot.present
          ? data.usernameSnapshot.value
          : this.usernameSnapshot,
      roleSnapshot: data.roleSnapshot.present
          ? data.roleSnapshot.value
          : this.roleSnapshot,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('details: $details, ')
          ..write('userId: $userId, ')
          ..write('usernameSnapshot: $usernameSnapshot, ')
          ..write('roleSnapshot: $roleSnapshot, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, action, details, userId, usernameSnapshot, roleSnapshot, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.action == this.action &&
          other.details == this.details &&
          other.userId == this.userId &&
          other.usernameSnapshot == this.usernameSnapshot &&
          other.roleSnapshot == this.roleSnapshot &&
          other.createdAt == this.createdAt);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<int> id;
  final Value<String> action;
  final Value<String?> details;
  final Value<int?> userId;
  final Value<String?> usernameSnapshot;
  final Value<String?> roleSnapshot;
  final Value<DateTime> createdAt;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.details = const Value.absent(),
    this.userId = const Value.absent(),
    this.usernameSnapshot = const Value.absent(),
    this.roleSnapshot = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    this.id = const Value.absent(),
    required String action,
    this.details = const Value.absent(),
    this.userId = const Value.absent(),
    this.usernameSnapshot = const Value.absent(),
    this.roleSnapshot = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : action = Value(action);
  static Insertable<AuditLog> custom({
    Expression<int>? id,
    Expression<String>? action,
    Expression<String>? details,
    Expression<int>? userId,
    Expression<String>? usernameSnapshot,
    Expression<String>? roleSnapshot,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (details != null) 'details': details,
      if (userId != null) 'user_id': userId,
      if (usernameSnapshot != null) 'username_snapshot': usernameSnapshot,
      if (roleSnapshot != null) 'role_snapshot': roleSnapshot,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AuditLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? action,
      Value<String?>? details,
      Value<int?>? userId,
      Value<String?>? usernameSnapshot,
      Value<String?>? roleSnapshot,
      Value<DateTime>? createdAt}) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      details: details ?? this.details,
      userId: userId ?? this.userId,
      usernameSnapshot: usernameSnapshot ?? this.usernameSnapshot,
      roleSnapshot: roleSnapshot ?? this.roleSnapshot,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (usernameSnapshot.present) {
      map['username_snapshot'] = Variable<String>(usernameSnapshot.value);
    }
    if (roleSnapshot.present) {
      map['role_snapshot'] = Variable<String>(roleSnapshot.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('details: $details, ')
          ..write('userId: $userId, ')
          ..write('usernameSnapshot: $usernameSnapshot, ')
          ..write('roleSnapshot: $roleSnapshot, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PartCategoriesTable extends PartCategories
    with TableInfo<$PartCategoriesTable, PartCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameUrMeta = const VerificationMeta('nameUr');
  @override
  late final GeneratedColumn<String> nameUr = GeneratedColumn<String>(
      'name_ur', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, nameEn, nameUr, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'part_categories';
  @override
  VerificationContext validateIntegrity(Insertable<PartCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ur')) {
      context.handle(_nameUrMeta,
          nameUr.isAcceptableOrUnknown(data['name_ur']!, _nameUrMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PartCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      nameUr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ur']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $PartCategoriesTable createAlias(String alias) {
    return $PartCategoriesTable(attachedDatabase, alias);
  }
}

class PartCategory extends DataClass implements Insertable<PartCategory> {
  final int id;
  final String nameEn;
  final String? nameUr;
  final bool isActive;
  const PartCategory(
      {required this.id,
      required this.nameEn,
      this.nameUr,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || nameUr != null) {
      map['name_ur'] = Variable<String>(nameUr);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  PartCategoriesCompanion toCompanion(bool nullToAbsent) {
    return PartCategoriesCompanion(
      id: Value(id),
      nameEn: Value(nameEn),
      nameUr:
          nameUr == null && nullToAbsent ? const Value.absent() : Value(nameUr),
      isActive: Value(isActive),
    );
  }

  factory PartCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartCategory(
      id: serializer.fromJson<int>(json['id']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameUr: serializer.fromJson<String?>(json['nameUr']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameUr': serializer.toJson<String?>(nameUr),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  PartCategory copyWith(
          {int? id,
          String? nameEn,
          Value<String?> nameUr = const Value.absent(),
          bool? isActive}) =>
      PartCategory(
        id: id ?? this.id,
        nameEn: nameEn ?? this.nameEn,
        nameUr: nameUr.present ? nameUr.value : this.nameUr,
        isActive: isActive ?? this.isActive,
      );
  PartCategory copyWithCompanion(PartCategoriesCompanion data) {
    return PartCategory(
      id: data.id.present ? data.id.value : this.id,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameUr: data.nameUr.present ? data.nameUr.value : this.nameUr,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartCategory(')
          ..write('id: $id, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameUr: $nameUr, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameEn, nameUr, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartCategory &&
          other.id == this.id &&
          other.nameEn == this.nameEn &&
          other.nameUr == this.nameUr &&
          other.isActive == this.isActive);
}

class PartCategoriesCompanion extends UpdateCompanion<PartCategory> {
  final Value<int> id;
  final Value<String> nameEn;
  final Value<String?> nameUr;
  final Value<bool> isActive;
  const PartCategoriesCompanion({
    this.id = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameUr = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  PartCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String nameEn,
    this.nameUr = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : nameEn = Value(nameEn);
  static Insertable<PartCategory> custom({
    Expression<int>? id,
    Expression<String>? nameEn,
    Expression<String>? nameUr,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameEn != null) 'name_en': nameEn,
      if (nameUr != null) 'name_ur': nameUr,
      if (isActive != null) 'is_active': isActive,
    });
  }

  PartCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nameEn,
      Value<String?>? nameUr,
      Value<bool>? isActive}) {
    return PartCategoriesCompanion(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameUr: nameUr ?? this.nameUr,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameUr.present) {
      map['name_ur'] = Variable<String>(nameUr.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameUr: $nameUr, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $PartsTable extends Parts with TableInfo<$PartsTable, Part> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameUrMeta = const VerificationMeta('nameUr');
  @override
  late final GeneratedColumn<String> nameUr = GeneratedColumn<String>(
      'name_ur', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES part_categories (id)'));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PCS'));
  static const VerificationMeta _avgCostPaisaMeta =
      const VerificationMeta('avgCostPaisa');
  @override
  late final GeneratedColumn<int> avgCostPaisa = GeneratedColumn<int>(
      'avg_cost_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _retailPricePaisaMeta =
      const VerificationMeta('retailPricePaisa');
  @override
  late final GeneratedColumn<int> retailPricePaisa = GeneratedColumn<int>(
      'retail_price_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _wholesalePricePaisaMeta =
      const VerificationMeta('wholesalePricePaisa');
  @override
  late final GeneratedColumn<int> wholesalePricePaisa = GeneratedColumn<int>(
      'wholesale_price_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _shelfLocationMeta =
      const VerificationMeta('shelfLocation');
  @override
  late final GeneratedColumn<String> shelfLocation = GeneratedColumn<String>(
      'shelf_location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defectiveStockMeta =
      const VerificationMeta('defectiveStock');
  @override
  late final GeneratedColumn<int> defectiveStock = GeneratedColumn<int>(
      'defective_stock', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _currentStockMeta =
      const VerificationMeta('currentStock');
  @override
  late final GeneratedColumn<int> currentStock = GeneratedColumn<int>(
      'current_stock', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _minStockAlertMeta =
      const VerificationMeta('minStockAlert');
  @override
  late final GeneratedColumn<int> minStockAlert = GeneratedColumn<int>(
      'min_stock_alert', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        code,
        barcode,
        nameEn,
        nameUr,
        categoryId,
        unit,
        avgCostPaisa,
        retailPricePaisa,
        wholesalePricePaisa,
        shelfLocation,
        defectiveStock,
        currentStock,
        minStockAlert
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts';
  @override
  VerificationContext validateIntegrity(Insertable<Part> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ur')) {
      context.handle(_nameUrMeta,
          nameUr.isAcceptableOrUnknown(data['name_ur']!, _nameUrMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('avg_cost_paisa')) {
      context.handle(
          _avgCostPaisaMeta,
          avgCostPaisa.isAcceptableOrUnknown(
              data['avg_cost_paisa']!, _avgCostPaisaMeta));
    }
    if (data.containsKey('retail_price_paisa')) {
      context.handle(
          _retailPricePaisaMeta,
          retailPricePaisa.isAcceptableOrUnknown(
              data['retail_price_paisa']!, _retailPricePaisaMeta));
    }
    if (data.containsKey('wholesale_price_paisa')) {
      context.handle(
          _wholesalePricePaisaMeta,
          wholesalePricePaisa.isAcceptableOrUnknown(
              data['wholesale_price_paisa']!, _wholesalePricePaisaMeta));
    }
    if (data.containsKey('shelf_location')) {
      context.handle(
          _shelfLocationMeta,
          shelfLocation.isAcceptableOrUnknown(
              data['shelf_location']!, _shelfLocationMeta));
    }
    if (data.containsKey('defective_stock')) {
      context.handle(
          _defectiveStockMeta,
          defectiveStock.isAcceptableOrUnknown(
              data['defective_stock']!, _defectiveStockMeta));
    }
    if (data.containsKey('current_stock')) {
      context.handle(
          _currentStockMeta,
          currentStock.isAcceptableOrUnknown(
              data['current_stock']!, _currentStockMeta));
    }
    if (data.containsKey('min_stock_alert')) {
      context.handle(
          _minStockAlertMeta,
          minStockAlert.isAcceptableOrUnknown(
              data['min_stock_alert']!, _minStockAlertMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Part map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Part(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      nameUr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ur']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      avgCostPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}avg_cost_paisa'])!,
      retailPricePaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}retail_price_paisa'])!,
      wholesalePricePaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}wholesale_price_paisa'])!,
      shelfLocation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shelf_location']),
      defectiveStock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}defective_stock'])!,
      currentStock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_stock'])!,
      minStockAlert: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}min_stock_alert'])!,
    );
  }

  @override
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }
}

class Part extends DataClass implements Insertable<Part> {
  final int id;
  final String code;
  final String? barcode;
  final String nameEn;
  final String? nameUr;
  final int categoryId;
  final String unit;
  final int avgCostPaisa;
  final int retailPricePaisa;
  final int wholesalePricePaisa;
  final String? shelfLocation;
  final int defectiveStock;
  final int currentStock;
  final int minStockAlert;
  const Part(
      {required this.id,
      required this.code,
      this.barcode,
      required this.nameEn,
      this.nameUr,
      required this.categoryId,
      required this.unit,
      required this.avgCostPaisa,
      required this.retailPricePaisa,
      required this.wholesalePricePaisa,
      this.shelfLocation,
      required this.defectiveStock,
      required this.currentStock,
      required this.minStockAlert});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || nameUr != null) {
      map['name_ur'] = Variable<String>(nameUr);
    }
    map['category_id'] = Variable<int>(categoryId);
    map['unit'] = Variable<String>(unit);
    map['avg_cost_paisa'] = Variable<int>(avgCostPaisa);
    map['retail_price_paisa'] = Variable<int>(retailPricePaisa);
    map['wholesale_price_paisa'] = Variable<int>(wholesalePricePaisa);
    if (!nullToAbsent || shelfLocation != null) {
      map['shelf_location'] = Variable<String>(shelfLocation);
    }
    map['defective_stock'] = Variable<int>(defectiveStock);
    map['current_stock'] = Variable<int>(currentStock);
    map['min_stock_alert'] = Variable<int>(minStockAlert);
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      code: Value(code),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      nameEn: Value(nameEn),
      nameUr:
          nameUr == null && nullToAbsent ? const Value.absent() : Value(nameUr),
      categoryId: Value(categoryId),
      unit: Value(unit),
      avgCostPaisa: Value(avgCostPaisa),
      retailPricePaisa: Value(retailPricePaisa),
      wholesalePricePaisa: Value(wholesalePricePaisa),
      shelfLocation: shelfLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfLocation),
      defectiveStock: Value(defectiveStock),
      currentStock: Value(currentStock),
      minStockAlert: Value(minStockAlert),
    );
  }

  factory Part.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Part(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameUr: serializer.fromJson<String?>(json['nameUr']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      unit: serializer.fromJson<String>(json['unit']),
      avgCostPaisa: serializer.fromJson<int>(json['avgCostPaisa']),
      retailPricePaisa: serializer.fromJson<int>(json['retailPricePaisa']),
      wholesalePricePaisa:
          serializer.fromJson<int>(json['wholesalePricePaisa']),
      shelfLocation: serializer.fromJson<String?>(json['shelfLocation']),
      defectiveStock: serializer.fromJson<int>(json['defectiveStock']),
      currentStock: serializer.fromJson<int>(json['currentStock']),
      minStockAlert: serializer.fromJson<int>(json['minStockAlert']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'barcode': serializer.toJson<String?>(barcode),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameUr': serializer.toJson<String?>(nameUr),
      'categoryId': serializer.toJson<int>(categoryId),
      'unit': serializer.toJson<String>(unit),
      'avgCostPaisa': serializer.toJson<int>(avgCostPaisa),
      'retailPricePaisa': serializer.toJson<int>(retailPricePaisa),
      'wholesalePricePaisa': serializer.toJson<int>(wholesalePricePaisa),
      'shelfLocation': serializer.toJson<String?>(shelfLocation),
      'defectiveStock': serializer.toJson<int>(defectiveStock),
      'currentStock': serializer.toJson<int>(currentStock),
      'minStockAlert': serializer.toJson<int>(minStockAlert),
    };
  }

  Part copyWith(
          {int? id,
          String? code,
          Value<String?> barcode = const Value.absent(),
          String? nameEn,
          Value<String?> nameUr = const Value.absent(),
          int? categoryId,
          String? unit,
          int? avgCostPaisa,
          int? retailPricePaisa,
          int? wholesalePricePaisa,
          Value<String?> shelfLocation = const Value.absent(),
          int? defectiveStock,
          int? currentStock,
          int? minStockAlert}) =>
      Part(
        id: id ?? this.id,
        code: code ?? this.code,
        barcode: barcode.present ? barcode.value : this.barcode,
        nameEn: nameEn ?? this.nameEn,
        nameUr: nameUr.present ? nameUr.value : this.nameUr,
        categoryId: categoryId ?? this.categoryId,
        unit: unit ?? this.unit,
        avgCostPaisa: avgCostPaisa ?? this.avgCostPaisa,
        retailPricePaisa: retailPricePaisa ?? this.retailPricePaisa,
        wholesalePricePaisa: wholesalePricePaisa ?? this.wholesalePricePaisa,
        shelfLocation:
            shelfLocation.present ? shelfLocation.value : this.shelfLocation,
        defectiveStock: defectiveStock ?? this.defectiveStock,
        currentStock: currentStock ?? this.currentStock,
        minStockAlert: minStockAlert ?? this.minStockAlert,
      );
  Part copyWithCompanion(PartsCompanion data) {
    return Part(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameUr: data.nameUr.present ? data.nameUr.value : this.nameUr,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      unit: data.unit.present ? data.unit.value : this.unit,
      avgCostPaisa: data.avgCostPaisa.present
          ? data.avgCostPaisa.value
          : this.avgCostPaisa,
      retailPricePaisa: data.retailPricePaisa.present
          ? data.retailPricePaisa.value
          : this.retailPricePaisa,
      wholesalePricePaisa: data.wholesalePricePaisa.present
          ? data.wholesalePricePaisa.value
          : this.wholesalePricePaisa,
      shelfLocation: data.shelfLocation.present
          ? data.shelfLocation.value
          : this.shelfLocation,
      defectiveStock: data.defectiveStock.present
          ? data.defectiveStock.value
          : this.defectiveStock,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      minStockAlert: data.minStockAlert.present
          ? data.minStockAlert.value
          : this.minStockAlert,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Part(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('barcode: $barcode, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameUr: $nameUr, ')
          ..write('categoryId: $categoryId, ')
          ..write('unit: $unit, ')
          ..write('avgCostPaisa: $avgCostPaisa, ')
          ..write('retailPricePaisa: $retailPricePaisa, ')
          ..write('wholesalePricePaisa: $wholesalePricePaisa, ')
          ..write('shelfLocation: $shelfLocation, ')
          ..write('defectiveStock: $defectiveStock, ')
          ..write('currentStock: $currentStock, ')
          ..write('minStockAlert: $minStockAlert')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      code,
      barcode,
      nameEn,
      nameUr,
      categoryId,
      unit,
      avgCostPaisa,
      retailPricePaisa,
      wholesalePricePaisa,
      shelfLocation,
      defectiveStock,
      currentStock,
      minStockAlert);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Part &&
          other.id == this.id &&
          other.code == this.code &&
          other.barcode == this.barcode &&
          other.nameEn == this.nameEn &&
          other.nameUr == this.nameUr &&
          other.categoryId == this.categoryId &&
          other.unit == this.unit &&
          other.avgCostPaisa == this.avgCostPaisa &&
          other.retailPricePaisa == this.retailPricePaisa &&
          other.wholesalePricePaisa == this.wholesalePricePaisa &&
          other.shelfLocation == this.shelfLocation &&
          other.defectiveStock == this.defectiveStock &&
          other.currentStock == this.currentStock &&
          other.minStockAlert == this.minStockAlert);
}

class PartsCompanion extends UpdateCompanion<Part> {
  final Value<int> id;
  final Value<String> code;
  final Value<String?> barcode;
  final Value<String> nameEn;
  final Value<String?> nameUr;
  final Value<int> categoryId;
  final Value<String> unit;
  final Value<int> avgCostPaisa;
  final Value<int> retailPricePaisa;
  final Value<int> wholesalePricePaisa;
  final Value<String?> shelfLocation;
  final Value<int> defectiveStock;
  final Value<int> currentStock;
  final Value<int> minStockAlert;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.barcode = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameUr = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unit = const Value.absent(),
    this.avgCostPaisa = const Value.absent(),
    this.retailPricePaisa = const Value.absent(),
    this.wholesalePricePaisa = const Value.absent(),
    this.shelfLocation = const Value.absent(),
    this.defectiveStock = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.minStockAlert = const Value.absent(),
  });
  PartsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    this.barcode = const Value.absent(),
    required String nameEn,
    this.nameUr = const Value.absent(),
    required int categoryId,
    this.unit = const Value.absent(),
    this.avgCostPaisa = const Value.absent(),
    this.retailPricePaisa = const Value.absent(),
    this.wholesalePricePaisa = const Value.absent(),
    this.shelfLocation = const Value.absent(),
    this.defectiveStock = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.minStockAlert = const Value.absent(),
  })  : code = Value(code),
        nameEn = Value(nameEn),
        categoryId = Value(categoryId);
  static Insertable<Part> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? barcode,
    Expression<String>? nameEn,
    Expression<String>? nameUr,
    Expression<int>? categoryId,
    Expression<String>? unit,
    Expression<int>? avgCostPaisa,
    Expression<int>? retailPricePaisa,
    Expression<int>? wholesalePricePaisa,
    Expression<String>? shelfLocation,
    Expression<int>? defectiveStock,
    Expression<int>? currentStock,
    Expression<int>? minStockAlert,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (barcode != null) 'barcode': barcode,
      if (nameEn != null) 'name_en': nameEn,
      if (nameUr != null) 'name_ur': nameUr,
      if (categoryId != null) 'category_id': categoryId,
      if (unit != null) 'unit': unit,
      if (avgCostPaisa != null) 'avg_cost_paisa': avgCostPaisa,
      if (retailPricePaisa != null) 'retail_price_paisa': retailPricePaisa,
      if (wholesalePricePaisa != null)
        'wholesale_price_paisa': wholesalePricePaisa,
      if (shelfLocation != null) 'shelf_location': shelfLocation,
      if (defectiveStock != null) 'defective_stock': defectiveStock,
      if (currentStock != null) 'current_stock': currentStock,
      if (minStockAlert != null) 'min_stock_alert': minStockAlert,
    });
  }

  PartsCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String?>? barcode,
      Value<String>? nameEn,
      Value<String?>? nameUr,
      Value<int>? categoryId,
      Value<String>? unit,
      Value<int>? avgCostPaisa,
      Value<int>? retailPricePaisa,
      Value<int>? wholesalePricePaisa,
      Value<String?>? shelfLocation,
      Value<int>? defectiveStock,
      Value<int>? currentStock,
      Value<int>? minStockAlert}) {
    return PartsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      barcode: barcode ?? this.barcode,
      nameEn: nameEn ?? this.nameEn,
      nameUr: nameUr ?? this.nameUr,
      categoryId: categoryId ?? this.categoryId,
      unit: unit ?? this.unit,
      avgCostPaisa: avgCostPaisa ?? this.avgCostPaisa,
      retailPricePaisa: retailPricePaisa ?? this.retailPricePaisa,
      wholesalePricePaisa: wholesalePricePaisa ?? this.wholesalePricePaisa,
      shelfLocation: shelfLocation ?? this.shelfLocation,
      defectiveStock: defectiveStock ?? this.defectiveStock,
      currentStock: currentStock ?? this.currentStock,
      minStockAlert: minStockAlert ?? this.minStockAlert,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameUr.present) {
      map['name_ur'] = Variable<String>(nameUr.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (avgCostPaisa.present) {
      map['avg_cost_paisa'] = Variable<int>(avgCostPaisa.value);
    }
    if (retailPricePaisa.present) {
      map['retail_price_paisa'] = Variable<int>(retailPricePaisa.value);
    }
    if (wholesalePricePaisa.present) {
      map['wholesale_price_paisa'] = Variable<int>(wholesalePricePaisa.value);
    }
    if (shelfLocation.present) {
      map['shelf_location'] = Variable<String>(shelfLocation.value);
    }
    if (defectiveStock.present) {
      map['defective_stock'] = Variable<int>(defectiveStock.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<int>(currentStock.value);
    }
    if (minStockAlert.present) {
      map['min_stock_alert'] = Variable<int>(minStockAlert.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('barcode: $barcode, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameUr: $nameUr, ')
          ..write('categoryId: $categoryId, ')
          ..write('unit: $unit, ')
          ..write('avgCostPaisa: $avgCostPaisa, ')
          ..write('retailPricePaisa: $retailPricePaisa, ')
          ..write('wholesalePricePaisa: $wholesalePricePaisa, ')
          ..write('shelfLocation: $shelfLocation, ')
          ..write('defectiveStock: $defectiveStock, ')
          ..write('currentStock: $currentStock, ')
          ..write('minStockAlert: $minStockAlert')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
      'part_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES parts (id)'));
  static const VerificationMeta _movementTypeMeta =
      const VerificationMeta('movementType');
  @override
  late final GeneratedColumn<String> movementType = GeneratedColumn<String>(
      'movement_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _qtyChangeMeta =
      const VerificationMeta('qtyChange');
  @override
  late final GeneratedColumn<int> qtyChange = GeneratedColumn<int>(
      'qty_change', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitCostPaisaMeta =
      const VerificationMeta('unitCostPaisa');
  @override
  late final GeneratedColumn<int> unitCostPaisa = GeneratedColumn<int>(
      'unit_cost_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _refTableMeta =
      const VerificationMeta('refTable');
  @override
  late final GeneratedColumn<String> refTable = GeneratedColumn<String>(
      'ref_table', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<int> refId = GeneratedColumn<int>(
      'ref_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        partId,
        movementType,
        qtyChange,
        unitCostPaisa,
        refTable,
        refId,
        notes,
        userId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(Insertable<StockMovement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(_partIdMeta,
          partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta));
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('movement_type')) {
      context.handle(
          _movementTypeMeta,
          movementType.isAcceptableOrUnknown(
              data['movement_type']!, _movementTypeMeta));
    } else if (isInserting) {
      context.missing(_movementTypeMeta);
    }
    if (data.containsKey('qty_change')) {
      context.handle(_qtyChangeMeta,
          qtyChange.isAcceptableOrUnknown(data['qty_change']!, _qtyChangeMeta));
    } else if (isInserting) {
      context.missing(_qtyChangeMeta);
    }
    if (data.containsKey('unit_cost_paisa')) {
      context.handle(
          _unitCostPaisaMeta,
          unitCostPaisa.isAcceptableOrUnknown(
              data['unit_cost_paisa']!, _unitCostPaisaMeta));
    } else if (isInserting) {
      context.missing(_unitCostPaisaMeta);
    }
    if (data.containsKey('ref_table')) {
      context.handle(_refTableMeta,
          refTable.isAcceptableOrUnknown(data['ref_table']!, _refTableMeta));
    }
    if (data.containsKey('ref_id')) {
      context.handle(
          _refIdMeta, refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      partId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}part_id'])!,
      movementType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}movement_type'])!,
      qtyChange: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}qty_change'])!,
      unitCostPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_cost_paisa'])!,
      refTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_table']),
      refId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ref_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final int id;
  final int partId;
  final String movementType;
  final int qtyChange;
  final int unitCostPaisa;
  final String? refTable;
  final int? refId;
  final String? notes;
  final int userId;
  final DateTime createdAt;
  const StockMovement(
      {required this.id,
      required this.partId,
      required this.movementType,
      required this.qtyChange,
      required this.unitCostPaisa,
      this.refTable,
      this.refId,
      this.notes,
      required this.userId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['part_id'] = Variable<int>(partId);
    map['movement_type'] = Variable<String>(movementType);
    map['qty_change'] = Variable<int>(qtyChange);
    map['unit_cost_paisa'] = Variable<int>(unitCostPaisa);
    if (!nullToAbsent || refTable != null) {
      map['ref_table'] = Variable<String>(refTable);
    }
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<int>(refId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['user_id'] = Variable<int>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      partId: Value(partId),
      movementType: Value(movementType),
      qtyChange: Value(qtyChange),
      unitCostPaisa: Value(unitCostPaisa),
      refTable: refTable == null && nullToAbsent
          ? const Value.absent()
          : Value(refTable),
      refId:
          refId == null && nullToAbsent ? const Value.absent() : Value(refId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      userId: Value(userId),
      createdAt: Value(createdAt),
    );
  }

  factory StockMovement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<int>(json['id']),
      partId: serializer.fromJson<int>(json['partId']),
      movementType: serializer.fromJson<String>(json['movementType']),
      qtyChange: serializer.fromJson<int>(json['qtyChange']),
      unitCostPaisa: serializer.fromJson<int>(json['unitCostPaisa']),
      refTable: serializer.fromJson<String?>(json['refTable']),
      refId: serializer.fromJson<int?>(json['refId']),
      notes: serializer.fromJson<String?>(json['notes']),
      userId: serializer.fromJson<int>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partId': serializer.toJson<int>(partId),
      'movementType': serializer.toJson<String>(movementType),
      'qtyChange': serializer.toJson<int>(qtyChange),
      'unitCostPaisa': serializer.toJson<int>(unitCostPaisa),
      'refTable': serializer.toJson<String?>(refTable),
      'refId': serializer.toJson<int?>(refId),
      'notes': serializer.toJson<String?>(notes),
      'userId': serializer.toJson<int>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockMovement copyWith(
          {int? id,
          int? partId,
          String? movementType,
          int? qtyChange,
          int? unitCostPaisa,
          Value<String?> refTable = const Value.absent(),
          Value<int?> refId = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          int? userId,
          DateTime? createdAt}) =>
      StockMovement(
        id: id ?? this.id,
        partId: partId ?? this.partId,
        movementType: movementType ?? this.movementType,
        qtyChange: qtyChange ?? this.qtyChange,
        unitCostPaisa: unitCostPaisa ?? this.unitCostPaisa,
        refTable: refTable.present ? refTable.value : this.refTable,
        refId: refId.present ? refId.value : this.refId,
        notes: notes.present ? notes.value : this.notes,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
      );
  StockMovement copyWithCompanion(StockMovementsCompanion data) {
    return StockMovement(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      movementType: data.movementType.present
          ? data.movementType.value
          : this.movementType,
      qtyChange: data.qtyChange.present ? data.qtyChange.value : this.qtyChange,
      unitCostPaisa: data.unitCostPaisa.present
          ? data.unitCostPaisa.value
          : this.unitCostPaisa,
      refTable: data.refTable.present ? data.refTable.value : this.refTable,
      refId: data.refId.present ? data.refId.value : this.refId,
      notes: data.notes.present ? data.notes.value : this.notes,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('movementType: $movementType, ')
          ..write('qtyChange: $qtyChange, ')
          ..write('unitCostPaisa: $unitCostPaisa, ')
          ..write('refTable: $refTable, ')
          ..write('refId: $refId, ')
          ..write('notes: $notes, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, partId, movementType, qtyChange,
      unitCostPaisa, refTable, refId, notes, userId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.movementType == this.movementType &&
          other.qtyChange == this.qtyChange &&
          other.unitCostPaisa == this.unitCostPaisa &&
          other.refTable == this.refTable &&
          other.refId == this.refId &&
          other.notes == this.notes &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<int> id;
  final Value<int> partId;
  final Value<String> movementType;
  final Value<int> qtyChange;
  final Value<int> unitCostPaisa;
  final Value<String?> refTable;
  final Value<int?> refId;
  final Value<String?> notes;
  final Value<int> userId;
  final Value<DateTime> createdAt;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.movementType = const Value.absent(),
    this.qtyChange = const Value.absent(),
    this.unitCostPaisa = const Value.absent(),
    this.refTable = const Value.absent(),
    this.refId = const Value.absent(),
    this.notes = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    this.id = const Value.absent(),
    required int partId,
    required String movementType,
    required int qtyChange,
    required int unitCostPaisa,
    this.refTable = const Value.absent(),
    this.refId = const Value.absent(),
    this.notes = const Value.absent(),
    required int userId,
    this.createdAt = const Value.absent(),
  })  : partId = Value(partId),
        movementType = Value(movementType),
        qtyChange = Value(qtyChange),
        unitCostPaisa = Value(unitCostPaisa),
        userId = Value(userId);
  static Insertable<StockMovement> custom({
    Expression<int>? id,
    Expression<int>? partId,
    Expression<String>? movementType,
    Expression<int>? qtyChange,
    Expression<int>? unitCostPaisa,
    Expression<String>? refTable,
    Expression<int>? refId,
    Expression<String>? notes,
    Expression<int>? userId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (movementType != null) 'movement_type': movementType,
      if (qtyChange != null) 'qty_change': qtyChange,
      if (unitCostPaisa != null) 'unit_cost_paisa': unitCostPaisa,
      if (refTable != null) 'ref_table': refTable,
      if (refId != null) 'ref_id': refId,
      if (notes != null) 'notes': notes,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StockMovementsCompanion copyWith(
      {Value<int>? id,
      Value<int>? partId,
      Value<String>? movementType,
      Value<int>? qtyChange,
      Value<int>? unitCostPaisa,
      Value<String?>? refTable,
      Value<int?>? refId,
      Value<String?>? notes,
      Value<int>? userId,
      Value<DateTime>? createdAt}) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      movementType: movementType ?? this.movementType,
      qtyChange: qtyChange ?? this.qtyChange,
      unitCostPaisa: unitCostPaisa ?? this.unitCostPaisa,
      refTable: refTable ?? this.refTable,
      refId: refId ?? this.refId,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (movementType.present) {
      map['movement_type'] = Variable<String>(movementType.value);
    }
    if (qtyChange.present) {
      map['qty_change'] = Variable<int>(qtyChange.value);
    }
    if (unitCostPaisa.present) {
      map['unit_cost_paisa'] = Variable<int>(unitCostPaisa.value);
    }
    if (refTable.present) {
      map['ref_table'] = Variable<String>(refTable.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<int>(refId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('movementType: $movementType, ')
          ..write('qtyChange: $qtyChange, ')
          ..write('unitCostPaisa: $unitCostPaisa, ')
          ..write('refTable: $refTable, ')
          ..write('refId: $refId, ')
          ..write('notes: $notes, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shopNameMeta =
      const VerificationMeta('shopName');
  @override
  late final GeneratedColumn<String> shopName = GeneratedColumn<String>(
      'shop_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerTypeMeta =
      const VerificationMeta('customerType');
  @override
  late final GeneratedColumn<String> customerType = GeneratedColumn<String>(
      'customer_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('RETAIL'));
  static const VerificationMeta _creditLimitPaisaMeta =
      const VerificationMeta('creditLimitPaisa');
  @override
  late final GeneratedColumn<int> creditLimitPaisa = GeneratedColumn<int>(
      'credit_limit_paisa', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currentBalancePaisaMeta =
      const VerificationMeta('currentBalancePaisa');
  @override
  late final GeneratedColumn<int> currentBalancePaisa = GeneratedColumn<int>(
      'current_balance_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        shopName,
        phone,
        address,
        customerType,
        creditLimitPaisa,
        currentBalancePaisa
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('shop_name')) {
      context.handle(_shopNameMeta,
          shopName.isAcceptableOrUnknown(data['shop_name']!, _shopNameMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('customer_type')) {
      context.handle(
          _customerTypeMeta,
          customerType.isAcceptableOrUnknown(
              data['customer_type']!, _customerTypeMeta));
    }
    if (data.containsKey('credit_limit_paisa')) {
      context.handle(
          _creditLimitPaisaMeta,
          creditLimitPaisa.isAcceptableOrUnknown(
              data['credit_limit_paisa']!, _creditLimitPaisaMeta));
    }
    if (data.containsKey('current_balance_paisa')) {
      context.handle(
          _currentBalancePaisaMeta,
          currentBalancePaisa.isAcceptableOrUnknown(
              data['current_balance_paisa']!, _currentBalancePaisaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      shopName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shop_name']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      customerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_type'])!,
      creditLimitPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}credit_limit_paisa']),
      currentBalancePaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}current_balance_paisa'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String? shopName;
  final String? phone;
  final String? address;
  final String customerType;
  final int? creditLimitPaisa;
  final int currentBalancePaisa;
  const Customer(
      {required this.id,
      required this.name,
      this.shopName,
      this.phone,
      this.address,
      required this.customerType,
      this.creditLimitPaisa,
      required this.currentBalancePaisa});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || shopName != null) {
      map['shop_name'] = Variable<String>(shopName);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['customer_type'] = Variable<String>(customerType);
    if (!nullToAbsent || creditLimitPaisa != null) {
      map['credit_limit_paisa'] = Variable<int>(creditLimitPaisa);
    }
    map['current_balance_paisa'] = Variable<int>(currentBalancePaisa);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      shopName: shopName == null && nullToAbsent
          ? const Value.absent()
          : Value(shopName),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      customerType: Value(customerType),
      creditLimitPaisa: creditLimitPaisa == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimitPaisa),
      currentBalancePaisa: Value(currentBalancePaisa),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      shopName: serializer.fromJson<String?>(json['shopName']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      customerType: serializer.fromJson<String>(json['customerType']),
      creditLimitPaisa: serializer.fromJson<int?>(json['creditLimitPaisa']),
      currentBalancePaisa:
          serializer.fromJson<int>(json['currentBalancePaisa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'shopName': serializer.toJson<String?>(shopName),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'customerType': serializer.toJson<String>(customerType),
      'creditLimitPaisa': serializer.toJson<int?>(creditLimitPaisa),
      'currentBalancePaisa': serializer.toJson<int>(currentBalancePaisa),
    };
  }

  Customer copyWith(
          {int? id,
          String? name,
          Value<String?> shopName = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> address = const Value.absent(),
          String? customerType,
          Value<int?> creditLimitPaisa = const Value.absent(),
          int? currentBalancePaisa}) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        shopName: shopName.present ? shopName.value : this.shopName,
        phone: phone.present ? phone.value : this.phone,
        address: address.present ? address.value : this.address,
        customerType: customerType ?? this.customerType,
        creditLimitPaisa: creditLimitPaisa.present
            ? creditLimitPaisa.value
            : this.creditLimitPaisa,
        currentBalancePaisa: currentBalancePaisa ?? this.currentBalancePaisa,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      shopName: data.shopName.present ? data.shopName.value : this.shopName,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      customerType: data.customerType.present
          ? data.customerType.value
          : this.customerType,
      creditLimitPaisa: data.creditLimitPaisa.present
          ? data.creditLimitPaisa.value
          : this.creditLimitPaisa,
      currentBalancePaisa: data.currentBalancePaisa.present
          ? data.currentBalancePaisa.value
          : this.currentBalancePaisa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shopName: $shopName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('customerType: $customerType, ')
          ..write('creditLimitPaisa: $creditLimitPaisa, ')
          ..write('currentBalancePaisa: $currentBalancePaisa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, shopName, phone, address,
      customerType, creditLimitPaisa, currentBalancePaisa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.shopName == this.shopName &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.customerType == this.customerType &&
          other.creditLimitPaisa == this.creditLimitPaisa &&
          other.currentBalancePaisa == this.currentBalancePaisa);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> shopName;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String> customerType;
  final Value<int?> creditLimitPaisa;
  final Value<int> currentBalancePaisa;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.shopName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.customerType = const Value.absent(),
    this.creditLimitPaisa = const Value.absent(),
    this.currentBalancePaisa = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.shopName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.customerType = const Value.absent(),
    this.creditLimitPaisa = const Value.absent(),
    this.currentBalancePaisa = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? shopName,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? customerType,
    Expression<int>? creditLimitPaisa,
    Expression<int>? currentBalancePaisa,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (shopName != null) 'shop_name': shopName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (customerType != null) 'customer_type': customerType,
      if (creditLimitPaisa != null) 'credit_limit_paisa': creditLimitPaisa,
      if (currentBalancePaisa != null)
        'current_balance_paisa': currentBalancePaisa,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? shopName,
      Value<String?>? phone,
      Value<String?>? address,
      Value<String>? customerType,
      Value<int?>? creditLimitPaisa,
      Value<int>? currentBalancePaisa}) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      shopName: shopName ?? this.shopName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      customerType: customerType ?? this.customerType,
      creditLimitPaisa: creditLimitPaisa ?? this.creditLimitPaisa,
      currentBalancePaisa: currentBalancePaisa ?? this.currentBalancePaisa,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (shopName.present) {
      map['shop_name'] = Variable<String>(shopName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (customerType.present) {
      map['customer_type'] = Variable<String>(customerType.value);
    }
    if (creditLimitPaisa.present) {
      map['credit_limit_paisa'] = Variable<int>(creditLimitPaisa.value);
    }
    if (currentBalancePaisa.present) {
      map['current_balance_paisa'] = Variable<int>(currentBalancePaisa.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shopName: $shopName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('customerType: $customerType, ')
          ..write('creditLimitPaisa: $creditLimitPaisa, ')
          ..write('currentBalancePaisa: $currentBalancePaisa')
          ..write(')'))
        .toString();
  }
}

class $CustomerLedgerEntriesTable extends CustomerLedgerEntries
    with TableInfo<$CustomerLedgerEntriesTable, CustomerLedgerEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerLedgerEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
      'invoice_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _entryTypeMeta =
      const VerificationMeta('entryType');
  @override
  late final GeneratedColumn<String> entryType = GeneratedColumn<String>(
      'entry_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _debitAmountPaisaMeta =
      const VerificationMeta('debitAmountPaisa');
  @override
  late final GeneratedColumn<int> debitAmountPaisa = GeneratedColumn<int>(
      'debit_amount_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _creditAmountPaisaMeta =
      const VerificationMeta('creditAmountPaisa');
  @override
  late final GeneratedColumn<int> creditAmountPaisa = GeneratedColumn<int>(
      'credit_amount_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _runningBalancePaisaMeta =
      const VerificationMeta('runningBalancePaisa');
  @override
  late final GeneratedColumn<int> runningBalancePaisa = GeneratedColumn<int>(
      'running_balance_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        customerId,
        invoiceId,
        entryType,
        debitAmountPaisa,
        creditAmountPaisa,
        runningBalancePaisa,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer_ledger_entries';
  @override
  VerificationContext validateIntegrity(
      Insertable<CustomerLedgerEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    }
    if (data.containsKey('entry_type')) {
      context.handle(_entryTypeMeta,
          entryType.isAcceptableOrUnknown(data['entry_type']!, _entryTypeMeta));
    } else if (isInserting) {
      context.missing(_entryTypeMeta);
    }
    if (data.containsKey('debit_amount_paisa')) {
      context.handle(
          _debitAmountPaisaMeta,
          debitAmountPaisa.isAcceptableOrUnknown(
              data['debit_amount_paisa']!, _debitAmountPaisaMeta));
    }
    if (data.containsKey('credit_amount_paisa')) {
      context.handle(
          _creditAmountPaisaMeta,
          creditAmountPaisa.isAcceptableOrUnknown(
              data['credit_amount_paisa']!, _creditAmountPaisaMeta));
    }
    if (data.containsKey('running_balance_paisa')) {
      context.handle(
          _runningBalancePaisaMeta,
          runningBalancePaisa.isAcceptableOrUnknown(
              data['running_balance_paisa']!, _runningBalancePaisaMeta));
    } else if (isInserting) {
      context.missing(_runningBalancePaisaMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerLedgerEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerLedgerEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_id']),
      entryType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry_type'])!,
      debitAmountPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}debit_amount_paisa'])!,
      creditAmountPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}credit_amount_paisa'])!,
      runningBalancePaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}running_balance_paisa'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomerLedgerEntriesTable createAlias(String alias) {
    return $CustomerLedgerEntriesTable(attachedDatabase, alias);
  }
}

class CustomerLedgerEntry extends DataClass
    implements Insertable<CustomerLedgerEntry> {
  final int id;
  final int customerId;
  final int? invoiceId;
  final String entryType;
  final int debitAmountPaisa;
  final int creditAmountPaisa;
  final int runningBalancePaisa;
  final String? notes;
  final DateTime createdAt;
  const CustomerLedgerEntry(
      {required this.id,
      required this.customerId,
      this.invoiceId,
      required this.entryType,
      required this.debitAmountPaisa,
      required this.creditAmountPaisa,
      required this.runningBalancePaisa,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_id'] = Variable<int>(customerId);
    if (!nullToAbsent || invoiceId != null) {
      map['invoice_id'] = Variable<int>(invoiceId);
    }
    map['entry_type'] = Variable<String>(entryType);
    map['debit_amount_paisa'] = Variable<int>(debitAmountPaisa);
    map['credit_amount_paisa'] = Variable<int>(creditAmountPaisa);
    map['running_balance_paisa'] = Variable<int>(runningBalancePaisa);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomerLedgerEntriesCompanion toCompanion(bool nullToAbsent) {
    return CustomerLedgerEntriesCompanion(
      id: Value(id),
      customerId: Value(customerId),
      invoiceId: invoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceId),
      entryType: Value(entryType),
      debitAmountPaisa: Value(debitAmountPaisa),
      creditAmountPaisa: Value(creditAmountPaisa),
      runningBalancePaisa: Value(runningBalancePaisa),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory CustomerLedgerEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerLedgerEntry(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<int>(json['customerId']),
      invoiceId: serializer.fromJson<int?>(json['invoiceId']),
      entryType: serializer.fromJson<String>(json['entryType']),
      debitAmountPaisa: serializer.fromJson<int>(json['debitAmountPaisa']),
      creditAmountPaisa: serializer.fromJson<int>(json['creditAmountPaisa']),
      runningBalancePaisa:
          serializer.fromJson<int>(json['runningBalancePaisa']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<int>(customerId),
      'invoiceId': serializer.toJson<int?>(invoiceId),
      'entryType': serializer.toJson<String>(entryType),
      'debitAmountPaisa': serializer.toJson<int>(debitAmountPaisa),
      'creditAmountPaisa': serializer.toJson<int>(creditAmountPaisa),
      'runningBalancePaisa': serializer.toJson<int>(runningBalancePaisa),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomerLedgerEntry copyWith(
          {int? id,
          int? customerId,
          Value<int?> invoiceId = const Value.absent(),
          String? entryType,
          int? debitAmountPaisa,
          int? creditAmountPaisa,
          int? runningBalancePaisa,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      CustomerLedgerEntry(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
        entryType: entryType ?? this.entryType,
        debitAmountPaisa: debitAmountPaisa ?? this.debitAmountPaisa,
        creditAmountPaisa: creditAmountPaisa ?? this.creditAmountPaisa,
        runningBalancePaisa: runningBalancePaisa ?? this.runningBalancePaisa,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  CustomerLedgerEntry copyWithCompanion(CustomerLedgerEntriesCompanion data) {
    return CustomerLedgerEntry(
      id: data.id.present ? data.id.value : this.id,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      entryType: data.entryType.present ? data.entryType.value : this.entryType,
      debitAmountPaisa: data.debitAmountPaisa.present
          ? data.debitAmountPaisa.value
          : this.debitAmountPaisa,
      creditAmountPaisa: data.creditAmountPaisa.present
          ? data.creditAmountPaisa.value
          : this.creditAmountPaisa,
      runningBalancePaisa: data.runningBalancePaisa.present
          ? data.runningBalancePaisa.value
          : this.runningBalancePaisa,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerLedgerEntry(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('entryType: $entryType, ')
          ..write('debitAmountPaisa: $debitAmountPaisa, ')
          ..write('creditAmountPaisa: $creditAmountPaisa, ')
          ..write('runningBalancePaisa: $runningBalancePaisa, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      customerId,
      invoiceId,
      entryType,
      debitAmountPaisa,
      creditAmountPaisa,
      runningBalancePaisa,
      notes,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerLedgerEntry &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.invoiceId == this.invoiceId &&
          other.entryType == this.entryType &&
          other.debitAmountPaisa == this.debitAmountPaisa &&
          other.creditAmountPaisa == this.creditAmountPaisa &&
          other.runningBalancePaisa == this.runningBalancePaisa &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class CustomerLedgerEntriesCompanion
    extends UpdateCompanion<CustomerLedgerEntry> {
  final Value<int> id;
  final Value<int> customerId;
  final Value<int?> invoiceId;
  final Value<String> entryType;
  final Value<int> debitAmountPaisa;
  final Value<int> creditAmountPaisa;
  final Value<int> runningBalancePaisa;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const CustomerLedgerEntriesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.entryType = const Value.absent(),
    this.debitAmountPaisa = const Value.absent(),
    this.creditAmountPaisa = const Value.absent(),
    this.runningBalancePaisa = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomerLedgerEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int customerId,
    this.invoiceId = const Value.absent(),
    required String entryType,
    this.debitAmountPaisa = const Value.absent(),
    this.creditAmountPaisa = const Value.absent(),
    required int runningBalancePaisa,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : customerId = Value(customerId),
        entryType = Value(entryType),
        runningBalancePaisa = Value(runningBalancePaisa);
  static Insertable<CustomerLedgerEntry> custom({
    Expression<int>? id,
    Expression<int>? customerId,
    Expression<int>? invoiceId,
    Expression<String>? entryType,
    Expression<int>? debitAmountPaisa,
    Expression<int>? creditAmountPaisa,
    Expression<int>? runningBalancePaisa,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (entryType != null) 'entry_type': entryType,
      if (debitAmountPaisa != null) 'debit_amount_paisa': debitAmountPaisa,
      if (creditAmountPaisa != null) 'credit_amount_paisa': creditAmountPaisa,
      if (runningBalancePaisa != null)
        'running_balance_paisa': runningBalancePaisa,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomerLedgerEntriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? customerId,
      Value<int?>? invoiceId,
      Value<String>? entryType,
      Value<int>? debitAmountPaisa,
      Value<int>? creditAmountPaisa,
      Value<int>? runningBalancePaisa,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return CustomerLedgerEntriesCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      invoiceId: invoiceId ?? this.invoiceId,
      entryType: entryType ?? this.entryType,
      debitAmountPaisa: debitAmountPaisa ?? this.debitAmountPaisa,
      creditAmountPaisa: creditAmountPaisa ?? this.creditAmountPaisa,
      runningBalancePaisa: runningBalancePaisa ?? this.runningBalancePaisa,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (entryType.present) {
      map['entry_type'] = Variable<String>(entryType.value);
    }
    if (debitAmountPaisa.present) {
      map['debit_amount_paisa'] = Variable<int>(debitAmountPaisa.value);
    }
    if (creditAmountPaisa.present) {
      map['credit_amount_paisa'] = Variable<int>(creditAmountPaisa.value);
    }
    if (runningBalancePaisa.present) {
      map['running_balance_paisa'] = Variable<int>(runningBalancePaisa.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerLedgerEntriesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('entryType: $entryType, ')
          ..write('debitAmountPaisa: $debitAmountPaisa, ')
          ..write('creditAmountPaisa: $creditAmountPaisa, ')
          ..write('runningBalancePaisa: $runningBalancePaisa, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _billNumberMeta =
      const VerificationMeta('billNumber');
  @override
  late final GeneratedColumn<int> billNumber = GeneratedColumn<int>(
      'bill_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _saleTypeMeta =
      const VerificationMeta('saleType');
  @override
  late final GeneratedColumn<String> saleType = GeneratedColumn<String>(
      'sale_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _grossAmountPaisaMeta =
      const VerificationMeta('grossAmountPaisa');
  @override
  late final GeneratedColumn<int> grossAmountPaisa = GeneratedColumn<int>(
      'gross_amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountAmountPaisaMeta =
      const VerificationMeta('discountAmountPaisa');
  @override
  late final GeneratedColumn<int> discountAmountPaisa = GeneratedColumn<int>(
      'discount_amount_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _netAmountPaisaMeta =
      const VerificationMeta('netAmountPaisa');
  @override
  late final GeneratedColumn<int> netAmountPaisa = GeneratedColumn<int>(
      'net_amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidAmountPaisaMeta =
      const VerificationMeta('paidAmountPaisa');
  @override
  late final GeneratedColumn<int> paidAmountPaisa = GeneratedColumn<int>(
      'paid_amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _previousBalancePaisaMeta =
      const VerificationMeta('previousBalancePaisa');
  @override
  late final GeneratedColumn<int> previousBalancePaisa = GeneratedColumn<int>(
      'previous_balance_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _paymentStatusMeta =
      const VerificationMeta('paymentStatus');
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
      'payment_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        billNumber,
        customerId,
        saleType,
        grossAmountPaisa,
        discountAmountPaisa,
        netAmountPaisa,
        paidAmountPaisa,
        previousBalancePaisa,
        paymentStatus,
        createdBy,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(Insertable<Sale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bill_number')) {
      context.handle(
          _billNumberMeta,
          billNumber.isAcceptableOrUnknown(
              data['bill_number']!, _billNumberMeta));
    } else if (isInserting) {
      context.missing(_billNumberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('sale_type')) {
      context.handle(_saleTypeMeta,
          saleType.isAcceptableOrUnknown(data['sale_type']!, _saleTypeMeta));
    } else if (isInserting) {
      context.missing(_saleTypeMeta);
    }
    if (data.containsKey('gross_amount_paisa')) {
      context.handle(
          _grossAmountPaisaMeta,
          grossAmountPaisa.isAcceptableOrUnknown(
              data['gross_amount_paisa']!, _grossAmountPaisaMeta));
    } else if (isInserting) {
      context.missing(_grossAmountPaisaMeta);
    }
    if (data.containsKey('discount_amount_paisa')) {
      context.handle(
          _discountAmountPaisaMeta,
          discountAmountPaisa.isAcceptableOrUnknown(
              data['discount_amount_paisa']!, _discountAmountPaisaMeta));
    }
    if (data.containsKey('net_amount_paisa')) {
      context.handle(
          _netAmountPaisaMeta,
          netAmountPaisa.isAcceptableOrUnknown(
              data['net_amount_paisa']!, _netAmountPaisaMeta));
    } else if (isInserting) {
      context.missing(_netAmountPaisaMeta);
    }
    if (data.containsKey('paid_amount_paisa')) {
      context.handle(
          _paidAmountPaisaMeta,
          paidAmountPaisa.isAcceptableOrUnknown(
              data['paid_amount_paisa']!, _paidAmountPaisaMeta));
    } else if (isInserting) {
      context.missing(_paidAmountPaisaMeta);
    }
    if (data.containsKey('previous_balance_paisa')) {
      context.handle(
          _previousBalancePaisaMeta,
          previousBalancePaisa.isAcceptableOrUnknown(
              data['previous_balance_paisa']!, _previousBalancePaisaMeta));
    }
    if (data.containsKey('payment_status')) {
      context.handle(
          _paymentStatusMeta,
          paymentStatus.isAcceptableOrUnknown(
              data['payment_status']!, _paymentStatusMeta));
    } else if (isInserting) {
      context.missing(_paymentStatusMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      billNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bill_number'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id']),
      saleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_type'])!,
      grossAmountPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}gross_amount_paisa'])!,
      discountAmountPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}discount_amount_paisa'])!,
      netAmountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}net_amount_paisa'])!,
      paidAmountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid_amount_paisa'])!,
      previousBalancePaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}previous_balance_paisa'])!,
      paymentStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_status'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final int billNumber;
  final int? customerId;
  final String saleType;
  final int grossAmountPaisa;
  final int discountAmountPaisa;
  final int netAmountPaisa;
  final int paidAmountPaisa;
  final int previousBalancePaisa;
  final String paymentStatus;
  final int createdBy;
  final DateTime createdAt;
  const Sale(
      {required this.id,
      required this.billNumber,
      this.customerId,
      required this.saleType,
      required this.grossAmountPaisa,
      required this.discountAmountPaisa,
      required this.netAmountPaisa,
      required this.paidAmountPaisa,
      required this.previousBalancePaisa,
      required this.paymentStatus,
      required this.createdBy,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bill_number'] = Variable<int>(billNumber);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['sale_type'] = Variable<String>(saleType);
    map['gross_amount_paisa'] = Variable<int>(grossAmountPaisa);
    map['discount_amount_paisa'] = Variable<int>(discountAmountPaisa);
    map['net_amount_paisa'] = Variable<int>(netAmountPaisa);
    map['paid_amount_paisa'] = Variable<int>(paidAmountPaisa);
    map['previous_balance_paisa'] = Variable<int>(previousBalancePaisa);
    map['payment_status'] = Variable<String>(paymentStatus);
    map['created_by'] = Variable<int>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      billNumber: Value(billNumber),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      saleType: Value(saleType),
      grossAmountPaisa: Value(grossAmountPaisa),
      discountAmountPaisa: Value(discountAmountPaisa),
      netAmountPaisa: Value(netAmountPaisa),
      paidAmountPaisa: Value(paidAmountPaisa),
      previousBalancePaisa: Value(previousBalancePaisa),
      paymentStatus: Value(paymentStatus),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      billNumber: serializer.fromJson<int>(json['billNumber']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      saleType: serializer.fromJson<String>(json['saleType']),
      grossAmountPaisa: serializer.fromJson<int>(json['grossAmountPaisa']),
      discountAmountPaisa:
          serializer.fromJson<int>(json['discountAmountPaisa']),
      netAmountPaisa: serializer.fromJson<int>(json['netAmountPaisa']),
      paidAmountPaisa: serializer.fromJson<int>(json['paidAmountPaisa']),
      previousBalancePaisa:
          serializer.fromJson<int>(json['previousBalancePaisa']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      createdBy: serializer.fromJson<int>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'billNumber': serializer.toJson<int>(billNumber),
      'customerId': serializer.toJson<int?>(customerId),
      'saleType': serializer.toJson<String>(saleType),
      'grossAmountPaisa': serializer.toJson<int>(grossAmountPaisa),
      'discountAmountPaisa': serializer.toJson<int>(discountAmountPaisa),
      'netAmountPaisa': serializer.toJson<int>(netAmountPaisa),
      'paidAmountPaisa': serializer.toJson<int>(paidAmountPaisa),
      'previousBalancePaisa': serializer.toJson<int>(previousBalancePaisa),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'createdBy': serializer.toJson<int>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Sale copyWith(
          {int? id,
          int? billNumber,
          Value<int?> customerId = const Value.absent(),
          String? saleType,
          int? grossAmountPaisa,
          int? discountAmountPaisa,
          int? netAmountPaisa,
          int? paidAmountPaisa,
          int? previousBalancePaisa,
          String? paymentStatus,
          int? createdBy,
          DateTime? createdAt}) =>
      Sale(
        id: id ?? this.id,
        billNumber: billNumber ?? this.billNumber,
        customerId: customerId.present ? customerId.value : this.customerId,
        saleType: saleType ?? this.saleType,
        grossAmountPaisa: grossAmountPaisa ?? this.grossAmountPaisa,
        discountAmountPaisa: discountAmountPaisa ?? this.discountAmountPaisa,
        netAmountPaisa: netAmountPaisa ?? this.netAmountPaisa,
        paidAmountPaisa: paidAmountPaisa ?? this.paidAmountPaisa,
        previousBalancePaisa: previousBalancePaisa ?? this.previousBalancePaisa,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      billNumber:
          data.billNumber.present ? data.billNumber.value : this.billNumber,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      saleType: data.saleType.present ? data.saleType.value : this.saleType,
      grossAmountPaisa: data.grossAmountPaisa.present
          ? data.grossAmountPaisa.value
          : this.grossAmountPaisa,
      discountAmountPaisa: data.discountAmountPaisa.present
          ? data.discountAmountPaisa.value
          : this.discountAmountPaisa,
      netAmountPaisa: data.netAmountPaisa.present
          ? data.netAmountPaisa.value
          : this.netAmountPaisa,
      paidAmountPaisa: data.paidAmountPaisa.present
          ? data.paidAmountPaisa.value
          : this.paidAmountPaisa,
      previousBalancePaisa: data.previousBalancePaisa.present
          ? data.previousBalancePaisa.value
          : this.previousBalancePaisa,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('billNumber: $billNumber, ')
          ..write('customerId: $customerId, ')
          ..write('saleType: $saleType, ')
          ..write('grossAmountPaisa: $grossAmountPaisa, ')
          ..write('discountAmountPaisa: $discountAmountPaisa, ')
          ..write('netAmountPaisa: $netAmountPaisa, ')
          ..write('paidAmountPaisa: $paidAmountPaisa, ')
          ..write('previousBalancePaisa: $previousBalancePaisa, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      billNumber,
      customerId,
      saleType,
      grossAmountPaisa,
      discountAmountPaisa,
      netAmountPaisa,
      paidAmountPaisa,
      previousBalancePaisa,
      paymentStatus,
      createdBy,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.billNumber == this.billNumber &&
          other.customerId == this.customerId &&
          other.saleType == this.saleType &&
          other.grossAmountPaisa == this.grossAmountPaisa &&
          other.discountAmountPaisa == this.discountAmountPaisa &&
          other.netAmountPaisa == this.netAmountPaisa &&
          other.paidAmountPaisa == this.paidAmountPaisa &&
          other.previousBalancePaisa == this.previousBalancePaisa &&
          other.paymentStatus == this.paymentStatus &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<int> billNumber;
  final Value<int?> customerId;
  final Value<String> saleType;
  final Value<int> grossAmountPaisa;
  final Value<int> discountAmountPaisa;
  final Value<int> netAmountPaisa;
  final Value<int> paidAmountPaisa;
  final Value<int> previousBalancePaisa;
  final Value<String> paymentStatus;
  final Value<int> createdBy;
  final Value<DateTime> createdAt;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.billNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.saleType = const Value.absent(),
    this.grossAmountPaisa = const Value.absent(),
    this.discountAmountPaisa = const Value.absent(),
    this.netAmountPaisa = const Value.absent(),
    this.paidAmountPaisa = const Value.absent(),
    this.previousBalancePaisa = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required int billNumber,
    this.customerId = const Value.absent(),
    required String saleType,
    required int grossAmountPaisa,
    this.discountAmountPaisa = const Value.absent(),
    required int netAmountPaisa,
    required int paidAmountPaisa,
    this.previousBalancePaisa = const Value.absent(),
    required String paymentStatus,
    required int createdBy,
    this.createdAt = const Value.absent(),
  })  : billNumber = Value(billNumber),
        saleType = Value(saleType),
        grossAmountPaisa = Value(grossAmountPaisa),
        netAmountPaisa = Value(netAmountPaisa),
        paidAmountPaisa = Value(paidAmountPaisa),
        paymentStatus = Value(paymentStatus),
        createdBy = Value(createdBy);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<int>? billNumber,
    Expression<int>? customerId,
    Expression<String>? saleType,
    Expression<int>? grossAmountPaisa,
    Expression<int>? discountAmountPaisa,
    Expression<int>? netAmountPaisa,
    Expression<int>? paidAmountPaisa,
    Expression<int>? previousBalancePaisa,
    Expression<String>? paymentStatus,
    Expression<int>? createdBy,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billNumber != null) 'bill_number': billNumber,
      if (customerId != null) 'customer_id': customerId,
      if (saleType != null) 'sale_type': saleType,
      if (grossAmountPaisa != null) 'gross_amount_paisa': grossAmountPaisa,
      if (discountAmountPaisa != null)
        'discount_amount_paisa': discountAmountPaisa,
      if (netAmountPaisa != null) 'net_amount_paisa': netAmountPaisa,
      if (paidAmountPaisa != null) 'paid_amount_paisa': paidAmountPaisa,
      if (previousBalancePaisa != null)
        'previous_balance_paisa': previousBalancePaisa,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SalesCompanion copyWith(
      {Value<int>? id,
      Value<int>? billNumber,
      Value<int?>? customerId,
      Value<String>? saleType,
      Value<int>? grossAmountPaisa,
      Value<int>? discountAmountPaisa,
      Value<int>? netAmountPaisa,
      Value<int>? paidAmountPaisa,
      Value<int>? previousBalancePaisa,
      Value<String>? paymentStatus,
      Value<int>? createdBy,
      Value<DateTime>? createdAt}) {
    return SalesCompanion(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      customerId: customerId ?? this.customerId,
      saleType: saleType ?? this.saleType,
      grossAmountPaisa: grossAmountPaisa ?? this.grossAmountPaisa,
      discountAmountPaisa: discountAmountPaisa ?? this.discountAmountPaisa,
      netAmountPaisa: netAmountPaisa ?? this.netAmountPaisa,
      paidAmountPaisa: paidAmountPaisa ?? this.paidAmountPaisa,
      previousBalancePaisa: previousBalancePaisa ?? this.previousBalancePaisa,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (billNumber.present) {
      map['bill_number'] = Variable<int>(billNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (saleType.present) {
      map['sale_type'] = Variable<String>(saleType.value);
    }
    if (grossAmountPaisa.present) {
      map['gross_amount_paisa'] = Variable<int>(grossAmountPaisa.value);
    }
    if (discountAmountPaisa.present) {
      map['discount_amount_paisa'] = Variable<int>(discountAmountPaisa.value);
    }
    if (netAmountPaisa.present) {
      map['net_amount_paisa'] = Variable<int>(netAmountPaisa.value);
    }
    if (paidAmountPaisa.present) {
      map['paid_amount_paisa'] = Variable<int>(paidAmountPaisa.value);
    }
    if (previousBalancePaisa.present) {
      map['previous_balance_paisa'] = Variable<int>(previousBalancePaisa.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('billNumber: $billNumber, ')
          ..write('customerId: $customerId, ')
          ..write('saleType: $saleType, ')
          ..write('grossAmountPaisa: $grossAmountPaisa, ')
          ..write('discountAmountPaisa: $discountAmountPaisa, ')
          ..write('netAmountPaisa: $netAmountPaisa, ')
          ..write('paidAmountPaisa: $paidAmountPaisa, ')
          ..write('previousBalancePaisa: $previousBalancePaisa, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sales (id)'));
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
      'part_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES parts (id)'));
  static const VerificationMeta _unitRatePaisaMeta =
      const VerificationMeta('unitRatePaisa');
  @override
  late final GeneratedColumn<int> unitRatePaisa = GeneratedColumn<int>(
      'unit_rate_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
      'qty', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lineTotalPaisaMeta =
      const VerificationMeta('lineTotalPaisa');
  @override
  late final GeneratedColumn<int> lineTotalPaisa = GeneratedColumn<int>(
      'line_total_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, saleId, partId, unitRatePaisa, qty, lineTotalPaisa];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(Insertable<SaleItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(_partIdMeta,
          partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta));
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('unit_rate_paisa')) {
      context.handle(
          _unitRatePaisaMeta,
          unitRatePaisa.isAcceptableOrUnknown(
              data['unit_rate_paisa']!, _unitRatePaisaMeta));
    } else if (isInserting) {
      context.missing(_unitRatePaisaMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
          _qtyMeta, qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta));
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('line_total_paisa')) {
      context.handle(
          _lineTotalPaisaMeta,
          lineTotalPaisa.isAcceptableOrUnknown(
              data['line_total_paisa']!, _lineTotalPaisaMeta));
    } else if (isInserting) {
      context.missing(_lineTotalPaisaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_id'])!,
      partId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}part_id'])!,
      unitRatePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_rate_paisa'])!,
      qty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}qty'])!,
      lineTotalPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_total_paisa'])!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final int id;
  final int saleId;
  final int partId;
  final int unitRatePaisa;
  final int qty;
  final int lineTotalPaisa;
  const SaleItem(
      {required this.id,
      required this.saleId,
      required this.partId,
      required this.unitRatePaisa,
      required this.qty,
      required this.lineTotalPaisa});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['part_id'] = Variable<int>(partId);
    map['unit_rate_paisa'] = Variable<int>(unitRatePaisa);
    map['qty'] = Variable<int>(qty);
    map['line_total_paisa'] = Variable<int>(lineTotalPaisa);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      partId: Value(partId),
      unitRatePaisa: Value(unitRatePaisa),
      qty: Value(qty),
      lineTotalPaisa: Value(lineTotalPaisa),
    );
  }

  factory SaleItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      partId: serializer.fromJson<int>(json['partId']),
      unitRatePaisa: serializer.fromJson<int>(json['unitRatePaisa']),
      qty: serializer.fromJson<int>(json['qty']),
      lineTotalPaisa: serializer.fromJson<int>(json['lineTotalPaisa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'partId': serializer.toJson<int>(partId),
      'unitRatePaisa': serializer.toJson<int>(unitRatePaisa),
      'qty': serializer.toJson<int>(qty),
      'lineTotalPaisa': serializer.toJson<int>(lineTotalPaisa),
    };
  }

  SaleItem copyWith(
          {int? id,
          int? saleId,
          int? partId,
          int? unitRatePaisa,
          int? qty,
          int? lineTotalPaisa}) =>
      SaleItem(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        partId: partId ?? this.partId,
        unitRatePaisa: unitRatePaisa ?? this.unitRatePaisa,
        qty: qty ?? this.qty,
        lineTotalPaisa: lineTotalPaisa ?? this.lineTotalPaisa,
      );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      partId: data.partId.present ? data.partId.value : this.partId,
      unitRatePaisa: data.unitRatePaisa.present
          ? data.unitRatePaisa.value
          : this.unitRatePaisa,
      qty: data.qty.present ? data.qty.value : this.qty,
      lineTotalPaisa: data.lineTotalPaisa.present
          ? data.lineTotalPaisa.value
          : this.lineTotalPaisa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('partId: $partId, ')
          ..write('unitRatePaisa: $unitRatePaisa, ')
          ..write('qty: $qty, ')
          ..write('lineTotalPaisa: $lineTotalPaisa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleId, partId, unitRatePaisa, qty, lineTotalPaisa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.partId == this.partId &&
          other.unitRatePaisa == this.unitRatePaisa &&
          other.qty == this.qty &&
          other.lineTotalPaisa == this.lineTotalPaisa);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<int> partId;
  final Value<int> unitRatePaisa;
  final Value<int> qty;
  final Value<int> lineTotalPaisa;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.partId = const Value.absent(),
    this.unitRatePaisa = const Value.absent(),
    this.qty = const Value.absent(),
    this.lineTotalPaisa = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required int partId,
    required int unitRatePaisa,
    required int qty,
    required int lineTotalPaisa,
  })  : saleId = Value(saleId),
        partId = Value(partId),
        unitRatePaisa = Value(unitRatePaisa),
        qty = Value(qty),
        lineTotalPaisa = Value(lineTotalPaisa);
  static Insertable<SaleItem> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<int>? partId,
    Expression<int>? unitRatePaisa,
    Expression<int>? qty,
    Expression<int>? lineTotalPaisa,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (partId != null) 'part_id': partId,
      if (unitRatePaisa != null) 'unit_rate_paisa': unitRatePaisa,
      if (qty != null) 'qty': qty,
      if (lineTotalPaisa != null) 'line_total_paisa': lineTotalPaisa,
    });
  }

  SaleItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? saleId,
      Value<int>? partId,
      Value<int>? unitRatePaisa,
      Value<int>? qty,
      Value<int>? lineTotalPaisa}) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      partId: partId ?? this.partId,
      unitRatePaisa: unitRatePaisa ?? this.unitRatePaisa,
      qty: qty ?? this.qty,
      lineTotalPaisa: lineTotalPaisa ?? this.lineTotalPaisa,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (unitRatePaisa.present) {
      map['unit_rate_paisa'] = Variable<int>(unitRatePaisa.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (lineTotalPaisa.present) {
      map['line_total_paisa'] = Variable<int>(lineTotalPaisa.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('partId: $partId, ')
          ..write('unitRatePaisa: $unitRatePaisa, ')
          ..write('qty: $qty, ')
          ..write('lineTotalPaisa: $lineTotalPaisa')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPaisaMeta =
      const VerificationMeta('amountPaisa');
  @override
  late final GeneratedColumn<int> amountPaisa = GeneratedColumn<int>(
      'amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paymentModeMeta =
      const VerificationMeta('paymentMode');
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
      'payment_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CASH'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordedByMeta =
      const VerificationMeta('recordedBy');
  @override
  late final GeneratedColumn<int> recordedBy = GeneratedColumn<int>(
      'recorded_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _expenseDateMeta =
      const VerificationMeta('expenseDate');
  @override
  late final GeneratedColumn<DateTime> expenseDate = GeneratedColumn<DateTime>(
      'expense_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        category,
        amountPaisa,
        paymentMode,
        description,
        recordedBy,
        expenseDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount_paisa')) {
      context.handle(
          _amountPaisaMeta,
          amountPaisa.isAcceptableOrUnknown(
              data['amount_paisa']!, _amountPaisaMeta));
    } else if (isInserting) {
      context.missing(_amountPaisaMeta);
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
          _paymentModeMeta,
          paymentMode.isAcceptableOrUnknown(
              data['payment_mode']!, _paymentModeMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
          _recordedByMeta,
          recordedBy.isAcceptableOrUnknown(
              data['recorded_by']!, _recordedByMeta));
    } else if (isInserting) {
      context.missing(_recordedByMeta);
    }
    if (data.containsKey('expense_date')) {
      context.handle(
          _expenseDateMeta,
          expenseDate.isAcceptableOrUnknown(
              data['expense_date']!, _expenseDateMeta));
    } else if (isInserting) {
      context.missing(_expenseDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      amountPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paisa'])!,
      paymentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_mode'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      recordedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recorded_by'])!,
      expenseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expense_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String category;
  final int amountPaisa;
  final String paymentMode;
  final String? description;
  final int recordedBy;
  final DateTime expenseDate;
  final DateTime createdAt;
  const Expense(
      {required this.id,
      required this.category,
      required this.amountPaisa,
      required this.paymentMode,
      this.description,
      required this.recordedBy,
      required this.expenseDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['amount_paisa'] = Variable<int>(amountPaisa);
    map['payment_mode'] = Variable<String>(paymentMode);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['recorded_by'] = Variable<int>(recordedBy);
    map['expense_date'] = Variable<DateTime>(expenseDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      category: Value(category),
      amountPaisa: Value(amountPaisa),
      paymentMode: Value(paymentMode),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      recordedBy: Value(recordedBy),
      expenseDate: Value(expenseDate),
      createdAt: Value(createdAt),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      amountPaisa: serializer.fromJson<int>(json['amountPaisa']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      description: serializer.fromJson<String?>(json['description']),
      recordedBy: serializer.fromJson<int>(json['recordedBy']),
      expenseDate: serializer.fromJson<DateTime>(json['expenseDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'amountPaisa': serializer.toJson<int>(amountPaisa),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'description': serializer.toJson<String?>(description),
      'recordedBy': serializer.toJson<int>(recordedBy),
      'expenseDate': serializer.toJson<DateTime>(expenseDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Expense copyWith(
          {int? id,
          String? category,
          int? amountPaisa,
          String? paymentMode,
          Value<String?> description = const Value.absent(),
          int? recordedBy,
          DateTime? expenseDate,
          DateTime? createdAt}) =>
      Expense(
        id: id ?? this.id,
        category: category ?? this.category,
        amountPaisa: amountPaisa ?? this.amountPaisa,
        paymentMode: paymentMode ?? this.paymentMode,
        description: description.present ? description.value : this.description,
        recordedBy: recordedBy ?? this.recordedBy,
        expenseDate: expenseDate ?? this.expenseDate,
        createdAt: createdAt ?? this.createdAt,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      amountPaisa:
          data.amountPaisa.present ? data.amountPaisa.value : this.amountPaisa,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      description:
          data.description.present ? data.description.value : this.description,
      recordedBy:
          data.recordedBy.present ? data.recordedBy.value : this.recordedBy,
      expenseDate:
          data.expenseDate.present ? data.expenseDate.value : this.expenseDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('description: $description, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, amountPaisa, paymentMode,
      description, recordedBy, expenseDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.category == this.category &&
          other.amountPaisa == this.amountPaisa &&
          other.paymentMode == this.paymentMode &&
          other.description == this.description &&
          other.recordedBy == this.recordedBy &&
          other.expenseDate == this.expenseDate &&
          other.createdAt == this.createdAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String> category;
  final Value<int> amountPaisa;
  final Value<String> paymentMode;
  final Value<String?> description;
  final Value<int> recordedBy;
  final Value<DateTime> expenseDate;
  final Value<DateTime> createdAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.amountPaisa = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.description = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.expenseDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required int amountPaisa,
    this.paymentMode = const Value.absent(),
    this.description = const Value.absent(),
    required int recordedBy,
    required DateTime expenseDate,
    this.createdAt = const Value.absent(),
  })  : category = Value(category),
        amountPaisa = Value(amountPaisa),
        recordedBy = Value(recordedBy),
        expenseDate = Value(expenseDate);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<int>? amountPaisa,
    Expression<String>? paymentMode,
    Expression<String>? description,
    Expression<int>? recordedBy,
    Expression<DateTime>? expenseDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (amountPaisa != null) 'amount_paisa': amountPaisa,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (description != null) 'description': description,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (expenseDate != null) 'expense_date': expenseDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<String>? category,
      Value<int>? amountPaisa,
      Value<String>? paymentMode,
      Value<String?>? description,
      Value<int>? recordedBy,
      Value<DateTime>? expenseDate,
      Value<DateTime>? createdAt}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      amountPaisa: amountPaisa ?? this.amountPaisa,
      paymentMode: paymentMode ?? this.paymentMode,
      description: description ?? this.description,
      recordedBy: recordedBy ?? this.recordedBy,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amountPaisa.present) {
      map['amount_paisa'] = Variable<int>(amountPaisa.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<int>(recordedBy.value);
    }
    if (expenseDate.present) {
      map['expense_date'] = Variable<DateTime>(expenseDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('amountPaisa: $amountPaisa, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('description: $description, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('expenseDate: $expenseDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RoutesTable extends Routes with TableInfo<$RoutesTable, Route> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Kot Samba'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, city, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routes';
  @override
  VerificationContext validateIntegrity(Insertable<Route> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Route map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Route(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RoutesTable createAlias(String alias) {
    return $RoutesTable(attachedDatabase, alias);
  }
}

class Route extends DataClass implements Insertable<Route> {
  final int id;
  final String name;
  final String city;
  final String? description;
  final DateTime createdAt;
  const Route(
      {required this.id,
      required this.name,
      required this.city,
      this.description,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['city'] = Variable<String>(city);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RoutesCompanion toCompanion(bool nullToAbsent) {
    return RoutesCompanion(
      id: Value(id),
      name: Value(name),
      city: Value(city),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory Route.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Route(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      city: serializer.fromJson<String>(json['city']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'city': serializer.toJson<String>(city),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Route copyWith(
          {int? id,
          String? name,
          String? city,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt}) =>
      Route(
        id: id ?? this.id,
        name: name ?? this.name,
        city: city ?? this.city,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
      );
  Route copyWithCompanion(RoutesCompanion data) {
    return Route(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      city: data.city.present ? data.city.value : this.city,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Route(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('city: $city, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, city, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Route &&
          other.id == this.id &&
          other.name == this.name &&
          other.city == this.city &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class RoutesCompanion extends UpdateCompanion<Route> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> city;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  const RoutesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.city = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RoutesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.city = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Route> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? city,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (city != null) 'city': city,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RoutesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? city,
      Value<String?>? description,
      Value<DateTime>? createdAt}) {
    return RoutesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('city: $city, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assignedRouteIdMeta =
      const VerificationMeta('assignedRouteId');
  @override
  late final GeneratedColumn<int> assignedRouteId = GeneratedColumn<int>(
      'assigned_route_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES routes (id)'));
  static const VerificationMeta _monthlySalaryPaisaMeta =
      const VerificationMeta('monthlySalaryPaisa');
  @override
  late final GeneratedColumn<int> monthlySalaryPaisa = GeneratedColumn<int>(
      'monthly_salary_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        role,
        assignedRouteId,
        monthlySalaryPaisa,
        isActive,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(Insertable<Employee> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('assigned_route_id')) {
      context.handle(
          _assignedRouteIdMeta,
          assignedRouteId.isAcceptableOrUnknown(
              data['assigned_route_id']!, _assignedRouteIdMeta));
    }
    if (data.containsKey('monthly_salary_paisa')) {
      context.handle(
          _monthlySalaryPaisaMeta,
          monthlySalaryPaisa.isAcceptableOrUnknown(
              data['monthly_salary_paisa']!, _monthlySalaryPaisaMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      assignedRouteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}assigned_route_id']),
      monthlySalaryPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}monthly_salary_paisa'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final int id;
  final String name;
  final String? phone;
  final String role;
  final int? assignedRouteId;
  final int monthlySalaryPaisa;
  final bool isActive;
  final DateTime createdAt;
  const Employee(
      {required this.id,
      required this.name,
      this.phone,
      required this.role,
      this.assignedRouteId,
      required this.monthlySalaryPaisa,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || assignedRouteId != null) {
      map['assigned_route_id'] = Variable<int>(assignedRouteId);
    }
    map['monthly_salary_paisa'] = Variable<int>(monthlySalaryPaisa);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      role: Value(role),
      assignedRouteId: assignedRouteId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedRouteId),
      monthlySalaryPaisa: Value(monthlySalaryPaisa),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Employee.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      role: serializer.fromJson<String>(json['role']),
      assignedRouteId: serializer.fromJson<int?>(json['assignedRouteId']),
      monthlySalaryPaisa: serializer.fromJson<int>(json['monthlySalaryPaisa']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'role': serializer.toJson<String>(role),
      'assignedRouteId': serializer.toJson<int?>(assignedRouteId),
      'monthlySalaryPaisa': serializer.toJson<int>(monthlySalaryPaisa),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Employee copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          String? role,
          Value<int?> assignedRouteId = const Value.absent(),
          int? monthlySalaryPaisa,
          bool? isActive,
          DateTime? createdAt}) =>
      Employee(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        role: role ?? this.role,
        assignedRouteId: assignedRouteId.present
            ? assignedRouteId.value
            : this.assignedRouteId,
        monthlySalaryPaisa: monthlySalaryPaisa ?? this.monthlySalaryPaisa,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      role: data.role.present ? data.role.value : this.role,
      assignedRouteId: data.assignedRouteId.present
          ? data.assignedRouteId.value
          : this.assignedRouteId,
      monthlySalaryPaisa: data.monthlySalaryPaisa.present
          ? data.monthlySalaryPaisa.value
          : this.monthlySalaryPaisa,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('role: $role, ')
          ..write('assignedRouteId: $assignedRouteId, ')
          ..write('monthlySalaryPaisa: $monthlySalaryPaisa, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, role, assignedRouteId,
      monthlySalaryPaisa, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.role == this.role &&
          other.assignedRouteId == this.assignedRouteId &&
          other.monthlySalaryPaisa == this.monthlySalaryPaisa &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String> role;
  final Value<int?> assignedRouteId;
  final Value<int> monthlySalaryPaisa;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.role = const Value.absent(),
    this.assignedRouteId = const Value.absent(),
    this.monthlySalaryPaisa = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EmployeesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    required String role,
    this.assignedRouteId = const Value.absent(),
    this.monthlySalaryPaisa = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        role = Value(role);
  static Insertable<Employee> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? role,
    Expression<int>? assignedRouteId,
    Expression<int>? monthlySalaryPaisa,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (role != null) 'role': role,
      if (assignedRouteId != null) 'assigned_route_id': assignedRouteId,
      if (monthlySalaryPaisa != null)
        'monthly_salary_paisa': monthlySalaryPaisa,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EmployeesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String>? role,
      Value<int?>? assignedRouteId,
      Value<int>? monthlySalaryPaisa,
      Value<bool>? isActive,
      Value<DateTime>? createdAt}) {
    return EmployeesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      assignedRouteId: assignedRouteId ?? this.assignedRouteId,
      monthlySalaryPaisa: monthlySalaryPaisa ?? this.monthlySalaryPaisa,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (assignedRouteId.present) {
      map['assigned_route_id'] = Variable<int>(assignedRouteId.value);
    }
    if (monthlySalaryPaisa.present) {
      map['monthly_salary_paisa'] = Variable<int>(monthlySalaryPaisa.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('role: $role, ')
          ..write('assignedRouteId: $assignedRouteId, ')
          ..write('monthlySalaryPaisa: $monthlySalaryPaisa, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ReturnClaimsTable extends ReturnClaims
    with TableInfo<$ReturnClaimsTable, ReturnClaim> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnClaimsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sales (id)'));
  static const VerificationMeta _requestedByMeta =
      const VerificationMeta('requestedBy');
  @override
  late final GeneratedColumn<int> requestedBy = GeneratedColumn<int>(
      'requested_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _approvedByMeta =
      const VerificationMeta('approvedBy');
  @override
  late final GeneratedColumn<int> approvedBy = GeneratedColumn<int>(
      'approved_by', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _claimStatusMeta =
      const VerificationMeta('claimStatus');
  @override
  late final GeneratedColumn<String> claimStatus = GeneratedColumn<String>(
      'claim_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _totalRefundAmountPaisaMeta =
      const VerificationMeta('totalRefundAmountPaisa');
  @override
  late final GeneratedColumn<int> totalRefundAmountPaisa = GeneratedColumn<int>(
      'total_refund_amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rejectionReasonMeta =
      const VerificationMeta('rejectionReason');
  @override
  late final GeneratedColumn<String> rejectionReason = GeneratedColumn<String>(
      'rejection_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        saleId,
        requestedBy,
        approvedBy,
        claimStatus,
        totalRefundAmountPaisa,
        rejectionReason,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'return_claims';
  @override
  VerificationContext validateIntegrity(Insertable<ReturnClaim> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('requested_by')) {
      context.handle(
          _requestedByMeta,
          requestedBy.isAcceptableOrUnknown(
              data['requested_by']!, _requestedByMeta));
    } else if (isInserting) {
      context.missing(_requestedByMeta);
    }
    if (data.containsKey('approved_by')) {
      context.handle(
          _approvedByMeta,
          approvedBy.isAcceptableOrUnknown(
              data['approved_by']!, _approvedByMeta));
    }
    if (data.containsKey('claim_status')) {
      context.handle(
          _claimStatusMeta,
          claimStatus.isAcceptableOrUnknown(
              data['claim_status']!, _claimStatusMeta));
    }
    if (data.containsKey('total_refund_amount_paisa')) {
      context.handle(
          _totalRefundAmountPaisaMeta,
          totalRefundAmountPaisa.isAcceptableOrUnknown(
              data['total_refund_amount_paisa']!, _totalRefundAmountPaisaMeta));
    } else if (isInserting) {
      context.missing(_totalRefundAmountPaisaMeta);
    }
    if (data.containsKey('rejection_reason')) {
      context.handle(
          _rejectionReasonMeta,
          rejectionReason.isAcceptableOrUnknown(
              data['rejection_reason']!, _rejectionReasonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnClaim map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnClaim(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_id'])!,
      requestedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}requested_by'])!,
      approvedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}approved_by']),
      claimStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}claim_status'])!,
      totalRefundAmountPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}total_refund_amount_paisa'])!,
      rejectionReason: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}rejection_reason']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ReturnClaimsTable createAlias(String alias) {
    return $ReturnClaimsTable(attachedDatabase, alias);
  }
}

class ReturnClaim extends DataClass implements Insertable<ReturnClaim> {
  final int id;
  final int saleId;
  final int requestedBy;
  final int? approvedBy;
  final String claimStatus;
  final int totalRefundAmountPaisa;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ReturnClaim(
      {required this.id,
      required this.saleId,
      required this.requestedBy,
      this.approvedBy,
      required this.claimStatus,
      required this.totalRefundAmountPaisa,
      this.rejectionReason,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['requested_by'] = Variable<int>(requestedBy);
    if (!nullToAbsent || approvedBy != null) {
      map['approved_by'] = Variable<int>(approvedBy);
    }
    map['claim_status'] = Variable<String>(claimStatus);
    map['total_refund_amount_paisa'] = Variable<int>(totalRefundAmountPaisa);
    if (!nullToAbsent || rejectionReason != null) {
      map['rejection_reason'] = Variable<String>(rejectionReason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReturnClaimsCompanion toCompanion(bool nullToAbsent) {
    return ReturnClaimsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      requestedBy: Value(requestedBy),
      approvedBy: approvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedBy),
      claimStatus: Value(claimStatus),
      totalRefundAmountPaisa: Value(totalRefundAmountPaisa),
      rejectionReason: rejectionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionReason),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReturnClaim.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnClaim(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      requestedBy: serializer.fromJson<int>(json['requestedBy']),
      approvedBy: serializer.fromJson<int?>(json['approvedBy']),
      claimStatus: serializer.fromJson<String>(json['claimStatus']),
      totalRefundAmountPaisa:
          serializer.fromJson<int>(json['totalRefundAmountPaisa']),
      rejectionReason: serializer.fromJson<String?>(json['rejectionReason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'requestedBy': serializer.toJson<int>(requestedBy),
      'approvedBy': serializer.toJson<int?>(approvedBy),
      'claimStatus': serializer.toJson<String>(claimStatus),
      'totalRefundAmountPaisa': serializer.toJson<int>(totalRefundAmountPaisa),
      'rejectionReason': serializer.toJson<String?>(rejectionReason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReturnClaim copyWith(
          {int? id,
          int? saleId,
          int? requestedBy,
          Value<int?> approvedBy = const Value.absent(),
          String? claimStatus,
          int? totalRefundAmountPaisa,
          Value<String?> rejectionReason = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ReturnClaim(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        requestedBy: requestedBy ?? this.requestedBy,
        approvedBy: approvedBy.present ? approvedBy.value : this.approvedBy,
        claimStatus: claimStatus ?? this.claimStatus,
        totalRefundAmountPaisa:
            totalRefundAmountPaisa ?? this.totalRefundAmountPaisa,
        rejectionReason: rejectionReason.present
            ? rejectionReason.value
            : this.rejectionReason,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ReturnClaim copyWithCompanion(ReturnClaimsCompanion data) {
    return ReturnClaim(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      requestedBy:
          data.requestedBy.present ? data.requestedBy.value : this.requestedBy,
      approvedBy:
          data.approvedBy.present ? data.approvedBy.value : this.approvedBy,
      claimStatus:
          data.claimStatus.present ? data.claimStatus.value : this.claimStatus,
      totalRefundAmountPaisa: data.totalRefundAmountPaisa.present
          ? data.totalRefundAmountPaisa.value
          : this.totalRefundAmountPaisa,
      rejectionReason: data.rejectionReason.present
          ? data.rejectionReason.value
          : this.rejectionReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReturnClaim(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('requestedBy: $requestedBy, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('claimStatus: $claimStatus, ')
          ..write('totalRefundAmountPaisa: $totalRefundAmountPaisa, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      saleId,
      requestedBy,
      approvedBy,
      claimStatus,
      totalRefundAmountPaisa,
      rejectionReason,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnClaim &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.requestedBy == this.requestedBy &&
          other.approvedBy == this.approvedBy &&
          other.claimStatus == this.claimStatus &&
          other.totalRefundAmountPaisa == this.totalRefundAmountPaisa &&
          other.rejectionReason == this.rejectionReason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReturnClaimsCompanion extends UpdateCompanion<ReturnClaim> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<int> requestedBy;
  final Value<int?> approvedBy;
  final Value<String> claimStatus;
  final Value<int> totalRefundAmountPaisa;
  final Value<String?> rejectionReason;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ReturnClaimsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.requestedBy = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.claimStatus = const Value.absent(),
    this.totalRefundAmountPaisa = const Value.absent(),
    this.rejectionReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReturnClaimsCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required int requestedBy,
    this.approvedBy = const Value.absent(),
    this.claimStatus = const Value.absent(),
    required int totalRefundAmountPaisa,
    this.rejectionReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : saleId = Value(saleId),
        requestedBy = Value(requestedBy),
        totalRefundAmountPaisa = Value(totalRefundAmountPaisa);
  static Insertable<ReturnClaim> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<int>? requestedBy,
    Expression<int>? approvedBy,
    Expression<String>? claimStatus,
    Expression<int>? totalRefundAmountPaisa,
    Expression<String>? rejectionReason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (requestedBy != null) 'requested_by': requestedBy,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (claimStatus != null) 'claim_status': claimStatus,
      if (totalRefundAmountPaisa != null)
        'total_refund_amount_paisa': totalRefundAmountPaisa,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReturnClaimsCompanion copyWith(
      {Value<int>? id,
      Value<int>? saleId,
      Value<int>? requestedBy,
      Value<int?>? approvedBy,
      Value<String>? claimStatus,
      Value<int>? totalRefundAmountPaisa,
      Value<String?>? rejectionReason,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ReturnClaimsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      requestedBy: requestedBy ?? this.requestedBy,
      approvedBy: approvedBy ?? this.approvedBy,
      claimStatus: claimStatus ?? this.claimStatus,
      totalRefundAmountPaisa:
          totalRefundAmountPaisa ?? this.totalRefundAmountPaisa,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (requestedBy.present) {
      map['requested_by'] = Variable<int>(requestedBy.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<int>(approvedBy.value);
    }
    if (claimStatus.present) {
      map['claim_status'] = Variable<String>(claimStatus.value);
    }
    if (totalRefundAmountPaisa.present) {
      map['total_refund_amount_paisa'] =
          Variable<int>(totalRefundAmountPaisa.value);
    }
    if (rejectionReason.present) {
      map['rejection_reason'] = Variable<String>(rejectionReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnClaimsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('requestedBy: $requestedBy, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('claimStatus: $claimStatus, ')
          ..write('totalRefundAmountPaisa: $totalRefundAmountPaisa, ')
          ..write('rejectionReason: $rejectionReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReturnClaimItemsTable extends ReturnClaimItems
    with TableInfo<$ReturnClaimItemsTable, ReturnClaimItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnClaimItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _claimIdMeta =
      const VerificationMeta('claimId');
  @override
  late final GeneratedColumn<int> claimId = GeneratedColumn<int>(
      'claim_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES return_claims (id)'));
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
      'part_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES parts (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _refundRatePaisaMeta =
      const VerificationMeta('refundRatePaisa');
  @override
  late final GeneratedColumn<int> refundRatePaisa = GeneratedColumn<int>(
      'refund_rate_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lineRefundTotalPaisaMeta =
      const VerificationMeta('lineRefundTotalPaisa');
  @override
  late final GeneratedColumn<int> lineRefundTotalPaisa = GeneratedColumn<int>(
      'line_refund_total_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _inventoryDispositionMeta =
      const VerificationMeta('inventoryDisposition');
  @override
  late final GeneratedColumn<String> inventoryDisposition =
      GeneratedColumn<String>('inventory_disposition', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('SELLABLE'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        claimId,
        partId,
        quantity,
        refundRatePaisa,
        lineRefundTotalPaisa,
        inventoryDisposition
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'return_claim_items';
  @override
  VerificationContext validateIntegrity(Insertable<ReturnClaimItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('claim_id')) {
      context.handle(_claimIdMeta,
          claimId.isAcceptableOrUnknown(data['claim_id']!, _claimIdMeta));
    } else if (isInserting) {
      context.missing(_claimIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(_partIdMeta,
          partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta));
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('refund_rate_paisa')) {
      context.handle(
          _refundRatePaisaMeta,
          refundRatePaisa.isAcceptableOrUnknown(
              data['refund_rate_paisa']!, _refundRatePaisaMeta));
    } else if (isInserting) {
      context.missing(_refundRatePaisaMeta);
    }
    if (data.containsKey('line_refund_total_paisa')) {
      context.handle(
          _lineRefundTotalPaisaMeta,
          lineRefundTotalPaisa.isAcceptableOrUnknown(
              data['line_refund_total_paisa']!, _lineRefundTotalPaisaMeta));
    } else if (isInserting) {
      context.missing(_lineRefundTotalPaisaMeta);
    }
    if (data.containsKey('inventory_disposition')) {
      context.handle(
          _inventoryDispositionMeta,
          inventoryDisposition.isAcceptableOrUnknown(
              data['inventory_disposition']!, _inventoryDispositionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnClaimItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnClaimItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      claimId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}claim_id'])!,
      partId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}part_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      refundRatePaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}refund_rate_paisa'])!,
      lineRefundTotalPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}line_refund_total_paisa'])!,
      inventoryDisposition: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}inventory_disposition'])!,
    );
  }

  @override
  $ReturnClaimItemsTable createAlias(String alias) {
    return $ReturnClaimItemsTable(attachedDatabase, alias);
  }
}

class ReturnClaimItem extends DataClass implements Insertable<ReturnClaimItem> {
  final int id;
  final int claimId;
  final int partId;
  final int quantity;
  final int refundRatePaisa;
  final int lineRefundTotalPaisa;
  final String inventoryDisposition;
  const ReturnClaimItem(
      {required this.id,
      required this.claimId,
      required this.partId,
      required this.quantity,
      required this.refundRatePaisa,
      required this.lineRefundTotalPaisa,
      required this.inventoryDisposition});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['claim_id'] = Variable<int>(claimId);
    map['part_id'] = Variable<int>(partId);
    map['quantity'] = Variable<int>(quantity);
    map['refund_rate_paisa'] = Variable<int>(refundRatePaisa);
    map['line_refund_total_paisa'] = Variable<int>(lineRefundTotalPaisa);
    map['inventory_disposition'] = Variable<String>(inventoryDisposition);
    return map;
  }

  ReturnClaimItemsCompanion toCompanion(bool nullToAbsent) {
    return ReturnClaimItemsCompanion(
      id: Value(id),
      claimId: Value(claimId),
      partId: Value(partId),
      quantity: Value(quantity),
      refundRatePaisa: Value(refundRatePaisa),
      lineRefundTotalPaisa: Value(lineRefundTotalPaisa),
      inventoryDisposition: Value(inventoryDisposition),
    );
  }

  factory ReturnClaimItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnClaimItem(
      id: serializer.fromJson<int>(json['id']),
      claimId: serializer.fromJson<int>(json['claimId']),
      partId: serializer.fromJson<int>(json['partId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      refundRatePaisa: serializer.fromJson<int>(json['refundRatePaisa']),
      lineRefundTotalPaisa:
          serializer.fromJson<int>(json['lineRefundTotalPaisa']),
      inventoryDisposition:
          serializer.fromJson<String>(json['inventoryDisposition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'claimId': serializer.toJson<int>(claimId),
      'partId': serializer.toJson<int>(partId),
      'quantity': serializer.toJson<int>(quantity),
      'refundRatePaisa': serializer.toJson<int>(refundRatePaisa),
      'lineRefundTotalPaisa': serializer.toJson<int>(lineRefundTotalPaisa),
      'inventoryDisposition': serializer.toJson<String>(inventoryDisposition),
    };
  }

  ReturnClaimItem copyWith(
          {int? id,
          int? claimId,
          int? partId,
          int? quantity,
          int? refundRatePaisa,
          int? lineRefundTotalPaisa,
          String? inventoryDisposition}) =>
      ReturnClaimItem(
        id: id ?? this.id,
        claimId: claimId ?? this.claimId,
        partId: partId ?? this.partId,
        quantity: quantity ?? this.quantity,
        refundRatePaisa: refundRatePaisa ?? this.refundRatePaisa,
        lineRefundTotalPaisa: lineRefundTotalPaisa ?? this.lineRefundTotalPaisa,
        inventoryDisposition: inventoryDisposition ?? this.inventoryDisposition,
      );
  ReturnClaimItem copyWithCompanion(ReturnClaimItemsCompanion data) {
    return ReturnClaimItem(
      id: data.id.present ? data.id.value : this.id,
      claimId: data.claimId.present ? data.claimId.value : this.claimId,
      partId: data.partId.present ? data.partId.value : this.partId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      refundRatePaisa: data.refundRatePaisa.present
          ? data.refundRatePaisa.value
          : this.refundRatePaisa,
      lineRefundTotalPaisa: data.lineRefundTotalPaisa.present
          ? data.lineRefundTotalPaisa.value
          : this.lineRefundTotalPaisa,
      inventoryDisposition: data.inventoryDisposition.present
          ? data.inventoryDisposition.value
          : this.inventoryDisposition,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReturnClaimItem(')
          ..write('id: $id, ')
          ..write('claimId: $claimId, ')
          ..write('partId: $partId, ')
          ..write('quantity: $quantity, ')
          ..write('refundRatePaisa: $refundRatePaisa, ')
          ..write('lineRefundTotalPaisa: $lineRefundTotalPaisa, ')
          ..write('inventoryDisposition: $inventoryDisposition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, claimId, partId, quantity,
      refundRatePaisa, lineRefundTotalPaisa, inventoryDisposition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnClaimItem &&
          other.id == this.id &&
          other.claimId == this.claimId &&
          other.partId == this.partId &&
          other.quantity == this.quantity &&
          other.refundRatePaisa == this.refundRatePaisa &&
          other.lineRefundTotalPaisa == this.lineRefundTotalPaisa &&
          other.inventoryDisposition == this.inventoryDisposition);
}

class ReturnClaimItemsCompanion extends UpdateCompanion<ReturnClaimItem> {
  final Value<int> id;
  final Value<int> claimId;
  final Value<int> partId;
  final Value<int> quantity;
  final Value<int> refundRatePaisa;
  final Value<int> lineRefundTotalPaisa;
  final Value<String> inventoryDisposition;
  const ReturnClaimItemsCompanion({
    this.id = const Value.absent(),
    this.claimId = const Value.absent(),
    this.partId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.refundRatePaisa = const Value.absent(),
    this.lineRefundTotalPaisa = const Value.absent(),
    this.inventoryDisposition = const Value.absent(),
  });
  ReturnClaimItemsCompanion.insert({
    this.id = const Value.absent(),
    required int claimId,
    required int partId,
    required int quantity,
    required int refundRatePaisa,
    required int lineRefundTotalPaisa,
    this.inventoryDisposition = const Value.absent(),
  })  : claimId = Value(claimId),
        partId = Value(partId),
        quantity = Value(quantity),
        refundRatePaisa = Value(refundRatePaisa),
        lineRefundTotalPaisa = Value(lineRefundTotalPaisa);
  static Insertable<ReturnClaimItem> custom({
    Expression<int>? id,
    Expression<int>? claimId,
    Expression<int>? partId,
    Expression<int>? quantity,
    Expression<int>? refundRatePaisa,
    Expression<int>? lineRefundTotalPaisa,
    Expression<String>? inventoryDisposition,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (claimId != null) 'claim_id': claimId,
      if (partId != null) 'part_id': partId,
      if (quantity != null) 'quantity': quantity,
      if (refundRatePaisa != null) 'refund_rate_paisa': refundRatePaisa,
      if (lineRefundTotalPaisa != null)
        'line_refund_total_paisa': lineRefundTotalPaisa,
      if (inventoryDisposition != null)
        'inventory_disposition': inventoryDisposition,
    });
  }

  ReturnClaimItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? claimId,
      Value<int>? partId,
      Value<int>? quantity,
      Value<int>? refundRatePaisa,
      Value<int>? lineRefundTotalPaisa,
      Value<String>? inventoryDisposition}) {
    return ReturnClaimItemsCompanion(
      id: id ?? this.id,
      claimId: claimId ?? this.claimId,
      partId: partId ?? this.partId,
      quantity: quantity ?? this.quantity,
      refundRatePaisa: refundRatePaisa ?? this.refundRatePaisa,
      lineRefundTotalPaisa: lineRefundTotalPaisa ?? this.lineRefundTotalPaisa,
      inventoryDisposition: inventoryDisposition ?? this.inventoryDisposition,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (claimId.present) {
      map['claim_id'] = Variable<int>(claimId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (refundRatePaisa.present) {
      map['refund_rate_paisa'] = Variable<int>(refundRatePaisa.value);
    }
    if (lineRefundTotalPaisa.present) {
      map['line_refund_total_paisa'] =
          Variable<int>(lineRefundTotalPaisa.value);
    }
    if (inventoryDisposition.present) {
      map['inventory_disposition'] =
          Variable<String>(inventoryDisposition.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnClaimItemsCompanion(')
          ..write('id: $id, ')
          ..write('claimId: $claimId, ')
          ..write('partId: $partId, ')
          ..write('quantity: $quantity, ')
          ..write('refundRatePaisa: $refundRatePaisa, ')
          ..write('lineRefundTotalPaisa: $lineRefundTotalPaisa, ')
          ..write('inventoryDisposition: $inventoryDisposition')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _companyMeta =
      const VerificationMeta('company');
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
      'company', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentBalancePaisaMeta =
      const VerificationMeta('currentBalancePaisa');
  @override
  late final GeneratedColumn<int> currentBalancePaisa = GeneratedColumn<int>(
      'current_balance_paisa', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, phone, company, currentBalancePaisa];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<Supplier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('company')) {
      context.handle(_companyMeta,
          company.isAcceptableOrUnknown(data['company']!, _companyMeta));
    }
    if (data.containsKey('current_balance_paisa')) {
      context.handle(
          _currentBalancePaisaMeta,
          currentBalancePaisa.isAcceptableOrUnknown(
              data['current_balance_paisa']!, _currentBalancePaisaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      company: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}company']),
      currentBalancePaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}current_balance_paisa'])!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String name;
  final String? phone;
  final String? company;
  final int currentBalancePaisa;
  const Supplier(
      {required this.id,
      required this.name,
      this.phone,
      this.company,
      required this.currentBalancePaisa});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    map['current_balance_paisa'] = Variable<int>(currentBalancePaisa);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
      currentBalancePaisa: Value(currentBalancePaisa),
    );
  }

  factory Supplier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      company: serializer.fromJson<String?>(json['company']),
      currentBalancePaisa:
          serializer.fromJson<int>(json['currentBalancePaisa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'company': serializer.toJson<String?>(company),
      'currentBalancePaisa': serializer.toJson<int>(currentBalancePaisa),
    };
  }

  Supplier copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> company = const Value.absent(),
          int? currentBalancePaisa}) =>
      Supplier(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        company: company.present ? company.value : this.company,
        currentBalancePaisa: currentBalancePaisa ?? this.currentBalancePaisa,
      );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      company: data.company.present ? data.company.value : this.company,
      currentBalancePaisa: data.currentBalancePaisa.present
          ? data.currentBalancePaisa.value
          : this.currentBalancePaisa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('company: $company, ')
          ..write('currentBalancePaisa: $currentBalancePaisa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, company, currentBalancePaisa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.company == this.company &&
          other.currentBalancePaisa == this.currentBalancePaisa);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> company;
  final Value<int> currentBalancePaisa;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.company = const Value.absent(),
    this.currentBalancePaisa = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.company = const Value.absent(),
    this.currentBalancePaisa = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? company,
    Expression<int>? currentBalancePaisa,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (company != null) 'company': company,
      if (currentBalancePaisa != null)
        'current_balance_paisa': currentBalancePaisa,
    });
  }

  SuppliersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? company,
      Value<int>? currentBalancePaisa}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      currentBalancePaisa: currentBalancePaisa ?? this.currentBalancePaisa,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (currentBalancePaisa.present) {
      map['current_balance_paisa'] = Variable<int>(currentBalancePaisa.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('company: $company, ')
          ..write('currentBalancePaisa: $currentBalancePaisa')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _vendorBillNoMeta =
      const VerificationMeta('vendorBillNo');
  @override
  late final GeneratedColumn<String> vendorBillNo = GeneratedColumn<String>(
      'vendor_bill_no', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalAmountPaisaMeta =
      const VerificationMeta('totalAmountPaisa');
  @override
  late final GeneratedColumn<int> totalAmountPaisa = GeneratedColumn<int>(
      'total_amount_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recordedByMeta =
      const VerificationMeta('recordedBy');
  @override
  late final GeneratedColumn<int> recordedBy = GeneratedColumn<int>(
      'recorded_by', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, supplierId, vendorBillNo, totalAmountPaisa, recordedBy, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(Insertable<Purchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    }
    if (data.containsKey('vendor_bill_no')) {
      context.handle(
          _vendorBillNoMeta,
          vendorBillNo.isAcceptableOrUnknown(
              data['vendor_bill_no']!, _vendorBillNoMeta));
    }
    if (data.containsKey('total_amount_paisa')) {
      context.handle(
          _totalAmountPaisaMeta,
          totalAmountPaisa.isAcceptableOrUnknown(
              data['total_amount_paisa']!, _totalAmountPaisaMeta));
    } else if (isInserting) {
      context.missing(_totalAmountPaisaMeta);
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
          _recordedByMeta,
          recordedBy.isAcceptableOrUnknown(
              data['recorded_by']!, _recordedByMeta));
    } else if (isInserting) {
      context.missing(_recordedByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id']),
      vendorBillNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vendor_bill_no']),
      totalAmountPaisa: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_amount_paisa'])!,
      recordedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recorded_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final int id;
  final int? supplierId;
  final String? vendorBillNo;
  final int totalAmountPaisa;
  final int recordedBy;
  final DateTime createdAt;
  const Purchase(
      {required this.id,
      this.supplierId,
      this.vendorBillNo,
      required this.totalAmountPaisa,
      required this.recordedBy,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<int>(supplierId);
    }
    if (!nullToAbsent || vendorBillNo != null) {
      map['vendor_bill_no'] = Variable<String>(vendorBillNo);
    }
    map['total_amount_paisa'] = Variable<int>(totalAmountPaisa);
    map['recorded_by'] = Variable<int>(recordedBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      vendorBillNo: vendorBillNo == null && nullToAbsent
          ? const Value.absent()
          : Value(vendorBillNo),
      totalAmountPaisa: Value(totalAmountPaisa),
      recordedBy: Value(recordedBy),
      createdAt: Value(createdAt),
    );
  }

  factory Purchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<int>(json['id']),
      supplierId: serializer.fromJson<int?>(json['supplierId']),
      vendorBillNo: serializer.fromJson<String?>(json['vendorBillNo']),
      totalAmountPaisa: serializer.fromJson<int>(json['totalAmountPaisa']),
      recordedBy: serializer.fromJson<int>(json['recordedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierId': serializer.toJson<int?>(supplierId),
      'vendorBillNo': serializer.toJson<String?>(vendorBillNo),
      'totalAmountPaisa': serializer.toJson<int>(totalAmountPaisa),
      'recordedBy': serializer.toJson<int>(recordedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Purchase copyWith(
          {int? id,
          Value<int?> supplierId = const Value.absent(),
          Value<String?> vendorBillNo = const Value.absent(),
          int? totalAmountPaisa,
          int? recordedBy,
          DateTime? createdAt}) =>
      Purchase(
        id: id ?? this.id,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        vendorBillNo:
            vendorBillNo.present ? vendorBillNo.value : this.vendorBillNo,
        totalAmountPaisa: totalAmountPaisa ?? this.totalAmountPaisa,
        recordedBy: recordedBy ?? this.recordedBy,
        createdAt: createdAt ?? this.createdAt,
      );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      vendorBillNo: data.vendorBillNo.present
          ? data.vendorBillNo.value
          : this.vendorBillNo,
      totalAmountPaisa: data.totalAmountPaisa.present
          ? data.totalAmountPaisa.value
          : this.totalAmountPaisa,
      recordedBy:
          data.recordedBy.present ? data.recordedBy.value : this.recordedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('vendorBillNo: $vendorBillNo, ')
          ..write('totalAmountPaisa: $totalAmountPaisa, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, supplierId, vendorBillNo, totalAmountPaisa, recordedBy, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.vendorBillNo == this.vendorBillNo &&
          other.totalAmountPaisa == this.totalAmountPaisa &&
          other.recordedBy == this.recordedBy &&
          other.createdAt == this.createdAt);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<int> id;
  final Value<int?> supplierId;
  final Value<String?> vendorBillNo;
  final Value<int> totalAmountPaisa;
  final Value<int> recordedBy;
  final Value<DateTime> createdAt;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.vendorBillNo = const Value.absent(),
    this.totalAmountPaisa = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PurchasesCompanion.insert({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.vendorBillNo = const Value.absent(),
    required int totalAmountPaisa,
    required int recordedBy,
    this.createdAt = const Value.absent(),
  })  : totalAmountPaisa = Value(totalAmountPaisa),
        recordedBy = Value(recordedBy);
  static Insertable<Purchase> custom({
    Expression<int>? id,
    Expression<int>? supplierId,
    Expression<String>? vendorBillNo,
    Expression<int>? totalAmountPaisa,
    Expression<int>? recordedBy,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (vendorBillNo != null) 'vendor_bill_no': vendorBillNo,
      if (totalAmountPaisa != null) 'total_amount_paisa': totalAmountPaisa,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PurchasesCompanion copyWith(
      {Value<int>? id,
      Value<int?>? supplierId,
      Value<String?>? vendorBillNo,
      Value<int>? totalAmountPaisa,
      Value<int>? recordedBy,
      Value<DateTime>? createdAt}) {
    return PurchasesCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      vendorBillNo: vendorBillNo ?? this.vendorBillNo,
      totalAmountPaisa: totalAmountPaisa ?? this.totalAmountPaisa,
      recordedBy: recordedBy ?? this.recordedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (vendorBillNo.present) {
      map['vendor_bill_no'] = Variable<String>(vendorBillNo.value);
    }
    if (totalAmountPaisa.present) {
      map['total_amount_paisa'] = Variable<int>(totalAmountPaisa.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<int>(recordedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('vendorBillNo: $vendorBillNo, ')
          ..write('totalAmountPaisa: $totalAmountPaisa, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
      'purchase_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES purchases (id)'));
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
      'part_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES parts (id)'));
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
      'qty', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitCostPaisaMeta =
      const VerificationMeta('unitCostPaisa');
  @override
  late final GeneratedColumn<int> unitCostPaisa = GeneratedColumn<int>(
      'unit_cost_paisa', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, purchaseId, partId, qty, unitCostPaisa];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items';
  @override
  VerificationContext validateIntegrity(Insertable<PurchaseItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(_partIdMeta,
          partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta));
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
          _qtyMeta, qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta));
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit_cost_paisa')) {
      context.handle(
          _unitCostPaisaMeta,
          unitCostPaisa.isAcceptableOrUnknown(
              data['unit_cost_paisa']!, _unitCostPaisaMeta));
    } else if (isInserting) {
      context.missing(_unitCostPaisaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}purchase_id'])!,
      partId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}part_id'])!,
      qty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}qty'])!,
      unitCostPaisa: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_cost_paisa'])!,
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final int id;
  final int purchaseId;
  final int partId;
  final int qty;
  final int unitCostPaisa;
  const PurchaseItem(
      {required this.id,
      required this.purchaseId,
      required this.partId,
      required this.qty,
      required this.unitCostPaisa});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_id'] = Variable<int>(purchaseId);
    map['part_id'] = Variable<int>(partId);
    map['qty'] = Variable<int>(qty);
    map['unit_cost_paisa'] = Variable<int>(unitCostPaisa);
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      partId: Value(partId),
      qty: Value(qty),
      unitCostPaisa: Value(unitCostPaisa),
    );
  }

  factory PurchaseItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<int>(json['id']),
      purchaseId: serializer.fromJson<int>(json['purchaseId']),
      partId: serializer.fromJson<int>(json['partId']),
      qty: serializer.fromJson<int>(json['qty']),
      unitCostPaisa: serializer.fromJson<int>(json['unitCostPaisa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseId': serializer.toJson<int>(purchaseId),
      'partId': serializer.toJson<int>(partId),
      'qty': serializer.toJson<int>(qty),
      'unitCostPaisa': serializer.toJson<int>(unitCostPaisa),
    };
  }

  PurchaseItem copyWith(
          {int? id,
          int? purchaseId,
          int? partId,
          int? qty,
          int? unitCostPaisa}) =>
      PurchaseItem(
        id: id ?? this.id,
        purchaseId: purchaseId ?? this.purchaseId,
        partId: partId ?? this.partId,
        qty: qty ?? this.qty,
        unitCostPaisa: unitCostPaisa ?? this.unitCostPaisa,
      );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      partId: data.partId.present ? data.partId.value : this.partId,
      qty: data.qty.present ? data.qty.value : this.qty,
      unitCostPaisa: data.unitCostPaisa.present
          ? data.unitCostPaisa.value
          : this.unitCostPaisa,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('partId: $partId, ')
          ..write('qty: $qty, ')
          ..write('unitCostPaisa: $unitCostPaisa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, purchaseId, partId, qty, unitCostPaisa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.partId == this.partId &&
          other.qty == this.qty &&
          other.unitCostPaisa == this.unitCostPaisa);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<int> id;
  final Value<int> purchaseId;
  final Value<int> partId;
  final Value<int> qty;
  final Value<int> unitCostPaisa;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.partId = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitCostPaisa = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseId,
    required int partId,
    required int qty,
    required int unitCostPaisa,
  })  : purchaseId = Value(purchaseId),
        partId = Value(partId),
        qty = Value(qty),
        unitCostPaisa = Value(unitCostPaisa);
  static Insertable<PurchaseItem> custom({
    Expression<int>? id,
    Expression<int>? purchaseId,
    Expression<int>? partId,
    Expression<int>? qty,
    Expression<int>? unitCostPaisa,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (partId != null) 'part_id': partId,
      if (qty != null) 'qty': qty,
      if (unitCostPaisa != null) 'unit_cost_paisa': unitCostPaisa,
    });
  }

  PurchaseItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? purchaseId,
      Value<int>? partId,
      Value<int>? qty,
      Value<int>? unitCostPaisa}) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      partId: partId ?? this.partId,
      qty: qty ?? this.qty,
      unitCostPaisa: unitCostPaisa ?? this.unitCostPaisa,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (unitCostPaisa.present) {
      map['unit_cost_paisa'] = Variable<int>(unitCostPaisa.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('partId: $partId, ')
          ..write('qty: $qty, ')
          ..write('unitCostPaisa: $unitCostPaisa')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SystemConfigsTable systemConfigs = $SystemConfigsTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $PartCategoriesTable partCategories = $PartCategoriesTable(this);
  late final $PartsTable parts = $PartsTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $CustomerLedgerEntriesTable customerLedgerEntries =
      $CustomerLedgerEntriesTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $RoutesTable routes = $RoutesTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $ReturnClaimsTable returnClaims = $ReturnClaimsTable(this);
  late final $ReturnClaimItemsTable returnClaimItems =
      $ReturnClaimItemsTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        systemConfigs,
        auditLogs,
        partCategories,
        parts,
        stockMovements,
        customers,
        customerLedgerEntries,
        sales,
        saleItems,
        expenses,
        routes,
        employees,
        returnClaims,
        returnClaimItems,
        suppliers,
        purchases,
        purchaseItems
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String username,
  Value<String?> displayName,
  required String role,
  required String pinHash,
  Value<String?> passwordHash,
  Value<int> failedAttempts,
  Value<DateTime?> lockedUntil,
  Value<DateTime?> lastLoginAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String?> displayName,
  Value<String> role,
  Value<String> pinHash,
  Value<String?> passwordHash,
  Value<int> failedAttempts,
  Value<DateTime?> lockedUntil,
  Value<DateTime?> lastLoginAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AuditLogsTable, List<AuditLog>>
      _auditLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.auditLogs,
              aliasName: 'users__id__audit_logs__user_id');

  $$AuditLogsTableProcessedTableManager get auditLogsRefs {
    final manager = $$AuditLogsTableTableManager($_db, $_db.auditLogs)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
      _stockMovementsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.stockMovements,
              aliasName: 'users__id__stock_movements__user_id');

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager($_db, $_db.stockMovements)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sales,
          aliasName: 'users__id__sales__created_by');

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.createdBy.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenses,
          aliasName: 'users__id__expenses__recorded_by');

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager($_db, $_db.expenses)
        .filter((f) => f.recordedBy.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PurchasesTable, List<Purchase>>
      _purchasesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchases,
              aliasName: 'users__id__purchases__recorded_by');

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager($_db, $_db.purchases)
        .filter((f) => f.recordedBy.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> auditLogsRefs(
      Expression<bool> Function($$AuditLogsTableFilterComposer f) f) {
    final $$AuditLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditLogs,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditLogsTableFilterComposer(
              $db: $db,
              $table: $db.auditLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> stockMovementsRefs(
      Expression<bool> Function($$StockMovementsTableFilterComposer f) f) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockMovements,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockMovementsTableFilterComposer(
              $db: $db,
              $table: $db.stockMovements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> salesRefs(
      Expression<bool> Function($$SalesTableFilterComposer f) f) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.createdBy,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> expensesRefs(
      Expression<bool> Function($$ExpensesTableFilterComposer f) f) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.recordedBy,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableFilterComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> purchasesRefs(
      Expression<bool> Function($$PurchasesTableFilterComposer f) f) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.recordedBy,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableFilterComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts, builder: (column) => column);

  GeneratedColumn<DateTime> get lockedUntil => $composableBuilder(
      column: $table.lockedUntil, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> auditLogsRefs<T extends Object>(
      Expression<T> Function($$AuditLogsTableAnnotationComposer a) f) {
    final $$AuditLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditLogs,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.auditLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> stockMovementsRefs<T extends Object>(
      Expression<T> Function($$StockMovementsTableAnnotationComposer a) f) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockMovements,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockMovementsTableAnnotationComposer(
              $db: $db,
              $table: $db.stockMovements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> salesRefs<T extends Object>(
      Expression<T> Function($$SalesTableAnnotationComposer a) f) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.createdBy,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
      Expression<T> Function($$ExpensesTableAnnotationComposer a) f) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.recordedBy,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> purchasesRefs<T extends Object>(
      Expression<T> Function($$PurchasesTableAnnotationComposer a) f) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.recordedBy,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool auditLogsRefs,
        bool stockMovementsRefs,
        bool salesRefs,
        bool expensesRefs,
        bool purchasesRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> pinHash = const Value.absent(),
            Value<String?> passwordHash = const Value.absent(),
            Value<int> failedAttempts = const Value.absent(),
            Value<DateTime?> lockedUntil = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            displayName: displayName,
            role: role,
            pinHash: pinHash,
            passwordHash: passwordHash,
            failedAttempts: failedAttempts,
            lockedUntil: lockedUntil,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            Value<String?> displayName = const Value.absent(),
            required String role,
            required String pinHash,
            Value<String?> passwordHash = const Value.absent(),
            Value<int> failedAttempts = const Value.absent(),
            Value<DateTime?> lockedUntil = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            displayName: displayName,
            role: role,
            pinHash: pinHash,
            passwordHash: passwordHash,
            failedAttempts: failedAttempts,
            lockedUntil: lockedUntil,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UsersTable, User>(table),
                    $$UsersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {auditLogsRefs = false,
              stockMovementsRefs = false,
              salesRefs = false,
              expensesRefs = false,
              purchasesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (auditLogsRefs) db.auditLogs,
                if (stockMovementsRefs) db.stockMovements,
                if (salesRefs) db.sales,
                if (expensesRefs) db.expenses,
                if (purchasesRefs) db.purchases
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (auditLogsRefs)
                    await $_getPrefetchedData<User, $UsersTable, AuditLog>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._auditLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).auditLogsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (stockMovementsRefs)
                    await $_getPrefetchedData<User, $UsersTable, StockMovement>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._stockMovementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .stockMovementsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (salesRefs)
                    await $_getPrefetchedData<User, $UsersTable, Sale>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._salesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).salesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.createdBy == item.id),
                        typedResults: items),
                  if (expensesRefs)
                    await $_getPrefetchedData<User, $UsersTable, Expense>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._expensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).expensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.recordedBy == item.id),
                        typedResults: items),
                  if (purchasesRefs)
                    await $_getPrefetchedData<User, $UsersTable, Purchase>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._purchasesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).purchasesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.recordedBy == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool auditLogsRefs,
        bool stockMovementsRefs,
        bool salesRefs,
        bool expensesRefs,
        bool purchasesRefs})>;
typedef $$SystemConfigsTableCreateCompanionBuilder = SystemConfigsCompanion
    Function({
  required String key,
  Value<String?> value,
  Value<int> rowid,
});
typedef $$SystemConfigsTableUpdateCompanionBuilder = SystemConfigsCompanion
    Function({
  Value<String> key,
  Value<String?> value,
  Value<int> rowid,
});

class $$SystemConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $SystemConfigsTable> {
  $$SystemConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SystemConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $SystemConfigsTable> {
  $$SystemConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SystemConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SystemConfigsTable> {
  $$SystemConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SystemConfigsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SystemConfigsTable,
    SystemConfig,
    $$SystemConfigsTableFilterComposer,
    $$SystemConfigsTableOrderingComposer,
    $$SystemConfigsTableAnnotationComposer,
    $$SystemConfigsTableCreateCompanionBuilder,
    $$SystemConfigsTableUpdateCompanionBuilder,
    (
      SystemConfig,
      BaseReferences<_$AppDatabase, $SystemConfigsTable, SystemConfig>
    ),
    SystemConfig,
    PrefetchHooks Function()> {
  $$SystemConfigsTableTableManager(_$AppDatabase db, $SystemConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SystemConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SystemConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SystemConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SystemConfigsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            Value<String?> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SystemConfigsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SystemConfigsTable, SystemConfig>(table),
                    BaseReferences<_$AppDatabase, $SystemConfigsTable,
                        SystemConfig>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SystemConfigsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SystemConfigsTable,
    SystemConfig,
    $$SystemConfigsTableFilterComposer,
    $$SystemConfigsTableOrderingComposer,
    $$SystemConfigsTableAnnotationComposer,
    $$SystemConfigsTableCreateCompanionBuilder,
    $$SystemConfigsTableUpdateCompanionBuilder,
    (
      SystemConfig,
      BaseReferences<_$AppDatabase, $SystemConfigsTable, SystemConfig>
    ),
    SystemConfig,
    PrefetchHooks Function()>;
typedef $$AuditLogsTableCreateCompanionBuilder = AuditLogsCompanion Function({
  Value<int> id,
  required String action,
  Value<String?> details,
  Value<int?> userId,
  Value<String?> usernameSnapshot,
  Value<String?> roleSnapshot,
  Value<DateTime> createdAt,
});
typedef $$AuditLogsTableUpdateCompanionBuilder = AuditLogsCompanion Function({
  Value<int> id,
  Value<String> action,
  Value<String?> details,
  Value<int?> userId,
  Value<String?> usernameSnapshot,
  Value<String?> roleSnapshot,
  Value<DateTime> createdAt,
});

final class $$AuditLogsTableReferences
    extends BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog> {
  $$AuditLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('audit_logs__user_id__users__id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usernameSnapshot => $composableBuilder(
      column: $table.usernameSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roleSnapshot => $composableBuilder(
      column: $table.roleSnapshot, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usernameSnapshot => $composableBuilder(
      column: $table.usernameSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roleSnapshot => $composableBuilder(
      column: $table.roleSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<String> get usernameSnapshot => $composableBuilder(
      column: $table.usernameSnapshot, builder: (column) => column);

  GeneratedColumn<String> get roleSnapshot => $composableBuilder(
      column: $table.roleSnapshot, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLog, $$AuditLogsTableReferences),
    AuditLog,
    PrefetchHooks Function({bool userId})> {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String?> usernameSnapshot = const Value.absent(),
            Value<String?> roleSnapshot = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AuditLogsCompanion(
            id: id,
            action: action,
            details: details,
            userId: userId,
            usernameSnapshot: usernameSnapshot,
            roleSnapshot: roleSnapshot,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String action,
            Value<String?> details = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String?> usernameSnapshot = const Value.absent(),
            Value<String?> roleSnapshot = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AuditLogsCompanion.insert(
            id: id,
            action: action,
            details: details,
            userId: userId,
            usernameSnapshot: usernameSnapshot,
            roleSnapshot: roleSnapshot,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AuditLogsTable, AuditLog>(table),
                    $$AuditLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$AuditLogsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$AuditLogsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AuditLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLog, $$AuditLogsTableReferences),
    AuditLog,
    PrefetchHooks Function({bool userId})>;
typedef $$PartCategoriesTableCreateCompanionBuilder = PartCategoriesCompanion
    Function({
  Value<int> id,
  required String nameEn,
  Value<String?> nameUr,
  Value<bool> isActive,
});
typedef $$PartCategoriesTableUpdateCompanionBuilder = PartCategoriesCompanion
    Function({
  Value<int> id,
  Value<String> nameEn,
  Value<String?> nameUr,
  Value<bool> isActive,
});

final class $$PartCategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $PartCategoriesTable, PartCategory> {
  $$PartCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PartsTable, List<Part>> _partsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.parts,
          aliasName: 'part_categories__id__parts__category_id');

  $$PartsTableProcessedTableManager get partsRefs {
    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_partsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PartCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $PartCategoriesTable> {
  $$PartCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameUr => $composableBuilder(
      column: $table.nameUr, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> partsRefs(
      Expression<bool> Function($$PartsTableFilterComposer f) f) {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableFilterComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PartCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartCategoriesTable> {
  $$PartCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameUr => $composableBuilder(
      column: $table.nameUr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$PartCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartCategoriesTable> {
  $$PartCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameUr =>
      $composableBuilder(column: $table.nameUr, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> partsRefs<T extends Object>(
      Expression<T> Function($$PartsTableAnnotationComposer a) f) {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableAnnotationComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PartCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartCategoriesTable,
    PartCategory,
    $$PartCategoriesTableFilterComposer,
    $$PartCategoriesTableOrderingComposer,
    $$PartCategoriesTableAnnotationComposer,
    $$PartCategoriesTableCreateCompanionBuilder,
    $$PartCategoriesTableUpdateCompanionBuilder,
    (PartCategory, $$PartCategoriesTableReferences),
    PartCategory,
    PrefetchHooks Function({bool partsRefs})> {
  $$PartCategoriesTableTableManager(
      _$AppDatabase db, $PartCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> nameUr = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              PartCategoriesCompanion(
            id: id,
            nameEn: nameEn,
            nameUr: nameUr,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nameEn,
            Value<String?> nameUr = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              PartCategoriesCompanion.insert(
            id: id,
            nameEn: nameEn,
            nameUr: nameUr,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PartCategoriesTable, PartCategory>(table),
                    $$PartCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({partsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (partsRefs) db.parts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (partsRefs)
                    await $_getPrefetchedData<PartCategory,
                            $PartCategoriesTable, Part>(
                        currentTable: table,
                        referencedTable:
                            $$PartCategoriesTableReferences._partsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PartCategoriesTableReferences(db, table, p0)
                                .partsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PartCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartCategoriesTable,
    PartCategory,
    $$PartCategoriesTableFilterComposer,
    $$PartCategoriesTableOrderingComposer,
    $$PartCategoriesTableAnnotationComposer,
    $$PartCategoriesTableCreateCompanionBuilder,
    $$PartCategoriesTableUpdateCompanionBuilder,
    (PartCategory, $$PartCategoriesTableReferences),
    PartCategory,
    PrefetchHooks Function({bool partsRefs})>;
typedef $$PartsTableCreateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
  required String code,
  Value<String?> barcode,
  required String nameEn,
  Value<String?> nameUr,
  required int categoryId,
  Value<String> unit,
  Value<int> avgCostPaisa,
  Value<int> retailPricePaisa,
  Value<int> wholesalePricePaisa,
  Value<String?> shelfLocation,
  Value<int> defectiveStock,
  Value<int> currentStock,
  Value<int> minStockAlert,
});
typedef $$PartsTableUpdateCompanionBuilder = PartsCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String?> barcode,
  Value<String> nameEn,
  Value<String?> nameUr,
  Value<int> categoryId,
  Value<String> unit,
  Value<int> avgCostPaisa,
  Value<int> retailPricePaisa,
  Value<int> wholesalePricePaisa,
  Value<String?> shelfLocation,
  Value<int> defectiveStock,
  Value<int> currentStock,
  Value<int> minStockAlert,
});

final class $$PartsTableReferences
    extends BaseReferences<_$AppDatabase, $PartsTable, Part> {
  $$PartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.partCategories.createAlias('parts__category_id__part_categories__id');

  $$PartCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$PartCategoriesTableTableManager($_db, $_db.partCategories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
      _stockMovementsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.stockMovements,
              aliasName: 'parts__id__stock_movements__part_id');

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager($_db, $_db.stockMovements)
        .filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SaleItemsTable, List<SaleItem>>
      _saleItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.saleItems,
              aliasName: 'parts__id__sale_items__part_id');

  $$SaleItemsTableProcessedTableManager get saleItemsRefs {
    final manager = $$SaleItemsTableTableManager($_db, $_db.saleItems)
        .filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReturnClaimItemsTable, List<ReturnClaimItem>>
      _returnClaimItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.returnClaimItems,
              aliasName: 'parts__id__return_claim_items__part_id');

  $$ReturnClaimItemsTableProcessedTableManager get returnClaimItemsRefs {
    final manager =
        $$ReturnClaimItemsTableTableManager($_db, $_db.returnClaimItems)
            .filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_returnClaimItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
      _purchaseItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseItems,
              aliasName: 'parts__id__purchase_items__part_id');

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager($_db, $_db.purchaseItems)
        .filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PartsTableFilterComposer extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameUr => $composableBuilder(
      column: $table.nameUr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get avgCostPaisa => $composableBuilder(
      column: $table.avgCostPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retailPricePaisa => $composableBuilder(
      column: $table.retailPricePaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wholesalePricePaisa => $composableBuilder(
      column: $table.wholesalePricePaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shelfLocation => $composableBuilder(
      column: $table.shelfLocation, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defectiveStock => $composableBuilder(
      column: $table.defectiveStock,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentStock => $composableBuilder(
      column: $table.currentStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert, builder: (column) => ColumnFilters(column));

  $$PartCategoriesTableFilterComposer get categoryId {
    final $$PartCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.partCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.partCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> stockMovementsRefs(
      Expression<bool> Function($$StockMovementsTableFilterComposer f) f) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockMovements,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockMovementsTableFilterComposer(
              $db: $db,
              $table: $db.stockMovements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> saleItemsRefs(
      Expression<bool> Function($$SaleItemsTableFilterComposer f) f) {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableFilterComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> returnClaimItemsRefs(
      Expression<bool> Function($$ReturnClaimItemsTableFilterComposer f) f) {
    final $$ReturnClaimItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnClaimItems,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnClaimItemsTableFilterComposer(
              $db: $db,
              $table: $db.returnClaimItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> purchaseItemsRefs(
      Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PartsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameUr => $composableBuilder(
      column: $table.nameUr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get avgCostPaisa => $composableBuilder(
      column: $table.avgCostPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retailPricePaisa => $composableBuilder(
      column: $table.retailPricePaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wholesalePricePaisa => $composableBuilder(
      column: $table.wholesalePricePaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shelfLocation => $composableBuilder(
      column: $table.shelfLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defectiveStock => $composableBuilder(
      column: $table.defectiveStock,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentStock => $composableBuilder(
      column: $table.currentStock,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert,
      builder: (column) => ColumnOrderings(column));

  $$PartCategoriesTableOrderingComposer get categoryId {
    final $$PartCategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.partCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartCategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.partCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartsTable> {
  $$PartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameUr =>
      $composableBuilder(column: $table.nameUr, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get avgCostPaisa => $composableBuilder(
      column: $table.avgCostPaisa, builder: (column) => column);

  GeneratedColumn<int> get retailPricePaisa => $composableBuilder(
      column: $table.retailPricePaisa, builder: (column) => column);

  GeneratedColumn<int> get wholesalePricePaisa => $composableBuilder(
      column: $table.wholesalePricePaisa, builder: (column) => column);

  GeneratedColumn<String> get shelfLocation => $composableBuilder(
      column: $table.shelfLocation, builder: (column) => column);

  GeneratedColumn<int> get defectiveStock => $composableBuilder(
      column: $table.defectiveStock, builder: (column) => column);

  GeneratedColumn<int> get currentStock => $composableBuilder(
      column: $table.currentStock, builder: (column) => column);

  GeneratedColumn<int> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert, builder: (column) => column);

  $$PartCategoriesTableAnnotationComposer get categoryId {
    final $$PartCategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.partCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartCategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.partCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> stockMovementsRefs<T extends Object>(
      Expression<T> Function($$StockMovementsTableAnnotationComposer a) f) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockMovements,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockMovementsTableAnnotationComposer(
              $db: $db,
              $table: $db.stockMovements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> saleItemsRefs<T extends Object>(
      Expression<T> Function($$SaleItemsTableAnnotationComposer a) f) {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> returnClaimItemsRefs<T extends Object>(
      Expression<T> Function($$ReturnClaimItemsTableAnnotationComposer a) f) {
    final $$ReturnClaimItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnClaimItems,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnClaimItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.returnClaimItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.partId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PartsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartsTable,
    Part,
    $$PartsTableFilterComposer,
    $$PartsTableOrderingComposer,
    $$PartsTableAnnotationComposer,
    $$PartsTableCreateCompanionBuilder,
    $$PartsTableUpdateCompanionBuilder,
    (Part, $$PartsTableReferences),
    Part,
    PrefetchHooks Function(
        {bool categoryId,
        bool stockMovementsRefs,
        bool saleItemsRefs,
        bool returnClaimItemsRefs,
        bool purchaseItemsRefs})> {
  $$PartsTableTableManager(_$AppDatabase db, $PartsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> nameUr = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> avgCostPaisa = const Value.absent(),
            Value<int> retailPricePaisa = const Value.absent(),
            Value<int> wholesalePricePaisa = const Value.absent(),
            Value<String?> shelfLocation = const Value.absent(),
            Value<int> defectiveStock = const Value.absent(),
            Value<int> currentStock = const Value.absent(),
            Value<int> minStockAlert = const Value.absent(),
          }) =>
              PartsCompanion(
            id: id,
            code: code,
            barcode: barcode,
            nameEn: nameEn,
            nameUr: nameUr,
            categoryId: categoryId,
            unit: unit,
            avgCostPaisa: avgCostPaisa,
            retailPricePaisa: retailPricePaisa,
            wholesalePricePaisa: wholesalePricePaisa,
            shelfLocation: shelfLocation,
            defectiveStock: defectiveStock,
            currentStock: currentStock,
            minStockAlert: minStockAlert,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            Value<String?> barcode = const Value.absent(),
            required String nameEn,
            Value<String?> nameUr = const Value.absent(),
            required int categoryId,
            Value<String> unit = const Value.absent(),
            Value<int> avgCostPaisa = const Value.absent(),
            Value<int> retailPricePaisa = const Value.absent(),
            Value<int> wholesalePricePaisa = const Value.absent(),
            Value<String?> shelfLocation = const Value.absent(),
            Value<int> defectiveStock = const Value.absent(),
            Value<int> currentStock = const Value.absent(),
            Value<int> minStockAlert = const Value.absent(),
          }) =>
              PartsCompanion.insert(
            id: id,
            code: code,
            barcode: barcode,
            nameEn: nameEn,
            nameUr: nameUr,
            categoryId: categoryId,
            unit: unit,
            avgCostPaisa: avgCostPaisa,
            retailPricePaisa: retailPricePaisa,
            wholesalePricePaisa: wholesalePricePaisa,
            shelfLocation: shelfLocation,
            defectiveStock: defectiveStock,
            currentStock: currentStock,
            minStockAlert: minStockAlert,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PartsTable, Part>(table),
                    $$PartsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              stockMovementsRefs = false,
              saleItemsRefs = false,
              returnClaimItemsRefs = false,
              purchaseItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (stockMovementsRefs) db.stockMovements,
                if (saleItemsRefs) db.saleItems,
                if (returnClaimItemsRefs) db.returnClaimItems,
                if (purchaseItemsRefs) db.purchaseItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$PartsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$PartsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (stockMovementsRefs)
                    await $_getPrefetchedData<Part, $PartsTable, StockMovement>(
                        currentTable: table,
                        referencedTable:
                            $$PartsTableReferences._stockMovementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PartsTableReferences(db, table, p0)
                                .stockMovementsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.partId == item.id),
                        typedResults: items),
                  if (saleItemsRefs)
                    await $_getPrefetchedData<Part, $PartsTable, SaleItem>(
                        currentTable: table,
                        referencedTable:
                            $$PartsTableReferences._saleItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PartsTableReferences(db, table, p0).saleItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.partId == item.id),
                        typedResults: items),
                  if (returnClaimItemsRefs)
                    await $_getPrefetchedData<Part, $PartsTable,
                            ReturnClaimItem>(
                        currentTable: table,
                        referencedTable: $$PartsTableReferences
                            ._returnClaimItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PartsTableReferences(db, table, p0)
                                .returnClaimItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.partId == item.id),
                        typedResults: items),
                  if (purchaseItemsRefs)
                    await $_getPrefetchedData<Part, $PartsTable, PurchaseItem>(
                        currentTable: table,
                        referencedTable:
                            $$PartsTableReferences._purchaseItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PartsTableReferences(db, table, p0)
                                .purchaseItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.partId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PartsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartsTable,
    Part,
    $$PartsTableFilterComposer,
    $$PartsTableOrderingComposer,
    $$PartsTableAnnotationComposer,
    $$PartsTableCreateCompanionBuilder,
    $$PartsTableUpdateCompanionBuilder,
    (Part, $$PartsTableReferences),
    Part,
    PrefetchHooks Function(
        {bool categoryId,
        bool stockMovementsRefs,
        bool saleItemsRefs,
        bool returnClaimItemsRefs,
        bool purchaseItemsRefs})>;
typedef $$StockMovementsTableCreateCompanionBuilder = StockMovementsCompanion
    Function({
  Value<int> id,
  required int partId,
  required String movementType,
  required int qtyChange,
  required int unitCostPaisa,
  Value<String?> refTable,
  Value<int?> refId,
  Value<String?> notes,
  required int userId,
  Value<DateTime> createdAt,
});
typedef $$StockMovementsTableUpdateCompanionBuilder = StockMovementsCompanion
    Function({
  Value<int> id,
  Value<int> partId,
  Value<String> movementType,
  Value<int> qtyChange,
  Value<int> unitCostPaisa,
  Value<String?> refTable,
  Value<int?> refId,
  Value<String?> notes,
  Value<int> userId,
  Value<DateTime> createdAt,
});

final class $$StockMovementsTableReferences
    extends BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement> {
  $$StockMovementsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PartsTable _partIdTable(_$AppDatabase db) =>
      db.parts.createAlias('stock_movements__part_id__parts__id');

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('stock_movements__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get movementType => $composableBuilder(
      column: $table.movementType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get qtyChange => $composableBuilder(
      column: $table.qtyChange, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostPaisa => $composableBuilder(
      column: $table.unitCostPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refTable => $composableBuilder(
      column: $table.refTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get refId => $composableBuilder(
      column: $table.refId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableFilterComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get movementType => $composableBuilder(
      column: $table.movementType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get qtyChange => $composableBuilder(
      column: $table.qtyChange, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostPaisa => $composableBuilder(
      column: $table.unitCostPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refTable => $composableBuilder(
      column: $table.refTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get refId => $composableBuilder(
      column: $table.refId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableOrderingComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get movementType => $composableBuilder(
      column: $table.movementType, builder: (column) => column);

  GeneratedColumn<int> get qtyChange =>
      $composableBuilder(column: $table.qtyChange, builder: (column) => column);

  GeneratedColumn<int> get unitCostPaisa => $composableBuilder(
      column: $table.unitCostPaisa, builder: (column) => column);

  GeneratedColumn<String> get refTable =>
      $composableBuilder(column: $table.refTable, builder: (column) => column);

  GeneratedColumn<int> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableAnnotationComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockMovementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockMovementsTable,
    StockMovement,
    $$StockMovementsTableFilterComposer,
    $$StockMovementsTableOrderingComposer,
    $$StockMovementsTableAnnotationComposer,
    $$StockMovementsTableCreateCompanionBuilder,
    $$StockMovementsTableUpdateCompanionBuilder,
    (StockMovement, $$StockMovementsTableReferences),
    StockMovement,
    PrefetchHooks Function({bool partId, bool userId})> {
  $$StockMovementsTableTableManager(
      _$AppDatabase db, $StockMovementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> partId = const Value.absent(),
            Value<String> movementType = const Value.absent(),
            Value<int> qtyChange = const Value.absent(),
            Value<int> unitCostPaisa = const Value.absent(),
            Value<String?> refTable = const Value.absent(),
            Value<int?> refId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              StockMovementsCompanion(
            id: id,
            partId: partId,
            movementType: movementType,
            qtyChange: qtyChange,
            unitCostPaisa: unitCostPaisa,
            refTable: refTable,
            refId: refId,
            notes: notes,
            userId: userId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int partId,
            required String movementType,
            required int qtyChange,
            required int unitCostPaisa,
            Value<String?> refTable = const Value.absent(),
            Value<int?> refId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required int userId,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              StockMovementsCompanion.insert(
            id: id,
            partId: partId,
            movementType: movementType,
            qtyChange: qtyChange,
            unitCostPaisa: unitCostPaisa,
            refTable: refTable,
            refId: refId,
            notes: notes,
            userId: userId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$StockMovementsTable, StockMovement>(table),
                    $$StockMovementsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({partId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (partId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.partId,
                    referencedTable:
                        $$StockMovementsTableReferences._partIdTable(db),
                    referencedColumn:
                        $$StockMovementsTableReferences._partIdTable(db).id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$StockMovementsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$StockMovementsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StockMovementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockMovementsTable,
    StockMovement,
    $$StockMovementsTableFilterComposer,
    $$StockMovementsTableOrderingComposer,
    $$StockMovementsTableAnnotationComposer,
    $$StockMovementsTableCreateCompanionBuilder,
    $$StockMovementsTableUpdateCompanionBuilder,
    (StockMovement, $$StockMovementsTableReferences),
    StockMovement,
    PrefetchHooks Function({bool partId, bool userId})>;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> shopName,
  Value<String?> phone,
  Value<String?> address,
  Value<String> customerType,
  Value<int?> creditLimitPaisa,
  Value<int> currentBalancePaisa,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> shopName,
  Value<String?> phone,
  Value<String?> address,
  Value<String> customerType,
  Value<int?> creditLimitPaisa,
  Value<int> currentBalancePaisa,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CustomerLedgerEntriesTable,
      List<CustomerLedgerEntry>> _customerLedgerEntriesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.customerLedgerEntries,
          aliasName: 'customers__id__customer_ledger_entries__customer_id');

  $$CustomerLedgerEntriesTableProcessedTableManager
      get customerLedgerEntriesRefs {
    final manager = $$CustomerLedgerEntriesTableTableManager(
            $_db, $_db.customerLedgerEntries)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_customerLedgerEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sales,
          aliasName: 'customers__id__sales__customer_id');

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shopName => $composableBuilder(
      column: $table.shopName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerType => $composableBuilder(
      column: $table.customerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get creditLimitPaisa => $composableBuilder(
      column: $table.creditLimitPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentBalancePaisa => $composableBuilder(
      column: $table.currentBalancePaisa,
      builder: (column) => ColumnFilters(column));

  Expression<bool> customerLedgerEntriesRefs(
      Expression<bool> Function($$CustomerLedgerEntriesTableFilterComposer f)
          f) {
    final $$CustomerLedgerEntriesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.customerLedgerEntries,
            getReferencedColumn: (t) => t.customerId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CustomerLedgerEntriesTableFilterComposer(
                  $db: $db,
                  $table: $db.customerLedgerEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> salesRefs(
      Expression<bool> Function($$SalesTableFilterComposer f) f) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shopName => $composableBuilder(
      column: $table.shopName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerType => $composableBuilder(
      column: $table.customerType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get creditLimitPaisa => $composableBuilder(
      column: $table.creditLimitPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentBalancePaisa => $composableBuilder(
      column: $table.currentBalancePaisa,
      builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get shopName =>
      $composableBuilder(column: $table.shopName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get customerType => $composableBuilder(
      column: $table.customerType, builder: (column) => column);

  GeneratedColumn<int> get creditLimitPaisa => $composableBuilder(
      column: $table.creditLimitPaisa, builder: (column) => column);

  GeneratedColumn<int> get currentBalancePaisa => $composableBuilder(
      column: $table.currentBalancePaisa, builder: (column) => column);

  Expression<T> customerLedgerEntriesRefs<T extends Object>(
      Expression<T> Function($$CustomerLedgerEntriesTableAnnotationComposer a)
          f) {
    final $$CustomerLedgerEntriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.customerLedgerEntries,
            getReferencedColumn: (t) => t.customerId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CustomerLedgerEntriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.customerLedgerEntries,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> salesRefs<T extends Object>(
      Expression<T> Function($$SalesTableAnnotationComposer a) f) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function({bool customerLedgerEntriesRefs, bool salesRefs})> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> shopName = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> customerType = const Value.absent(),
            Value<int?> creditLimitPaisa = const Value.absent(),
            Value<int> currentBalancePaisa = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            name: name,
            shopName: shopName,
            phone: phone,
            address: address,
            customerType: customerType,
            creditLimitPaisa: creditLimitPaisa,
            currentBalancePaisa: currentBalancePaisa,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> shopName = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> customerType = const Value.absent(),
            Value<int?> creditLimitPaisa = const Value.absent(),
            Value<int> currentBalancePaisa = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            name: name,
            shopName: shopName,
            phone: phone,
            address: address,
            customerType: customerType,
            creditLimitPaisa: creditLimitPaisa,
            currentBalancePaisa: currentBalancePaisa,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CustomersTable, Customer>(table),
                    $$CustomersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {customerLedgerEntriesRefs = false, salesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (customerLedgerEntriesRefs) db.customerLedgerEntries,
                if (salesRefs) db.sales
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (customerLedgerEntriesRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable,
                            CustomerLedgerEntry>(
                        currentTable: table,
                        referencedTable: $$CustomersTableReferences
                            ._customerLedgerEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .customerLedgerEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items),
                  if (salesRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable, Sale>(
                        currentTable: table,
                        referencedTable:
                            $$CustomersTableReferences._salesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0).salesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function({bool customerLedgerEntriesRefs, bool salesRefs})>;
typedef $$CustomerLedgerEntriesTableCreateCompanionBuilder
    = CustomerLedgerEntriesCompanion Function({
  Value<int> id,
  required int customerId,
  Value<int?> invoiceId,
  required String entryType,
  Value<int> debitAmountPaisa,
  Value<int> creditAmountPaisa,
  required int runningBalancePaisa,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$CustomerLedgerEntriesTableUpdateCompanionBuilder
    = CustomerLedgerEntriesCompanion Function({
  Value<int> id,
  Value<int> customerId,
  Value<int?> invoiceId,
  Value<String> entryType,
  Value<int> debitAmountPaisa,
  Value<int> creditAmountPaisa,
  Value<int> runningBalancePaisa,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$CustomerLedgerEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $CustomerLedgerEntriesTable, CustomerLedgerEntry> {
  $$CustomerLedgerEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) => db.customers
      .createAlias('customer_ledger_entries__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CustomerLedgerEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomerLedgerEntriesTable> {
  $$CustomerLedgerEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get invoiceId => $composableBuilder(
      column: $table.invoiceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entryType => $composableBuilder(
      column: $table.entryType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get debitAmountPaisa => $composableBuilder(
      column: $table.debitAmountPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get creditAmountPaisa => $composableBuilder(
      column: $table.creditAmountPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get runningBalancePaisa => $composableBuilder(
      column: $table.runningBalancePaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CustomerLedgerEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomerLedgerEntriesTable> {
  $$CustomerLedgerEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get invoiceId => $composableBuilder(
      column: $table.invoiceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entryType => $composableBuilder(
      column: $table.entryType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get debitAmountPaisa => $composableBuilder(
      column: $table.debitAmountPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get creditAmountPaisa => $composableBuilder(
      column: $table.creditAmountPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get runningBalancePaisa => $composableBuilder(
      column: $table.runningBalancePaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CustomerLedgerEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomerLedgerEntriesTable> {
  $$CustomerLedgerEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get invoiceId =>
      $composableBuilder(column: $table.invoiceId, builder: (column) => column);

  GeneratedColumn<String> get entryType =>
      $composableBuilder(column: $table.entryType, builder: (column) => column);

  GeneratedColumn<int> get debitAmountPaisa => $composableBuilder(
      column: $table.debitAmountPaisa, builder: (column) => column);

  GeneratedColumn<int> get creditAmountPaisa => $composableBuilder(
      column: $table.creditAmountPaisa, builder: (column) => column);

  GeneratedColumn<int> get runningBalancePaisa => $composableBuilder(
      column: $table.runningBalancePaisa, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CustomerLedgerEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomerLedgerEntriesTable,
    CustomerLedgerEntry,
    $$CustomerLedgerEntriesTableFilterComposer,
    $$CustomerLedgerEntriesTableOrderingComposer,
    $$CustomerLedgerEntriesTableAnnotationComposer,
    $$CustomerLedgerEntriesTableCreateCompanionBuilder,
    $$CustomerLedgerEntriesTableUpdateCompanionBuilder,
    (CustomerLedgerEntry, $$CustomerLedgerEntriesTableReferences),
    CustomerLedgerEntry,
    PrefetchHooks Function({bool customerId})> {
  $$CustomerLedgerEntriesTableTableManager(
      _$AppDatabase db, $CustomerLedgerEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomerLedgerEntriesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomerLedgerEntriesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomerLedgerEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> customerId = const Value.absent(),
            Value<int?> invoiceId = const Value.absent(),
            Value<String> entryType = const Value.absent(),
            Value<int> debitAmountPaisa = const Value.absent(),
            Value<int> creditAmountPaisa = const Value.absent(),
            Value<int> runningBalancePaisa = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomerLedgerEntriesCompanion(
            id: id,
            customerId: customerId,
            invoiceId: invoiceId,
            entryType: entryType,
            debitAmountPaisa: debitAmountPaisa,
            creditAmountPaisa: creditAmountPaisa,
            runningBalancePaisa: runningBalancePaisa,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int customerId,
            Value<int?> invoiceId = const Value.absent(),
            required String entryType,
            Value<int> debitAmountPaisa = const Value.absent(),
            Value<int> creditAmountPaisa = const Value.absent(),
            required int runningBalancePaisa,
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomerLedgerEntriesCompanion.insert(
            id: id,
            customerId: customerId,
            invoiceId: invoiceId,
            entryType: entryType,
            debitAmountPaisa: debitAmountPaisa,
            creditAmountPaisa: creditAmountPaisa,
            runningBalancePaisa: runningBalancePaisa,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CustomerLedgerEntriesTable,
                        CustomerLedgerEntry>(table),
                    $$CustomerLedgerEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({customerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable: $$CustomerLedgerEntriesTableReferences
                        ._customerIdTable(db),
                    referencedColumn: $$CustomerLedgerEntriesTableReferences
                        ._customerIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CustomerLedgerEntriesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CustomerLedgerEntriesTable,
        CustomerLedgerEntry,
        $$CustomerLedgerEntriesTableFilterComposer,
        $$CustomerLedgerEntriesTableOrderingComposer,
        $$CustomerLedgerEntriesTableAnnotationComposer,
        $$CustomerLedgerEntriesTableCreateCompanionBuilder,
        $$CustomerLedgerEntriesTableUpdateCompanionBuilder,
        (CustomerLedgerEntry, $$CustomerLedgerEntriesTableReferences),
        CustomerLedgerEntry,
        PrefetchHooks Function({bool customerId})>;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  required int billNumber,
  Value<int?> customerId,
  required String saleType,
  required int grossAmountPaisa,
  Value<int> discountAmountPaisa,
  required int netAmountPaisa,
  required int paidAmountPaisa,
  Value<int> previousBalancePaisa,
  required String paymentStatus,
  required int createdBy,
  Value<DateTime> createdAt,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  Value<int> billNumber,
  Value<int?> customerId,
  Value<String> saleType,
  Value<int> grossAmountPaisa,
  Value<int> discountAmountPaisa,
  Value<int> netAmountPaisa,
  Value<int> paidAmountPaisa,
  Value<int> previousBalancePaisa,
  Value<String> paymentStatus,
  Value<int> createdBy,
  Value<DateTime> createdAt,
});

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, Sale> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('sales__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _createdByTable(_$AppDatabase db) =>
      db.users.createAlias('sales__created_by__users__id');

  $$UsersTableProcessedTableManager get createdBy {
    final $_column = $_itemColumn<int>('created_by')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_createdByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SaleItemsTable, List<SaleItem>>
      _saleItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.saleItems,
              aliasName: 'sales__id__sale_items__sale_id');

  $$SaleItemsTableProcessedTableManager get saleItemsRefs {
    final manager = $$SaleItemsTableTableManager($_db, $_db.saleItems)
        .filter((f) => f.saleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReturnClaimsTable, List<ReturnClaim>>
      _returnClaimsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.returnClaims,
              aliasName: 'sales__id__return_claims__sale_id');

  $$ReturnClaimsTableProcessedTableManager get returnClaimsRefs {
    final manager = $$ReturnClaimsTableTableManager($_db, $_db.returnClaims)
        .filter((f) => f.saleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_returnClaimsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saleType => $composableBuilder(
      column: $table.saleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get grossAmountPaisa => $composableBuilder(
      column: $table.grossAmountPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountAmountPaisa => $composableBuilder(
      column: $table.discountAmountPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get netAmountPaisa => $composableBuilder(
      column: $table.netAmountPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paidAmountPaisa => $composableBuilder(
      column: $table.paidAmountPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get previousBalancePaisa => $composableBuilder(
      column: $table.previousBalancePaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get createdBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.createdBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> saleItemsRefs(
      Expression<bool> Function($$SaleItemsTableFilterComposer f) f) {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableFilterComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> returnClaimsRefs(
      Expression<bool> Function($$ReturnClaimsTableFilterComposer f) f) {
    final $$ReturnClaimsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnClaims,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnClaimsTableFilterComposer(
              $db: $db,
              $table: $db.returnClaims,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saleType => $composableBuilder(
      column: $table.saleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get grossAmountPaisa => $composableBuilder(
      column: $table.grossAmountPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountAmountPaisa => $composableBuilder(
      column: $table.discountAmountPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get netAmountPaisa => $composableBuilder(
      column: $table.netAmountPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paidAmountPaisa => $composableBuilder(
      column: $table.paidAmountPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get previousBalancePaisa => $composableBuilder(
      column: $table.previousBalancePaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get createdBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.createdBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => column);

  GeneratedColumn<String> get saleType =>
      $composableBuilder(column: $table.saleType, builder: (column) => column);

  GeneratedColumn<int> get grossAmountPaisa => $composableBuilder(
      column: $table.grossAmountPaisa, builder: (column) => column);

  GeneratedColumn<int> get discountAmountPaisa => $composableBuilder(
      column: $table.discountAmountPaisa, builder: (column) => column);

  GeneratedColumn<int> get netAmountPaisa => $composableBuilder(
      column: $table.netAmountPaisa, builder: (column) => column);

  GeneratedColumn<int> get paidAmountPaisa => $composableBuilder(
      column: $table.paidAmountPaisa, builder: (column) => column);

  GeneratedColumn<int> get previousBalancePaisa => $composableBuilder(
      column: $table.previousBalancePaisa, builder: (column) => column);

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get createdBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.createdBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> saleItemsRefs<T extends Object>(
      Expression<T> Function($$SaleItemsTableAnnotationComposer a) f) {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> returnClaimsRefs<T extends Object>(
      Expression<T> Function($$ReturnClaimsTableAnnotationComposer a) f) {
    final $$ReturnClaimsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnClaims,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnClaimsTableAnnotationComposer(
              $db: $db,
              $table: $db.returnClaims,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, $$SalesTableReferences),
    Sale,
    PrefetchHooks Function(
        {bool customerId,
        bool createdBy,
        bool saleItemsRefs,
        bool returnClaimsRefs})> {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> billNumber = const Value.absent(),
            Value<int?> customerId = const Value.absent(),
            Value<String> saleType = const Value.absent(),
            Value<int> grossAmountPaisa = const Value.absent(),
            Value<int> discountAmountPaisa = const Value.absent(),
            Value<int> netAmountPaisa = const Value.absent(),
            Value<int> paidAmountPaisa = const Value.absent(),
            Value<int> previousBalancePaisa = const Value.absent(),
            Value<String> paymentStatus = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            billNumber: billNumber,
            customerId: customerId,
            saleType: saleType,
            grossAmountPaisa: grossAmountPaisa,
            discountAmountPaisa: discountAmountPaisa,
            netAmountPaisa: netAmountPaisa,
            paidAmountPaisa: paidAmountPaisa,
            previousBalancePaisa: previousBalancePaisa,
            paymentStatus: paymentStatus,
            createdBy: createdBy,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int billNumber,
            Value<int?> customerId = const Value.absent(),
            required String saleType,
            required int grossAmountPaisa,
            Value<int> discountAmountPaisa = const Value.absent(),
            required int netAmountPaisa,
            required int paidAmountPaisa,
            Value<int> previousBalancePaisa = const Value.absent(),
            required String paymentStatus,
            required int createdBy,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            billNumber: billNumber,
            customerId: customerId,
            saleType: saleType,
            grossAmountPaisa: grossAmountPaisa,
            discountAmountPaisa: discountAmountPaisa,
            netAmountPaisa: netAmountPaisa,
            paidAmountPaisa: paidAmountPaisa,
            previousBalancePaisa: previousBalancePaisa,
            paymentStatus: paymentStatus,
            createdBy: createdBy,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SalesTable, Sale>(table),
                    $$SalesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {customerId = false,
              createdBy = false,
              saleItemsRefs = false,
              returnClaimsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (saleItemsRefs) db.saleItems,
                if (returnClaimsRefs) db.returnClaims
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$SalesTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$SalesTableReferences._customerIdTable(db).id,
                  ) as T;
                }
                if (createdBy) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.createdBy,
                    referencedTable: $$SalesTableReferences._createdByTable(db),
                    referencedColumn:
                        $$SalesTableReferences._createdByTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (saleItemsRefs)
                    await $_getPrefetchedData<Sale, $SalesTable, SaleItem>(
                        currentTable: table,
                        referencedTable:
                            $$SalesTableReferences._saleItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SalesTableReferences(db, table, p0).saleItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.saleId == item.id),
                        typedResults: items),
                  if (returnClaimsRefs)
                    await $_getPrefetchedData<Sale, $SalesTable, ReturnClaim>(
                        currentTable: table,
                        referencedTable:
                            $$SalesTableReferences._returnClaimsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SalesTableReferences(db, table, p0)
                                .returnClaimsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.saleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, $$SalesTableReferences),
    Sale,
    PrefetchHooks Function(
        {bool customerId,
        bool createdBy,
        bool saleItemsRefs,
        bool returnClaimsRefs})>;
typedef $$SaleItemsTableCreateCompanionBuilder = SaleItemsCompanion Function({
  Value<int> id,
  required int saleId,
  required int partId,
  required int unitRatePaisa,
  required int qty,
  required int lineTotalPaisa,
});
typedef $$SaleItemsTableUpdateCompanionBuilder = SaleItemsCompanion Function({
  Value<int> id,
  Value<int> saleId,
  Value<int> partId,
  Value<int> unitRatePaisa,
  Value<int> qty,
  Value<int> lineTotalPaisa,
});

final class $$SaleItemsTableReferences
    extends BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem> {
  $$SaleItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) =>
      db.sales.createAlias('sale_items__sale_id__sales__id');

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<int>('sale_id')!;

    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PartsTable _partIdTable(_$AppDatabase db) =>
      db.parts.createAlias('sale_items__part_id__parts__id');

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitRatePaisa => $composableBuilder(
      column: $table.unitRatePaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get qty => $composableBuilder(
      column: $table.qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lineTotalPaisa => $composableBuilder(
      column: $table.lineTotalPaisa,
      builder: (column) => ColumnFilters(column));

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableFilterComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitRatePaisa => $composableBuilder(
      column: $table.unitRatePaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get qty => $composableBuilder(
      column: $table.qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lineTotalPaisa => $composableBuilder(
      column: $table.lineTotalPaisa,
      builder: (column) => ColumnOrderings(column));

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableOrderingComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableOrderingComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get unitRatePaisa => $composableBuilder(
      column: $table.unitRatePaisa, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get lineTotalPaisa => $composableBuilder(
      column: $table.lineTotalPaisa, builder: (column) => column);

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableAnnotationComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SaleItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, $$SaleItemsTableReferences),
    SaleItem,
    PrefetchHooks Function({bool saleId, bool partId})> {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saleId = const Value.absent(),
            Value<int> partId = const Value.absent(),
            Value<int> unitRatePaisa = const Value.absent(),
            Value<int> qty = const Value.absent(),
            Value<int> lineTotalPaisa = const Value.absent(),
          }) =>
              SaleItemsCompanion(
            id: id,
            saleId: saleId,
            partId: partId,
            unitRatePaisa: unitRatePaisa,
            qty: qty,
            lineTotalPaisa: lineTotalPaisa,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saleId,
            required int partId,
            required int unitRatePaisa,
            required int qty,
            required int lineTotalPaisa,
          }) =>
              SaleItemsCompanion.insert(
            id: id,
            saleId: saleId,
            partId: partId,
            unitRatePaisa: unitRatePaisa,
            qty: qty,
            lineTotalPaisa: lineTotalPaisa,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SaleItemsTable, SaleItem>(table),
                    $$SaleItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({saleId = false, partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (saleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saleId,
                    referencedTable:
                        $$SaleItemsTableReferences._saleIdTable(db),
                    referencedColumn:
                        $$SaleItemsTableReferences._saleIdTable(db).id,
                  ) as T;
                }
                if (partId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.partId,
                    referencedTable:
                        $$SaleItemsTableReferences._partIdTable(db),
                    referencedColumn:
                        $$SaleItemsTableReferences._partIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SaleItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, $$SaleItemsTableReferences),
    SaleItem,
    PrefetchHooks Function({bool saleId, bool partId})>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required String category,
  required int amountPaisa,
  Value<String> paymentMode,
  Value<String?> description,
  required int recordedBy,
  required DateTime expenseDate,
  Value<DateTime> createdAt,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<String> category,
  Value<int> amountPaisa,
  Value<String> paymentMode,
  Value<String?> description,
  Value<int> recordedBy,
  Value<DateTime> expenseDate,
  Value<DateTime> createdAt,
});

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _recordedByTable(_$AppDatabase db) =>
      db.users.createAlias('expenses__recorded_by__users__id');

  $$UsersTableProcessedTableManager get recordedBy {
    final $_column = $_itemColumn<int>('recorded_by')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get recordedBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get recordedBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amountPaisa => $composableBuilder(
      column: $table.amountPaisa, builder: (column) => column);

  GeneratedColumn<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get expenseDate => $composableBuilder(
      column: $table.expenseDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get recordedBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, $$ExpensesTableReferences),
    Expense,
    PrefetchHooks Function({bool recordedBy})> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> amountPaisa = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> recordedBy = const Value.absent(),
            Value<DateTime> expenseDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            category: category,
            amountPaisa: amountPaisa,
            paymentMode: paymentMode,
            description: description,
            recordedBy: recordedBy,
            expenseDate: expenseDate,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String category,
            required int amountPaisa,
            Value<String> paymentMode = const Value.absent(),
            Value<String?> description = const Value.absent(),
            required int recordedBy,
            required DateTime expenseDate,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            category: category,
            amountPaisa: amountPaisa,
            paymentMode: paymentMode,
            description: description,
            recordedBy: recordedBy,
            expenseDate: expenseDate,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ExpensesTable, Expense>(table),
                    $$ExpensesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recordedBy = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (recordedBy) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recordedBy,
                    referencedTable:
                        $$ExpensesTableReferences._recordedByTable(db),
                    referencedColumn:
                        $$ExpensesTableReferences._recordedByTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, $$ExpensesTableReferences),
    Expense,
    PrefetchHooks Function({bool recordedBy})>;
typedef $$RoutesTableCreateCompanionBuilder = RoutesCompanion Function({
  Value<int> id,
  required String name,
  Value<String> city,
  Value<String?> description,
  Value<DateTime> createdAt,
});
typedef $$RoutesTableUpdateCompanionBuilder = RoutesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> city,
  Value<String?> description,
  Value<DateTime> createdAt,
});

final class $$RoutesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutesTable, Route> {
  $$RoutesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EmployeesTable, List<Employee>>
      _employeesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.employees,
              aliasName: 'routes__id__employees__assigned_route_id');

  $$EmployeesTableProcessedTableManager get employeesRefs {
    final manager = $$EmployeesTableTableManager($_db, $_db.employees).filter(
        (f) => f.assignedRouteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_employeesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RoutesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> employeesRefs(
      Expression<bool> Function($$EmployeesTableFilterComposer f) f) {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.assignedRouteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableFilterComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoutesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RoutesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> employeesRefs<T extends Object>(
      Expression<T> Function($$EmployeesTableAnnotationComposer a) f) {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.assignedRouteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableAnnotationComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoutesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutesTable,
    Route,
    $$RoutesTableFilterComposer,
    $$RoutesTableOrderingComposer,
    $$RoutesTableAnnotationComposer,
    $$RoutesTableCreateCompanionBuilder,
    $$RoutesTableUpdateCompanionBuilder,
    (Route, $$RoutesTableReferences),
    Route,
    PrefetchHooks Function({bool employeesRefs})> {
  $$RoutesTableTableManager(_$AppDatabase db, $RoutesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> city = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              RoutesCompanion(
            id: id,
            name: name,
            city: city,
            description: description,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> city = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              RoutesCompanion.insert(
            id: id,
            name: name,
            city: city,
            description: description,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoutesTable, Route>(table),
                    $$RoutesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({employeesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (employeesRefs) db.employees],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (employeesRefs)
                    await $_getPrefetchedData<Route, $RoutesTable, Employee>(
                        currentTable: table,
                        referencedTable:
                            $$RoutesTableReferences._employeesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoutesTableReferences(db, table, p0)
                                .employeesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.assignedRouteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RoutesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutesTable,
    Route,
    $$RoutesTableFilterComposer,
    $$RoutesTableOrderingComposer,
    $$RoutesTableAnnotationComposer,
    $$RoutesTableCreateCompanionBuilder,
    $$RoutesTableUpdateCompanionBuilder,
    (Route, $$RoutesTableReferences),
    Route,
    PrefetchHooks Function({bool employeesRefs})>;
typedef $$EmployeesTableCreateCompanionBuilder = EmployeesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  required String role,
  Value<int?> assignedRouteId,
  Value<int> monthlySalaryPaisa,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$EmployeesTableUpdateCompanionBuilder = EmployeesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String> role,
  Value<int?> assignedRouteId,
  Value<int> monthlySalaryPaisa,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDatabase, $EmployeesTable, Employee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutesTable _assignedRouteIdTable(_$AppDatabase db) =>
      db.routes.createAlias('employees__assigned_route_id__routes__id');

  $$RoutesTableProcessedTableManager? get assignedRouteId {
    final $_column = $_itemColumn<int>('assigned_route_id');
    if ($_column == null) return null;
    final manager = $$RoutesTableTableManager($_db, $_db.routes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assignedRouteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get monthlySalaryPaisa => $composableBuilder(
      column: $table.monthlySalaryPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$RoutesTableFilterComposer get assignedRouteId {
    final $$RoutesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assignedRouteId,
        referencedTable: $db.routes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutesTableFilterComposer(
              $db: $db,
              $table: $db.routes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get monthlySalaryPaisa => $composableBuilder(
      column: $table.monthlySalaryPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$RoutesTableOrderingComposer get assignedRouteId {
    final $$RoutesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assignedRouteId,
        referencedTable: $db.routes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutesTableOrderingComposer(
              $db: $db,
              $table: $db.routes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get monthlySalaryPaisa => $composableBuilder(
      column: $table.monthlySalaryPaisa, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RoutesTableAnnotationComposer get assignedRouteId {
    final $$RoutesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.assignedRouteId,
        referencedTable: $db.routes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutesTableAnnotationComposer(
              $db: $db,
              $table: $db.routes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EmployeesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeesTable,
    Employee,
    $$EmployeesTableFilterComposer,
    $$EmployeesTableOrderingComposer,
    $$EmployeesTableAnnotationComposer,
    $$EmployeesTableCreateCompanionBuilder,
    $$EmployeesTableUpdateCompanionBuilder,
    (Employee, $$EmployeesTableReferences),
    Employee,
    PrefetchHooks Function({bool assignedRouteId})> {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<int?> assignedRouteId = const Value.absent(),
            Value<int> monthlySalaryPaisa = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              EmployeesCompanion(
            id: id,
            name: name,
            phone: phone,
            role: role,
            assignedRouteId: assignedRouteId,
            monthlySalaryPaisa: monthlySalaryPaisa,
            isActive: isActive,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            required String role,
            Value<int?> assignedRouteId = const Value.absent(),
            Value<int> monthlySalaryPaisa = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              EmployeesCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            role: role,
            assignedRouteId: assignedRouteId,
            monthlySalaryPaisa: monthlySalaryPaisa,
            isActive: isActive,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EmployeesTable, Employee>(table),
                    $$EmployeesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({assignedRouteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (assignedRouteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.assignedRouteId,
                    referencedTable:
                        $$EmployeesTableReferences._assignedRouteIdTable(db),
                    referencedColumn:
                        $$EmployeesTableReferences._assignedRouteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EmployeesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeesTable,
    Employee,
    $$EmployeesTableFilterComposer,
    $$EmployeesTableOrderingComposer,
    $$EmployeesTableAnnotationComposer,
    $$EmployeesTableCreateCompanionBuilder,
    $$EmployeesTableUpdateCompanionBuilder,
    (Employee, $$EmployeesTableReferences),
    Employee,
    PrefetchHooks Function({bool assignedRouteId})>;
typedef $$ReturnClaimsTableCreateCompanionBuilder = ReturnClaimsCompanion
    Function({
  Value<int> id,
  required int saleId,
  required int requestedBy,
  Value<int?> approvedBy,
  Value<String> claimStatus,
  required int totalRefundAmountPaisa,
  Value<String?> rejectionReason,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ReturnClaimsTableUpdateCompanionBuilder = ReturnClaimsCompanion
    Function({
  Value<int> id,
  Value<int> saleId,
  Value<int> requestedBy,
  Value<int?> approvedBy,
  Value<String> claimStatus,
  Value<int> totalRefundAmountPaisa,
  Value<String?> rejectionReason,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ReturnClaimsTableReferences
    extends BaseReferences<_$AppDatabase, $ReturnClaimsTable, ReturnClaim> {
  $$ReturnClaimsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) =>
      db.sales.createAlias('return_claims__sale_id__sales__id');

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<int>('sale_id')!;

    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _requestedByTable(_$AppDatabase db) =>
      db.users.createAlias('return_claims__requested_by__users__id');

  $$UsersTableProcessedTableManager get requestedBy {
    final $_column = $_itemColumn<int>('requested_by')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_requestedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _approvedByTable(_$AppDatabase db) =>
      db.users.createAlias('return_claims__approved_by__users__id');

  $$UsersTableProcessedTableManager? get approvedBy {
    final $_column = $_itemColumn<int>('approved_by');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_approvedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ReturnClaimItemsTable, List<ReturnClaimItem>>
      _returnClaimItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.returnClaimItems,
              aliasName: 'return_claims__id__return_claim_items__claim_id');

  $$ReturnClaimItemsTableProcessedTableManager get returnClaimItemsRefs {
    final manager =
        $$ReturnClaimItemsTableTableManager($_db, $_db.returnClaimItems)
            .filter((f) => f.claimId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_returnClaimItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ReturnClaimsTableFilterComposer
    extends Composer<_$AppDatabase, $ReturnClaimsTable> {
  $$ReturnClaimsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get claimStatus => $composableBuilder(
      column: $table.claimStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalRefundAmountPaisa => $composableBuilder(
      column: $table.totalRefundAmountPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get requestedBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.requestedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get approvedBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.approvedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> returnClaimItemsRefs(
      Expression<bool> Function($$ReturnClaimItemsTableFilterComposer f) f) {
    final $$ReturnClaimItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnClaimItems,
        getReferencedColumn: (t) => t.claimId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnClaimItemsTableFilterComposer(
              $db: $db,
              $table: $db.returnClaimItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReturnClaimsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReturnClaimsTable> {
  $$ReturnClaimsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get claimStatus => $composableBuilder(
      column: $table.claimStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalRefundAmountPaisa => $composableBuilder(
      column: $table.totalRefundAmountPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableOrderingComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get requestedBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.requestedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get approvedBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.approvedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReturnClaimsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReturnClaimsTable> {
  $$ReturnClaimsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get claimStatus => $composableBuilder(
      column: $table.claimStatus, builder: (column) => column);

  GeneratedColumn<int> get totalRefundAmountPaisa => $composableBuilder(
      column: $table.totalRefundAmountPaisa, builder: (column) => column);

  GeneratedColumn<String> get rejectionReason => $composableBuilder(
      column: $table.rejectionReason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get requestedBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.requestedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get approvedBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.approvedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> returnClaimItemsRefs<T extends Object>(
      Expression<T> Function($$ReturnClaimItemsTableAnnotationComposer a) f) {
    final $$ReturnClaimItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnClaimItems,
        getReferencedColumn: (t) => t.claimId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnClaimItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.returnClaimItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReturnClaimsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReturnClaimsTable,
    ReturnClaim,
    $$ReturnClaimsTableFilterComposer,
    $$ReturnClaimsTableOrderingComposer,
    $$ReturnClaimsTableAnnotationComposer,
    $$ReturnClaimsTableCreateCompanionBuilder,
    $$ReturnClaimsTableUpdateCompanionBuilder,
    (ReturnClaim, $$ReturnClaimsTableReferences),
    ReturnClaim,
    PrefetchHooks Function(
        {bool saleId,
        bool requestedBy,
        bool approvedBy,
        bool returnClaimItemsRefs})> {
  $$ReturnClaimsTableTableManager(_$AppDatabase db, $ReturnClaimsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnClaimsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnClaimsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnClaimsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saleId = const Value.absent(),
            Value<int> requestedBy = const Value.absent(),
            Value<int?> approvedBy = const Value.absent(),
            Value<String> claimStatus = const Value.absent(),
            Value<int> totalRefundAmountPaisa = const Value.absent(),
            Value<String?> rejectionReason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ReturnClaimsCompanion(
            id: id,
            saleId: saleId,
            requestedBy: requestedBy,
            approvedBy: approvedBy,
            claimStatus: claimStatus,
            totalRefundAmountPaisa: totalRefundAmountPaisa,
            rejectionReason: rejectionReason,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saleId,
            required int requestedBy,
            Value<int?> approvedBy = const Value.absent(),
            Value<String> claimStatus = const Value.absent(),
            required int totalRefundAmountPaisa,
            Value<String?> rejectionReason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ReturnClaimsCompanion.insert(
            id: id,
            saleId: saleId,
            requestedBy: requestedBy,
            approvedBy: approvedBy,
            claimStatus: claimStatus,
            totalRefundAmountPaisa: totalRefundAmountPaisa,
            rejectionReason: rejectionReason,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ReturnClaimsTable, ReturnClaim>(table),
                    $$ReturnClaimsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {saleId = false,
              requestedBy = false,
              approvedBy = false,
              returnClaimItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (returnClaimItemsRefs) db.returnClaimItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (saleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saleId,
                    referencedTable:
                        $$ReturnClaimsTableReferences._saleIdTable(db),
                    referencedColumn:
                        $$ReturnClaimsTableReferences._saleIdTable(db).id,
                  ) as T;
                }
                if (requestedBy) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.requestedBy,
                    referencedTable:
                        $$ReturnClaimsTableReferences._requestedByTable(db),
                    referencedColumn:
                        $$ReturnClaimsTableReferences._requestedByTable(db).id,
                  ) as T;
                }
                if (approvedBy) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.approvedBy,
                    referencedTable:
                        $$ReturnClaimsTableReferences._approvedByTable(db),
                    referencedColumn:
                        $$ReturnClaimsTableReferences._approvedByTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (returnClaimItemsRefs)
                    await $_getPrefetchedData<ReturnClaim, $ReturnClaimsTable,
                            ReturnClaimItem>(
                        currentTable: table,
                        referencedTable: $$ReturnClaimsTableReferences
                            ._returnClaimItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ReturnClaimsTableReferences(db, table, p0)
                                .returnClaimItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.claimId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ReturnClaimsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReturnClaimsTable,
    ReturnClaim,
    $$ReturnClaimsTableFilterComposer,
    $$ReturnClaimsTableOrderingComposer,
    $$ReturnClaimsTableAnnotationComposer,
    $$ReturnClaimsTableCreateCompanionBuilder,
    $$ReturnClaimsTableUpdateCompanionBuilder,
    (ReturnClaim, $$ReturnClaimsTableReferences),
    ReturnClaim,
    PrefetchHooks Function(
        {bool saleId,
        bool requestedBy,
        bool approvedBy,
        bool returnClaimItemsRefs})>;
typedef $$ReturnClaimItemsTableCreateCompanionBuilder
    = ReturnClaimItemsCompanion Function({
  Value<int> id,
  required int claimId,
  required int partId,
  required int quantity,
  required int refundRatePaisa,
  required int lineRefundTotalPaisa,
  Value<String> inventoryDisposition,
});
typedef $$ReturnClaimItemsTableUpdateCompanionBuilder
    = ReturnClaimItemsCompanion Function({
  Value<int> id,
  Value<int> claimId,
  Value<int> partId,
  Value<int> quantity,
  Value<int> refundRatePaisa,
  Value<int> lineRefundTotalPaisa,
  Value<String> inventoryDisposition,
});

final class $$ReturnClaimItemsTableReferences extends BaseReferences<
    _$AppDatabase, $ReturnClaimItemsTable, ReturnClaimItem> {
  $$ReturnClaimItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ReturnClaimsTable _claimIdTable(_$AppDatabase db) => db.returnClaims
      .createAlias('return_claim_items__claim_id__return_claims__id');

  $$ReturnClaimsTableProcessedTableManager get claimId {
    final $_column = $_itemColumn<int>('claim_id')!;

    final manager = $$ReturnClaimsTableTableManager($_db, $_db.returnClaims)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_claimIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PartsTable _partIdTable(_$AppDatabase db) =>
      db.parts.createAlias('return_claim_items__part_id__parts__id');

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReturnClaimItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ReturnClaimItemsTable> {
  $$ReturnClaimItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get refundRatePaisa => $composableBuilder(
      column: $table.refundRatePaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lineRefundTotalPaisa => $composableBuilder(
      column: $table.lineRefundTotalPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inventoryDisposition => $composableBuilder(
      column: $table.inventoryDisposition,
      builder: (column) => ColumnFilters(column));

  $$ReturnClaimsTableFilterComposer get claimId {
    final $$ReturnClaimsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.claimId,
        referencedTable: $db.returnClaims,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnClaimsTableFilterComposer(
              $db: $db,
              $table: $db.returnClaims,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableFilterComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReturnClaimItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReturnClaimItemsTable> {
  $$ReturnClaimItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get refundRatePaisa => $composableBuilder(
      column: $table.refundRatePaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lineRefundTotalPaisa => $composableBuilder(
      column: $table.lineRefundTotalPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inventoryDisposition => $composableBuilder(
      column: $table.inventoryDisposition,
      builder: (column) => ColumnOrderings(column));

  $$ReturnClaimsTableOrderingComposer get claimId {
    final $$ReturnClaimsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.claimId,
        referencedTable: $db.returnClaims,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnClaimsTableOrderingComposer(
              $db: $db,
              $table: $db.returnClaims,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableOrderingComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReturnClaimItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReturnClaimItemsTable> {
  $$ReturnClaimItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get refundRatePaisa => $composableBuilder(
      column: $table.refundRatePaisa, builder: (column) => column);

  GeneratedColumn<int> get lineRefundTotalPaisa => $composableBuilder(
      column: $table.lineRefundTotalPaisa, builder: (column) => column);

  GeneratedColumn<String> get inventoryDisposition => $composableBuilder(
      column: $table.inventoryDisposition, builder: (column) => column);

  $$ReturnClaimsTableAnnotationComposer get claimId {
    final $$ReturnClaimsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.claimId,
        referencedTable: $db.returnClaims,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnClaimsTableAnnotationComposer(
              $db: $db,
              $table: $db.returnClaims,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableAnnotationComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReturnClaimItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReturnClaimItemsTable,
    ReturnClaimItem,
    $$ReturnClaimItemsTableFilterComposer,
    $$ReturnClaimItemsTableOrderingComposer,
    $$ReturnClaimItemsTableAnnotationComposer,
    $$ReturnClaimItemsTableCreateCompanionBuilder,
    $$ReturnClaimItemsTableUpdateCompanionBuilder,
    (ReturnClaimItem, $$ReturnClaimItemsTableReferences),
    ReturnClaimItem,
    PrefetchHooks Function({bool claimId, bool partId})> {
  $$ReturnClaimItemsTableTableManager(
      _$AppDatabase db, $ReturnClaimItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnClaimItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnClaimItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnClaimItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> claimId = const Value.absent(),
            Value<int> partId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> refundRatePaisa = const Value.absent(),
            Value<int> lineRefundTotalPaisa = const Value.absent(),
            Value<String> inventoryDisposition = const Value.absent(),
          }) =>
              ReturnClaimItemsCompanion(
            id: id,
            claimId: claimId,
            partId: partId,
            quantity: quantity,
            refundRatePaisa: refundRatePaisa,
            lineRefundTotalPaisa: lineRefundTotalPaisa,
            inventoryDisposition: inventoryDisposition,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int claimId,
            required int partId,
            required int quantity,
            required int refundRatePaisa,
            required int lineRefundTotalPaisa,
            Value<String> inventoryDisposition = const Value.absent(),
          }) =>
              ReturnClaimItemsCompanion.insert(
            id: id,
            claimId: claimId,
            partId: partId,
            quantity: quantity,
            refundRatePaisa: refundRatePaisa,
            lineRefundTotalPaisa: lineRefundTotalPaisa,
            inventoryDisposition: inventoryDisposition,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ReturnClaimItemsTable, ReturnClaimItem>(table),
                    $$ReturnClaimItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({claimId = false, partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (claimId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.claimId,
                    referencedTable:
                        $$ReturnClaimItemsTableReferences._claimIdTable(db),
                    referencedColumn:
                        $$ReturnClaimItemsTableReferences._claimIdTable(db).id,
                  ) as T;
                }
                if (partId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.partId,
                    referencedTable:
                        $$ReturnClaimItemsTableReferences._partIdTable(db),
                    referencedColumn:
                        $$ReturnClaimItemsTableReferences._partIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReturnClaimItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReturnClaimItemsTable,
    ReturnClaimItem,
    $$ReturnClaimItemsTableFilterComposer,
    $$ReturnClaimItemsTableOrderingComposer,
    $$ReturnClaimItemsTableAnnotationComposer,
    $$ReturnClaimItemsTableCreateCompanionBuilder,
    $$ReturnClaimItemsTableUpdateCompanionBuilder,
    (ReturnClaimItem, $$ReturnClaimItemsTableReferences),
    ReturnClaimItem,
    PrefetchHooks Function({bool claimId, bool partId})>;
typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> company,
  Value<int> currentBalancePaisa,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> company,
  Value<int> currentBalancePaisa,
});

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PurchasesTable, List<Purchase>>
      _purchasesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchases,
              aliasName: 'suppliers__id__purchases__supplier_id');

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager($_db, $_db.purchases)
        .filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get company => $composableBuilder(
      column: $table.company, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentBalancePaisa => $composableBuilder(
      column: $table.currentBalancePaisa,
      builder: (column) => ColumnFilters(column));

  Expression<bool> purchasesRefs(
      Expression<bool> Function($$PurchasesTableFilterComposer f) f) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableFilterComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get company => $composableBuilder(
      column: $table.company, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentBalancePaisa => $composableBuilder(
      column: $table.currentBalancePaisa,
      builder: (column) => ColumnOrderings(column));
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<int> get currentBalancePaisa => $composableBuilder(
      column: $table.currentBalancePaisa, builder: (column) => column);

  Expression<T> purchasesRefs<T extends Object>(
      Expression<T> Function($$PurchasesTableAnnotationComposer a) f) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function({bool purchasesRefs})> {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> company = const Value.absent(),
            Value<int> currentBalancePaisa = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            name: name,
            phone: phone,
            company: company,
            currentBalancePaisa: currentBalancePaisa,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> company = const Value.absent(),
            Value<int> currentBalancePaisa = const Value.absent(),
          }) =>
              SuppliersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            company: company,
            currentBalancePaisa: currentBalancePaisa,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SuppliersTable, Supplier>(table),
                    $$SuppliersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({purchasesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (purchasesRefs) db.purchases],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchasesRefs)
                    await $_getPrefetchedData<Supplier, $SuppliersTable,
                            Purchase>(
                        currentTable: table,
                        referencedTable:
                            $$SuppliersTableReferences._purchasesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SuppliersTableReferences(db, table, p0)
                                .purchasesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.supplierId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SuppliersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function({bool purchasesRefs})>;
typedef $$PurchasesTableCreateCompanionBuilder = PurchasesCompanion Function({
  Value<int> id,
  Value<int?> supplierId,
  Value<String?> vendorBillNo,
  required int totalAmountPaisa,
  required int recordedBy,
  Value<DateTime> createdAt,
});
typedef $$PurchasesTableUpdateCompanionBuilder = PurchasesCompanion Function({
  Value<int> id,
  Value<int?> supplierId,
  Value<String?> vendorBillNo,
  Value<int> totalAmountPaisa,
  Value<int> recordedBy,
  Value<DateTime> createdAt,
});

final class $$PurchasesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchasesTable, Purchase> {
  $$PurchasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias('purchases__supplier_id__suppliers__id');

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<int>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager($_db, $_db.suppliers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _recordedByTable(_$AppDatabase db) =>
      db.users.createAlias('purchases__recorded_by__users__id');

  $$UsersTableProcessedTableManager get recordedBy {
    final $_column = $_itemColumn<int>('recorded_by')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
      _purchaseItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseItems,
              aliasName: 'purchases__id__purchase_items__purchase_id');

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager($_db, $_db.purchaseItems)
        .filter((f) => f.purchaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vendorBillNo => $composableBuilder(
      column: $table.vendorBillNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalAmountPaisa => $composableBuilder(
      column: $table.totalAmountPaisa,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableFilterComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get recordedBy {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> purchaseItemsRefs(
      Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.purchaseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vendorBillNo => $composableBuilder(
      column: $table.vendorBillNo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalAmountPaisa => $composableBuilder(
      column: $table.totalAmountPaisa,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableOrderingComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get recordedBy {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vendorBillNo => $composableBuilder(
      column: $table.vendorBillNo, builder: (column) => column);

  GeneratedColumn<int> get totalAmountPaisa => $composableBuilder(
      column: $table.totalAmountPaisa, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableAnnotationComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get recordedBy {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recordedBy,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.purchaseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchasesTable,
    Purchase,
    $$PurchasesTableFilterComposer,
    $$PurchasesTableOrderingComposer,
    $$PurchasesTableAnnotationComposer,
    $$PurchasesTableCreateCompanionBuilder,
    $$PurchasesTableUpdateCompanionBuilder,
    (Purchase, $$PurchasesTableReferences),
    Purchase,
    PrefetchHooks Function(
        {bool supplierId, bool recordedBy, bool purchaseItemsRefs})> {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> supplierId = const Value.absent(),
            Value<String?> vendorBillNo = const Value.absent(),
            Value<int> totalAmountPaisa = const Value.absent(),
            Value<int> recordedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PurchasesCompanion(
            id: id,
            supplierId: supplierId,
            vendorBillNo: vendorBillNo,
            totalAmountPaisa: totalAmountPaisa,
            recordedBy: recordedBy,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> supplierId = const Value.absent(),
            Value<String?> vendorBillNo = const Value.absent(),
            required int totalAmountPaisa,
            required int recordedBy,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PurchasesCompanion.insert(
            id: id,
            supplierId: supplierId,
            vendorBillNo: vendorBillNo,
            totalAmountPaisa: totalAmountPaisa,
            recordedBy: recordedBy,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PurchasesTable, Purchase>(table),
                    $$PurchasesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {supplierId = false,
              recordedBy = false,
              purchaseItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchaseItemsRefs) db.purchaseItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (supplierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supplierId,
                    referencedTable:
                        $$PurchasesTableReferences._supplierIdTable(db),
                    referencedColumn:
                        $$PurchasesTableReferences._supplierIdTable(db).id,
                  ) as T;
                }
                if (recordedBy) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recordedBy,
                    referencedTable:
                        $$PurchasesTableReferences._recordedByTable(db),
                    referencedColumn:
                        $$PurchasesTableReferences._recordedByTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchaseItemsRefs)
                    await $_getPrefetchedData<Purchase, $PurchasesTable,
                            PurchaseItem>(
                        currentTable: table,
                        referencedTable: $$PurchasesTableReferences
                            ._purchaseItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PurchasesTableReferences(db, table, p0)
                                .purchaseItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.purchaseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PurchasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchasesTable,
    Purchase,
    $$PurchasesTableFilterComposer,
    $$PurchasesTableOrderingComposer,
    $$PurchasesTableAnnotationComposer,
    $$PurchasesTableCreateCompanionBuilder,
    $$PurchasesTableUpdateCompanionBuilder,
    (Purchase, $$PurchasesTableReferences),
    Purchase,
    PrefetchHooks Function(
        {bool supplierId, bool recordedBy, bool purchaseItemsRefs})>;
typedef $$PurchaseItemsTableCreateCompanionBuilder = PurchaseItemsCompanion
    Function({
  Value<int> id,
  required int purchaseId,
  required int partId,
  required int qty,
  required int unitCostPaisa,
});
typedef $$PurchaseItemsTableUpdateCompanionBuilder = PurchaseItemsCompanion
    Function({
  Value<int> id,
  Value<int> purchaseId,
  Value<int> partId,
  Value<int> qty,
  Value<int> unitCostPaisa,
});

final class $$PurchaseItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem> {
  $$PurchaseItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PurchasesTable _purchaseIdTable(_$AppDatabase db) =>
      db.purchases.createAlias('purchase_items__purchase_id__purchases__id');

  $$PurchasesTableProcessedTableManager get purchaseId {
    final $_column = $_itemColumn<int>('purchase_id')!;

    final manager = $$PurchasesTableTableManager($_db, $_db.purchases)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PartsTable _partIdTable(_$AppDatabase db) =>
      db.parts.createAlias('purchase_items__part_id__parts__id');

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager($_db, $_db.parts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PurchaseItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get qty => $composableBuilder(
      column: $table.qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostPaisa => $composableBuilder(
      column: $table.unitCostPaisa, builder: (column) => ColumnFilters(column));

  $$PurchasesTableFilterComposer get purchaseId {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableFilterComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableFilterComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get qty => $composableBuilder(
      column: $table.qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostPaisa => $composableBuilder(
      column: $table.unitCostPaisa,
      builder: (column) => ColumnOrderings(column));

  $$PurchasesTableOrderingComposer get purchaseId {
    final $$PurchasesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableOrderingComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableOrderingComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get unitCostPaisa => $composableBuilder(
      column: $table.unitCostPaisa, builder: (column) => column);

  $$PurchasesTableAnnotationComposer get purchaseId {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.partId,
        referencedTable: $db.parts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PartsTableAnnotationComposer(
              $db: $db,
              $table: $db.parts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseItemsTable,
    PurchaseItem,
    $$PurchaseItemsTableFilterComposer,
    $$PurchaseItemsTableOrderingComposer,
    $$PurchaseItemsTableAnnotationComposer,
    $$PurchaseItemsTableCreateCompanionBuilder,
    $$PurchaseItemsTableUpdateCompanionBuilder,
    (PurchaseItem, $$PurchaseItemsTableReferences),
    PurchaseItem,
    PrefetchHooks Function({bool purchaseId, bool partId})> {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> purchaseId = const Value.absent(),
            Value<int> partId = const Value.absent(),
            Value<int> qty = const Value.absent(),
            Value<int> unitCostPaisa = const Value.absent(),
          }) =>
              PurchaseItemsCompanion(
            id: id,
            purchaseId: purchaseId,
            partId: partId,
            qty: qty,
            unitCostPaisa: unitCostPaisa,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int purchaseId,
            required int partId,
            required int qty,
            required int unitCostPaisa,
          }) =>
              PurchaseItemsCompanion.insert(
            id: id,
            purchaseId: purchaseId,
            partId: partId,
            qty: qty,
            unitCostPaisa: unitCostPaisa,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PurchaseItemsTable, PurchaseItem>(table),
                    $$PurchaseItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({purchaseId = false, partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (purchaseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.purchaseId,
                    referencedTable:
                        $$PurchaseItemsTableReferences._purchaseIdTable(db),
                    referencedColumn:
                        $$PurchaseItemsTableReferences._purchaseIdTable(db).id,
                  ) as T;
                }
                if (partId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.partId,
                    referencedTable:
                        $$PurchaseItemsTableReferences._partIdTable(db),
                    referencedColumn:
                        $$PurchaseItemsTableReferences._partIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PurchaseItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchaseItemsTable,
    PurchaseItem,
    $$PurchaseItemsTableFilterComposer,
    $$PurchaseItemsTableOrderingComposer,
    $$PurchaseItemsTableAnnotationComposer,
    $$PurchaseItemsTableCreateCompanionBuilder,
    $$PurchaseItemsTableUpdateCompanionBuilder,
    (PurchaseItem, $$PurchaseItemsTableReferences),
    PurchaseItem,
    PrefetchHooks Function({bool purchaseId, bool partId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SystemConfigsTableTableManager get systemConfigs =>
      $$SystemConfigsTableTableManager(_db, _db.systemConfigs);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$PartCategoriesTableTableManager get partCategories =>
      $$PartCategoriesTableTableManager(_db, _db.partCategories);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$CustomerLedgerEntriesTableTableManager get customerLedgerEntries =>
      $$CustomerLedgerEntriesTableTableManager(_db, _db.customerLedgerEntries);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$RoutesTableTableManager get routes =>
      $$RoutesTableTableManager(_db, _db.routes);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$ReturnClaimsTableTableManager get returnClaims =>
      $$ReturnClaimsTableTableManager(_db, _db.returnClaims);
  $$ReturnClaimItemsTableTableManager get returnClaimItems =>
      $$ReturnClaimItemsTableTableManager(_db, _db.returnClaimItems);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
}
