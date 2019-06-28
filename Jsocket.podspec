Pod::Spec.new do |s|
    s.name             = 'Jsocket'
    s.version          = '0.1.3'
    s.summary          = 'Jsocket. 一个websocket 封装'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/lywsbcn/Jsocket'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'lywsbcn' => '89324055@qq.com' }
    s.source           = { :git => 'https://github.com/lywsbcn/Jsocket.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '9.0'
    
    s.source_files = 'Jsocket/Classes/**/*'
    
    # s.resource_bundles = {
    #   'Jpost' => ['Jpost/Assets/*.png']
    # }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    s.library = 'icucore'
     s.dependency 'YYModel'
end
