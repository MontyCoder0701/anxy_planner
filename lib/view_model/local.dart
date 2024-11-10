import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import '../model/repository/local.dart';
import 'google_auth.dart';

class DataPersistenceManager {
  DataPersistenceManager._();

  static const fileName = 'one-moon-backup-v2';
  static const fileType = 'application/octet-stream';

  static final DataPersistenceManager _instance = DataPersistenceManager._();

  static DataPersistenceManager get instance => _instance;

  Future<drive.File> backupToGoogleDrive() async {
    final googleSignIn =
        GoogleSignIn(scopes: [drive.DriveApi.driveAppdataScope]);
    final googleAccount =
        await googleSignIn.signInSilently() ?? await googleSignIn.signIn();

    if (googleAccount == null) {
      throw Exception('No Google Account');
    }

    final googleAuthClient =
        GoogleAuthClient(header: (await googleAccount.authHeaders));
    final driveApi = drive.DriveApi(googleAuthClient);
    final databaseFile = await LocalRepository.getEncryptedDatabaseFile();

    final uploadDriveFile = drive.File(
      parents: ['appDataFolder'],
      name: fileName,
      mimeType: fileType,
    );

    final allFiles = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: 'name = "$fileName" and mimeType = "$fileType" and trashed = false',
    );

    final foundFile = allFiles.files?.firstOrNull;
    if (foundFile == null) {
      return await driveApi.files.create(
        uploadDriveFile,
        uploadMedia: drive.Media(
          databaseFile.openRead(),
          databaseFile.lengthSync(),
        ),
      );
    }

    return await driveApi.files.update(
      uploadDriveFile,
      foundFile.id!,
      uploadMedia: drive.Media(
        databaseFile.openRead(),
        databaseFile.lengthSync(),
      ),
    );
  }

  Future<void> restoreFromGoogleDrive() async {
    final googleSignIn =
        GoogleSignIn(scopes: [drive.DriveApi.driveAppdataScope]);
    final googleAccount =
        await googleSignIn.signInSilently() ?? await googleSignIn.signIn();

    if (googleAccount == null) {
      throw Exception('No Google Account');
    }

    final googleAuthClient =
        GoogleAuthClient(header: (await googleAccount.authHeaders));
    final driveApi = drive.DriveApi(googleAuthClient);
    final allFiles = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: 'name = "$fileName" and mimeType = "$fileType" and trashed = false',
    );

    final foundFile = allFiles.files?.firstOrNull;
    if (foundFile == null || foundFile.id == null) {
      throw Exception('No Backed Up File');
    }

    final downloadedFile = await driveApi.files.get(
      foundFile.id!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    await LocalRepository.overwrite(downloadedFile);
  }
}
