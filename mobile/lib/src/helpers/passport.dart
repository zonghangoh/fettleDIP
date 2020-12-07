class Passport {
  static String getCountryFlag(String country) {
    switch (country) {
      case 'Singapore':
        return 'assets/singapore.png';
      case 'Japan':
        return 'assets/japan.png';
      case 'Hawaii':
        return 'assets/hawaii.png';
      default:
        return 'assets/singapore.png';
    }
  }

  static String getCountryBG(String country) {
    switch (country) {
      case 'Singapore':
        return 'assets/SingaporeBG.png';
      case 'Japan':
        return 'assets/JapanBG.png';
      case 'Hawaii':
        return 'assets/HawaiiBG.png';
      default:
        return 'assets/SingaporeBG.png';
    }
  }

  static String getCountryChatBG(String country) {
    switch (country) {
      case 'Singapore':
        return 'assets/SingaporeBGchat.png';
      case 'Japan':
        return 'assets/JapanBGchat.png';
      case 'Hawaii':
        return 'assets/HawaiiBGchat.png';
      default:
        return 'assets/SingaporeBGchat.png';
    }
  }
}
