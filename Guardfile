# More info at https://github.com/guard/guard#readme

guard 'rspec', cmd: 'bundle exec rspec', failed_mode: :focus  do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }
  watch(%r{spec/support/.*}) { "spec" }
  watch(%r{lib/grape-apiary/templates/.*}) { "spec/integration" }
end

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end
