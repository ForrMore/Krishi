
struct KRSHI {
    
    static let appName = "Krishi"
    static let cellIdentifier = "CellCommodity"
    static let cellNibName = "CellCommodity"
    static let jsonFileName:[String] = ["Commodity","json"]
    static let baseUrl : String = "https://forrmore.000webhostapp.com/api/v1/"
    
    struct Url {
        static let updateUser = KRSHI.self.baseUrl+"update_user.php"
        static let createUser = KRSHI.self.baseUrl+"create_user_db.php"
        static let createAuth = KRSHI.self.baseUrl+"create_auth.php"
        static let verifyUser =  KRSHI.self.baseUrl+"verify_auth.php"
        static let updateCommodity = KRSHI.self.baseUrl+"user_commodity.php"
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
