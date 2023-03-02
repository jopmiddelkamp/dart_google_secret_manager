import 'dart:async';
import 'dart:convert';

import 'package:googleapis/secretmanager/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

/// This class is used to access the Google Secret Manager API.
abstract class GoogleSecretManager {
  /// This method initializes the [GoogleSecretManager] instance via the given
  /// service account JSON credentials.
  ///
  /// https://developers.google.com/workspace/guides/create-credentials#service-account
  static Future<void> initViaServiceAccountJson(
    String serviceAccountJson, {
    List<String>? scopes,
    http.Client? httpClient,
  }) async {
    final jsonData = jsonDecode(serviceAccountJson);
    final projectId = jsonData['project_id'];
    if (projectId == null) {
      throw Exception('No project_id present in the service account json');
    }

    final credentials = ServiceAccountCredentials.fromJson(jsonData);

    final client = await clientViaServiceAccount(
      credentials,
      [
        if (scopes != null && scopes.isNotEmpty)
          ...scopes
        else
          SecretManagerApi.cloudPlatformScope,
      ],
      baseClient: httpClient ?? http.Client(),
    );
    GoogleSecretManager.instance = _GoogleSecretManagerImpl._(
      SecretManagerApi(client),
      projectId: projectId,
    );
  }

  /// This call returns the secret data.
  ///
  /// Request parameters:
  ///
  /// [name] - Required. The resource name of the SecretVersion.

  /// [version] - The resource version of the SecretVersion. If not provided, the latest version will be used.
  ///
  /// Completes with a [AccessSecretVersionResponse].
  ///
  /// Completes with a [commons.ApiRequestError] if the API endpoint returned an error.
  ///
  /// If the used [http.Client] completes with an error when making a REST call, this method will complete with the same error.
  Future<AccessSecretVersionResponse> get(
    String name, {
    String? version,
    String? projectId,
  });

  static GoogleSecretManager? _instance;

  /// This method is used to set the [GoogleSecretManager] instance.
  static set instance(GoogleSecretManager? instance) {
    _instance = instance;
  }

  /// This method is used to get the [GoogleSecretManager] instance.
  static GoogleSecretManager get instance {
    if (_instance == null) {
      throw Exception(
        'GoogleSecretManager is not initialized. You have to call GoogleSecretManager.initWithServiceAccount(...) first.',
      );
    }
    return _instance!;
  }
}

class _GoogleSecretManagerImpl implements GoogleSecretManager {
  _GoogleSecretManagerImpl._(
    SecretManagerApi api, {
    required String projectId,
  }) {
    if (GoogleSecretManager._instance != null) {
      throw Exception('GoogleSecretManager is already initialized');
    }
    _api = api;
    _projectId = projectId;
  }

  late SecretManagerApi _api;

  late String _projectId;

  @override
  Future<AccessSecretVersionResponse> get(
    String name, {
    String? version,
    String? projectId,
  }) async {
    final path =
        'projects/${projectId ?? _projectId}/secrets/$name/versions/${version ?? 'latest'}';
    final result = await _api.projects.secrets.versions.access(path);
    return result;
  }
}
