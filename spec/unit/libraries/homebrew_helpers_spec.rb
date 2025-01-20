# frozen_string_literal: true

require 'spec_helper'
require 'chef/mixin/shell_out'

describe HomebrewHelper do
  let(:opt_homebrew_path) { '/opt/homebrew' }
  let(:usr_local_homebrew_path) { '/usr/local' }
  let(:usr_local_repository_path) { '/usr/local/Homebrew' }

  let(:shellout) do
    double(command: 'sysctl -n hw.optional.arm64', run_command: nil, error!: nil, stdout: arm64_test_output,
           stderr: stderr, exitstatus: exitstatus, live_stream: nil)
  end

  before(:each) do
    allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
    allow(shellout).to receive(:live_stream=).and_return(nil)
  end

  context 'when on Apple arm64 Silicon' do
    let(:arm64_test_output) { "1\n" }
    let(:exitstatus) { 0 }
    let(:stderr) { double(empty?: true) }

    describe '#install_path' do
      let(:dummy_class) { Class.new { include Homebrew } }
      it 'returns /opt/homebrew path' do
        expect(dummy_class.new.install_path).to eq opt_homebrew_path
      end
    end

    describe '#repository_path' do
      let(:dummy_class) { Class.new { include Homebrew } }
      it 'returns /opt/homebrew path' do
        expect(dummy_class.new.repository_path).to eq opt_homebrew_path
      end
    end
  end

  context 'when on Apple Intel Silicon' do
    let(:arm64_test_output) { '' }
    let(:exitstatus) { 1 }
    let(:stderr) { 'sysctl: unknown oid \'hw.optional.arm64\'' }

    describe '#install_path' do
      let(:dummy_class) { Class.new { include Homebrew } }
      it 'returns /usr/local path' do
        expect(dummy_class.new.install_path).to eq usr_local_homebrew_path
      end
    end

    describe '#install_path' do
      let(:dummy_class) { Class.new { include Homebrew } }
      it 'returns /usr/local/Homebrew path' do
        expect(dummy_class.new.repository_path).to eq usr_local_repository_path
      end
    end
  end
end
