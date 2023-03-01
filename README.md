This package provides an API for accessing Google Secret Manager using Dart. The package allows users to initialize a `GoogleSecretManager` instance with service account JSON credentials, set and get the instance, and call a `get(secretName)` method to retrieve the secret data. The package uses the `googleapis` and `googleapis_auth` packages to authenticate the API requests and the `http` package to make HTTP requests. This package is useful for developers who want to securely store and retrieve secrets in their Dart applications using Google Secret Manager.

## Getting started

First [create a service account](https://developers.google.com/workspace/guides/create-credentials#create_a_service_account) and download the JSON key file.

Then, add this package to your pubspec.yaml file:
```yaml
dependencies:
  google_secret_manager:
```

## Usage

To use the `GoogleSecretManager` class, you first need to initialize it via the `GoogleSecretManager.initViaServiceAccountJson` method and passing the downloaded JSON key file as a string:
```dart
final path = '${Directory.current.path}/service-account.json';
final json = File(path).readAsStringSync();
await GoogleSecretManager.initViaServiceAccountJson(json);
```

Then, you can access the secret value by calling the `GoogleSecretManager.get` method:
```dart
final response = await GoogleSecretManager.instance.get('secret-name');
```

For more information you can see a full example in the `example` folder.

## Additional information

If you're interested in contributing to the development of this package, I welcome your contributions! One way to do so is by submitting a pull request (PR) on our GitHub repository.

To get started, you'll need to fork the repository to your own GitHub account. Then, make your changes or additions in a new branch on your forked repository. Once you've made your changes, you can submit a pull request to my main repository.

We encourage you to include a detailed description of your changes, along with any relevant documentation and tests. I will review your pull request and provide feedback as needed.
