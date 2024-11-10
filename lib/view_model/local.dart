import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:path/path.dart';

import '../model/repository/local.dart';
import 'google_auth.dart';

class DataPersistenceManager {
  DataPersistenceManager._();

  static final DataPersistenceManager _instance = DataPersistenceManager._();

  static DataPersistenceManager get instance => _instance;

  Future<File> backupToGoogleDrive() async {
    final googleSignIn = GoogleSignIn(scopes: [DriveApi.driveAppdataScope]);
    final googleAccount =
        await googleSignIn.signInSilently() ?? await googleSignIn.signIn();

    if (googleAccount == null) {
      throw Exception('No Google Account');
    }

    final googleAuthClient =
        GoogleAuthClient(header: (await googleAccount.authHeaders));
    final driveApi = DriveApi(googleAuthClient);
    final databaseFile = await LocalRepository.encryptedDatabaseFile;

    final uploadDriveFile = File(
      parents: ['appDataFolder'],
      name: basename(databaseFile.absolute.path),
    );

    return await driveApi.files.create(
      uploadDriveFile,
      uploadMedia: Media(
        databaseFile.openRead(),
        databaseFile.lengthSync(),
      ),
    );
  }
}
