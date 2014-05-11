describe <%= project_namespace %>::Version do

  it 'defines MAJOR' do
    expect(subject::MAJOR).to be_a(Numeric)
    expect(subject::MAJOR).to be >= 0
  end

  it 'defines MINOR' do
    expect(subject::MINOR).to be_a(Numeric)
    expect(subject::MINOR).to be >= 0
  end

  it 'defines PATCH' do
    expect(subject::PATCH).to be_a(Numeric)
    expect(subject::PATCH).to be >= 0
  end

end
