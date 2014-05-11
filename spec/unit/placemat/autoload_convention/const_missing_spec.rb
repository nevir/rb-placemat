describe Placemat::AutoloadConvention, '#const_missing' do

  let(:namespace) do
    module Fixtures::AutoloadConvention; end
    Fixtures::AutoloadConvention.extend(subject)

    Fixtures::AutoloadConvention
  end

  after(:each) do
    if defined? Fixtures::AutoloadConvention
      Fixtures.send(:remove_const, :AutoloadConvention)
    end
  end

  it 'should raise a LoadError when referencing an unknown constant' do
    expect { namespace::Foo }.to raise_error(LoadError)
  end

  it 'should raise a NameError when the wrong constant is defined' do
    expect { namespace::Mismatched }.to raise_error(NameError)
  end

  it 'should load single-token files' do
    expect_load('fixtures/autoload_convention/single.rb')
    expect(namespace::Single).to be_a(Class)
  end

  it 'should load multi-token files' do
    expect_load('fixtures/autoload_convention/multi_token.rb')
    expect(namespace::MultiToken).to be_a(Class)
  end

  it "shouldn't split ACRONYMS" do
    expect_load('fixtures/autoload_convention/allcaps.rb')
    expect(namespace::ALLCAPS).to eq(:yelling)
  end

  it 'should split ACRONYMSEndingWithRegularNames' do
    expect_load('fixtures/autoload_convention/abc_one_two_three.rb')
    expect(namespace::ABCOneTwoThree).to be_a(Class)
  end

  it "shouldn't pick up constants in parent namespaces" do
    expect_load('fixtures/autoload_convention/string.rb')
    expect(namespace::String).to be_a(Class)
    expect(namespace::String).to_not eq(::String)
  end

  # Utility

  def expect_load(path)
    namespace.should_receive(:load).with(path).and_call_original
  end

end
