Pod::Spec.new do |s|
  s.name         = "KRHebbian"
  s.version      = "1.3.0"
  s.summary      = "Non-supervisor that Hebbian self-organization learning method in machine learning. (自分学習アルゴリズム)."
  s.description  = <<-DESC
                   KRHebbian implemented Hebbian algorithm that is a non-supervisor of self-organization algorithm of Machine Learning (自分学習アルゴリズム).
                   DESC
  s.homepage     = "https://github.com/Kalvar/ios-KRHebbian-Algorithm"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Kalvar Lin" => "ilovekalvar@gmail.com" }
  s.social_media_url = "https://twitter.com/ilovekalvar"
  s.source       = { :git => "https://github.com/Kalvar/ios-KRHebbian-Algorithm.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.public_header_files = 'KRHebbian/*.h'
  s.source_files = 'KRHebbian/*.{h,m}'
  s.frameworks   = 'Foundation'
end 