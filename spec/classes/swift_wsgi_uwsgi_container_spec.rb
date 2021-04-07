require 'spec_helper'

describe 'swift::wsgi::uwsgi_container' do

  shared_examples 'swift::wsgi::uwsgi_container' do
    context 'with default parameters' do
      it {
        should contain_class('swift::deps')
      }

      it {
        is_expected.to contain_swift_container_uwsgi_config('uwsgi/processes').with_value(facts[:os_workers])
        is_expected.to contain_swift_container_uwsgi_config('uwsgi/listen').with_value('100')
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers => 8,
        }))
      end
      it_behaves_like 'swift::wsgi::uwsgi_container'
    end
  end
end
