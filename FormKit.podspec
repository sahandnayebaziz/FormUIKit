Pod::Spec.new do |s|
  s.name             = "FormKit"
  s.version          = "0.0.2"
  s.summary          = "Create UITableView-based forms for text input, object selection, and more with little work."
  s.description      = "This allows you to create UITableView-based forms for text input, object selection, and more with little work."

  s.homepage         = "https://github.com/sahandnayebaziz/FormKit"
  s.license          = 'MIT'
  s.author           = { "sahandnayebaziz" => "sahand@sahand.me" }
  s.source           = { :git => "https://github.com/sahandnayebaziz/FormKit.git", :tag => s.version.to_s }

  s.ios.deployment_target  = '11.0'

  s.source_files = 'FormKit/Sources/**/*.swift'
  s.dependency 'SnapKit', '> 4'
end
