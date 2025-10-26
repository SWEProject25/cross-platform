// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationsAPIService)
const notificationsAPIServiceProvider = NotificationsAPIServiceProvider._();

final class NotificationsAPIServiceProvider
    extends
        $FunctionalProvider<
          NotificationsAPIService,
          NotificationsAPIService,
          NotificationsAPIService
        >
    with $Provider<NotificationsAPIService> {
  const NotificationsAPIServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsAPIServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsAPIServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationsAPIService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationsAPIService create(Ref ref) {
    return notificationsAPIService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationsAPIService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationsAPIService>(value),
    );
  }
}

String _$notificationsAPIServiceHash() =>
    r'266289ebd8ac2efd2cae7dac99f9b3d0c0c6397a';
