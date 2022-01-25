
struct K {
    
    static let appName = "Krishi"
    static let cellIdentifier = "CellCommodity"
    static let cellNibName = "CellCommodity"
    static let jsonFileName:[String] = ["Commodity","json"]
    static let ip : String = "http://192.168.1.4:8080/"
    
    struct Url {
        static let updateUser = K.self.ip+"krishi_app/v1/update_user.php"
        static let createUser = K.self.ip+"krishi_app/v1/create_user_db.php"
        static let createAuth = K.self.ip+"krishi_app/v1/create_auth.php"
        static let verifyUser =  K.self.ip+"krishi_app/v1/verify_auth.php"
        static let updateCommodity = K.self.ip+"krishi_app/v1/user_commodity.php"
    }
    
    struct GoTo {
        static let otpVC = "goToOtpVC" 
        static let homeScreenVC = "goToHomeScreen"
        static let personalDetailVC = "goToPersonalDetail"
        static let currentLocation = "goToCurrentLocation"
        static let SelectedCommodity = "goToSelectedCommodity"
    }
    
    struct BrandColor {
        static let lightGreen = "lightPrimaryColor"
        static let green = "primaryColor"
        static let darkGreen = "darkPrimaryColor"
        static let sText = "secondaryTextColor"
        static let accentColor = "accentColor"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        static let name = "personName"
    }
    
    struct WeatherUrl {
        static let api = "https://api.openweathermap.org/data/2.5/weather?appid=6ca15dffd42c2d6172c41565b5dc7a89&units=metric"
    }
}
