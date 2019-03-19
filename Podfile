platform :ios, '9.0'
inhibit_all_warnings!

target 'Calamity' do
  use_frameworks!
  
  pod 'Mantle'
  pod 'Alamofire'
  pod 'R.swift'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'GTProgressBar'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
    end
end
