

import UIKit

class HomeViewController : UIViewController {
    
  // Outlet
    
    
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var UISellerView: UIView!
    @IBOutlet weak var UIBuyerView: UIView!
    @IBOutlet weak var UIMandiRatesView: UIView!
    @IBOutlet weak var UIAgriculturalNewsView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var buyerInnerView: UIView!
    @IBOutlet weak var newsInnerView: UIView!
    
    @IBOutlet weak var weatherImagebackgroundImage: UIImageView!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var HomeChatButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var UIBuyButton: UIButton!
    @IBOutlet weak var UIMarketRateButton: UIButton!
    @IBOutlet weak var UISellButton: UIButton!
    @IBOutlet weak var UIAgricultureNewsButton: UIButton!
    @IBOutlet weak var contactsButton: UIButton!
    //
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureDescription: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var humadityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var dayTimeLabel: UILabel!
    
    // Global variables
    var commodityData : String!
    @IBOutlet var wellcomeLabel: UILabel!
    
    
    var userData = UserData()
    var weatherManager = WeatherManager()
    
    // view didload
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        updateWeatherData()
        viewUpdates()
    }

    func updateWeatherData(){
        let district = userData.getUserDefaults("District") as! String
        weatherManager.fetchWeatherData(city: district)
        cityLabel.text = (userData.getUserDefaults("District") as! String)
        stateLabel.text = (userData.getUserDefaults("State") as! String)
        temperatureDescription.layer.cornerRadius = 5
        reloadInputViews()
        
    }
    
    
    //HOme view controller life cycle
    override func viewWillAppear(_ animated: Bool) {
//        self.viewDidLoad()
//        self.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(true)
    }
    //
    
    // UIView Stuff
    func  viewUpdates() {
        
        let username = userData.getUserDefaults("UserName") as! String
        wellcomeLabel.text = "Welcome "+username
        dayTimeLabel.text = DateTimeManager().weatherDate
        
        
        weatherView.dropShadow()
        UISellerView.dropShadow()
        UIMandiRatesView.dropShadow()
        UIAgriculturalNewsView.dropShadow()
        UIBuyerView.dropShadow()
        
        buyerInnerView.layer.cornerRadius = 10
        newsInnerView.layer.cornerRadius = 10
        
        // post Button
        postButton.dropShadow()
        postButton.layer.shadowColor = UIColor.black.cgColor
        postButton.layer.cornerRadius = 25
       
        //chatButton
        chatButton.dropShadow()
        chatButton.layer.shadowColor = UIColor.white.cgColor
        chatButton.layer.cornerRadius = 25
        chatButton.layer.shadowOpacity = 1
        chatButton.layer.shadowRadius = 10
        chatButton.layer.borderWidth = 2
        chatButton.layer.borderColor = UIColor.black.cgColor
        
        
        // contacts
        contactsButton.dropShadow()
        contactsButton.layer.shadowColor = UIColor.white.cgColor
        contactsButton.layer.cornerRadius = 25
        contactsButton.layer.shadowOpacity = 1
        contactsButton.layer.shadowRadius = 10
        contactsButton.layer.borderWidth = 2
        contactsButton.layer.borderColor = UIColor.black.cgColor
        
        
        weatherImagebackgroundImage.layer.cornerRadius = 10
//        tabBarView.layer.s
        
        // UIbuy Button
        UIBuyButton.dropShadow()
        UIBuyButton.layer.cornerRadius = 15
        
        // UIsell Button
        UISellButton.dropShadow()
        UISellButton.layer.cornerRadius = 15
        
        // UIMarket Button
        UIMarketRateButton.dropShadow()
        UIMarketRateButton.layer.cornerRadius = 15
        
        // UI news Button
        UIAgricultureNewsButton.dropShadow()
        UIAgricultureNewsButton.layer.cornerRadius = 15
        
        weatherView.dropShadow()
    }
}
//MARK: -  UIView
extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension HomeViewController : WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager : WeatherManager ,weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.minTemperatureLabel.text = String(weather.min_temperatureString)
            self.maxTemperatureLabel.text = String(weather.max_temperatureString)
            self.humadityLabel.text = String(weather.humadity)
            self.windLabel.text = String(weather.wind)
            self.temperatureDescription.text = weather.descriptionString
        }
    }

    func didFailWithError(_ error: Error) {
        print(error)
    }
}
