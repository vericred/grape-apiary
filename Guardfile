# More info at https://github.com/guard/guard#readme

guard 'rspec', cmd: 'bundle exec rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }
  watch(%r{spec/support/.*}) { "spec" }
end

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end
