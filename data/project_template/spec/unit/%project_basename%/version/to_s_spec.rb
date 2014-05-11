describe <%= project_namespace %>::Version, '#to_s' do

  it 'is a valid version string' do
    expect(subject.to_s).to match(/^\d+\.\d+\.\d+$/)
  end

end
