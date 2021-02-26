# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
# add pods for desired Firebase products
# https://firebase.google.com/docs/ios/setup#available-pods
  # Pods for CovidMVVM

def install_pods
  pod 'FSCalendar'
  pod 'CalculateCalendarLogic'
  pod 'Charts'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'MessageKit'
  pod 'MessageInputBar'
  pod 'PKHUD'
  pod 'SwiftyJSON'
  pod 'Moya/RxSwift', '~> 14.0'
  pod 'RxSwift'
  pod 'RxDataSources'
  pod 'RxCocoa'
  pod 'RealmSwift'
  pod 'Instantiate'
  pod 'InstantiateStandard'

end

def install_test_pods
  pod 'Quick'
  pod 'Nimble'
  pod 'RxTest'
end

target 'CovidMVVM' do
    install_pods
    
    target 'CovidMVVMTests' do
      inherit! :search_paths
      install_test_pods
      # Pods for testing
    end

    target 'CovidMVVMUITests' do
      inherit! :search_paths
      install_test_pods
      # Pods for testing
    end

end




post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['Validator'].include? target.name or ['SwiftyAttributes'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
                config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
                config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
            end
        else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
                config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
                config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
            end
        end
        installer.pods_project.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end
end
