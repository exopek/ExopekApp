class StoragePath {
  static String profilImage(String uid) => 'profilImage/$uid';
}


class CloudPath {
  static String setfavorite(String uid, String id) => 'users/$uid/favorites/$id';
  static String getfavorite(String uid) => 'users/$uid/favorites/';
  static String getworkouts() => 'videos/';
  static String setroutine(String uid, String id) => 'users/$uid/routines/$id';
  static String getroutine(String uid) => 'users/$uid/routines/';
  static String getroutineinput(String uid, String id) => 'users/$uid/routines/';
  static String getlegworkouts() => 'Beine/';
  static String getchestworkouts() => 'Brust/';
  static String getallworkouts() => 'Alle/';
  static String getcatergories() => 'kategorien/';
  static String getfunctionalworkouts() => 'functionalWorkouts/';
}