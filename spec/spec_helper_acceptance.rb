require 'beaker-rspec'
require 'pry'

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.expect_with :rspec do |c2|
    c2.syntax = :expect
  end

  c.before :suite do
    # Install module to all hosts
    hosts.each do |host|
      install_puppet_on(host)

      install_dev_puppet_module_on(host, :source => module_root, :module_name => 'secc_sshd')
      # Install dependencies
      on(host, puppet('module', 'install', 'puppetlabs-stdlib'))
      # Add more setup code as needed
    end
  end
end
