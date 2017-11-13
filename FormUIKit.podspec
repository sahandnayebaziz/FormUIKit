Pod::Spec.new do |s|
  s.name             = "FormUIKit"
  s.version          = "0.1.6"
  s.summary          = "Create UITableView-based forms for text input, object selection, and more with little work."
  s.description      = "This allows you to create UITableView-based forms for text input, object selection, and more with little work."

  s.homepage         = "https://github.com/sahandnayebaziz/FormUIKit"
  s.license          = 'MIT'
  s.author           = { "sahandnayebaziz" => "sahand@sahand.me" }
  s.source           = { :git => "https://github.com/sahandnayebaziz/FormUIKit.git", :tag => s.version.to_s }

  s.ios.deployment_target  = '10.0'

  s.source_files = 'FormUIKit/Sources/**/*.swift'
  s.dependency 'SnapKit', '> 4'
end
