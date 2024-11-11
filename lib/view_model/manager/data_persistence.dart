import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

import '../../model/repository/local.dart';
import '../client/google_auth.dart';

class DataPersistenceManager {
  static const _fileName = 'one-moon-backup';
  static const _fileType = 'application/octet-stream';

  static Future<bool> backupToGoogleDrive() async {
    final googleSignIn = GoogleSignIn(scopes: [DriveApi.driveAppdataScope]);
    final googleAccount =
        await googleSignIn.signInSilently() ?? await googleSignIn.signIn();

    if (googleAccount == null) {
      return false;
    }

    final googleAuthClient =
        GoogleAuthClient(header: (await googleAccount.authHeaders));
    final driveApi = DriveApi(googleAuthClient);
    final databaseFile = await LocalRepository.getEncryptedDatabaseFile();

    final uploadDriveFile = File(
      name: _fileName,
      mimeType: _fileType,
    );

    final allFiles = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: 'name = "$_fileName" and mimeType = "$_fileType" and trashed = false',
    );

    final foundFile = allFiles.files?.firstOrNull;
    if (foundFile == null) {
      await driveApi.files.create(
        uploadDriveFile..parents = ['appDataFolder'],
        uploadMedia: Media(
          databaseFile.openRead(),
          databaseFile.lengthSync(),
        ),
      );
      return true;
    }

    await driveApi.files.update(
      uploadDriveFile,
      foundFile.id!,
      uploadMedia: Media(
        databaseFile.openRead(),
        databaseFile.lengthSync(),
      ),
    );
    return true;
  }

  static Future<bool> restoreFromGoogleDrive() async {
    final googleSignIn = GoogleSignIn(scopes: [DriveApi.driveAppdataScope]);
    final googleAccount =
        await googleSignIn.signInSilently() ?? await googleSignIn.signIn();

    if (googleAccount == null) {
      return false;
    }

    final googleAuthClient =
        GoogleAuthClient(header: (await googleAccount.authHeaders));
    final driveApi = DriveApi(googleAuthClient);

    final allFiles = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: 'name = "$_fileName" and mimeType = "$_fileType" and trashed = false',
    );

    final foundFile = allFiles.files?.firstOrNull;
    if (foundFile == null || foundFile.id == null) {
      throw NoBackupFileException();
    }

    final downloadedFile = await driveApi.files.get(
      foundFile.id!,
      downloadOptions: DownloadOptions.fullMedia,
    ) as Media;

    await LocalRepository.overwrite(downloadedFile);
    return true;
  }
}

class NoBackupFileException implements Exception {
  final String message;

  NoBackupFileException([this.message = 'no-backup-file']);
}
