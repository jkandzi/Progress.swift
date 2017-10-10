Pod::Spec.new do |s|
  s.name = 'Progress.swift'
  s.version = '0.3.0'
  s.license = 'MIT'
  s.summary = 'Instantly add beautiful progress bars to your Swift loops.'
  s.description = <<-DESC
                    Wrap any SequenceType like Arrays, Ranges etc. in your loops
                    with the Progress struct and you'll automatically get beautiful
                    progress bars.
                  DESC
  s.platform = :osx
  s.homepage = 'https://github.com/jkandzi/Progress.swift'
  s.social_media_url = 'http://twitter.com/jkandzi'
  s.authors = { 'Justus Kandzi' => "jusus.kandzi@gmail.com" }
  s.source = { :git => 'https://github.com/jkandzi/Progress.swift.git', :tag => s.version }
  s.source_files = 'Sources/*.swift'
  s.requires_arc = true
  s.osx.deployment_target = "10.9"
  s.module_name = 'Progress'
end
