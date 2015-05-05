Pod::Spec.new do |s|
  s.name         = "KRHebbian"
  s.version      = "1.0.1"
  s.summary      = "Self learning the adjust weight method on Machine Learning."
  s.description  = <<-DESC
                   KRHebbian is a self-learning algorithm (adjust the weights) in neural network of Machine Learning (自分学習アルゴリズム).
                   DESC
  s.homepage     = "https://github.com/Kalvar/ios-KRHebbian-Algorithm"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Kalvar Lin" => "ilovekalvar@gmail.com" }
  s.social_media_url = "https://twitter.com/ilovekalvar"
  s.source       = { :git => "https://github.com/Kalvar/ios-KRHebbian-Algorithm.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.public_header_files = 'KRHebbian/*.h'
  s.source_files = 'KRHebbian/KRHebbian.h'
  s.frameworks   = 'Foundation'
end 