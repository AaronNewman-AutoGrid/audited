ENV['RAILS_ENV'] = 'test'

require 'protected_attributes'
require 'rails_app/config/environment'
require 'rspec/rails'
require 'audited'
require 'audited_spec_helpers'
require 'rspec-activemodel-mocks'
require 'byebug'

SPEC_ROOT = Pathname.new(File.expand_path('../', __FILE__))

Dir[SPEC_ROOT.join('support/*.rb')].each{|f| require f }

RSpec.configure do |config|
  config.include AuditedSpecHelpers
  config.before(:each, :adapter => :active_record) do
    Audited.audit_class = Audited::Adapters::ActiveRecord::Audit
  end

  config.before(:each, :adapter => :mongo_mapper) do
    Audited.audit_class = Audited::Adapters::MongoMapper::Audit
  end

  config.before(:each) do
    x = mock_model('DROMS')
    stub_const('Audited::Auditor::AuditedInstanceMethods::Edp::Settings', x)
    allow(x).to receive(:get).and_return({:name => 'DROMS'})
  end

  config.before(:each) do
    y = mock_model('DROMS')
    stub_const('Audited::Auditor::AuditedInstanceMethods::User', y)
    allow(y).to receive(:current).and_return(nil)
  end

  config.before(:each) do
    allow_any_instance_of(Audited::Auditor::AuditedInstanceMethods).to receive(:publish) {'stubbed'}
  end

end
