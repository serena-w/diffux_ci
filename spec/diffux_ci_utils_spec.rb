require 'diffux_ci_utils'

describe 'DiffuxCIUtils' do
  before do
    allow(DiffuxCIUtils).to receive(:config_from_file).and_return({})
  end

  describe 'construct_url' do
    subject { DiffuxCIUtils.construct_url(absolute_path, params) }

    context 'without absolute_path or params' do
      let(:absolute_path) { '' }
      let(:params) { {} }
      it { should eq('http://localhost:4567') }
    end

    context 'with absolute_path and no params' do
      let(:absolute_path) { '/alexander-hamilton' }
      let(:params) { {} }
      it { should eq('http://localhost:4567/alexander-hamilton') }
    end

    context 'with params and no absolute_path' do
      let(:absolute_path) { '' }
      let(:params) { { revolution: 'yes', burr: 'no' } }
      it { should eq('http://localhost:4567?revolution=yes&burr=no') }
    end

    context 'with params and absolute_path' do
      let(:absolute_path) { '/alexander-hamilton' }
      let(:params) { { revolution: 'yes', burr: 'no' } }
      it do
        should eq(
          'http://localhost:4567/alexander-hamilton?revolution=yes&burr=no')
      end
    end

    context 'when params have special characters' do
      let(:absolute_path) { '' }
      let(:params) { { revolution: 'yes & absolutely' } }
      it { should eq('http://localhost:4567?revolution=yes+%26+absolutely') }
    end
  end

  describe 'normalize_description' do
    subject { DiffuxCIUtils.normalize_description(description) }

    context 'with special characters' do
      let(:description) { '<MyComponent> something interesting' }
      it { should eq('_MyComponent__something_interesting') }
    end
  end

  describe 'path_to' do
    subject { DiffuxCIUtils.path_to(description, viewport_name, file_name) }
    let(:description) { '<MyComponent>' }
    let(:viewport_name) { 'large' }
    let(:file_name) { 'diff.png' }
    it { should eq('./snapshots/_MyComponent_/@large/diff.png') }
  end
end