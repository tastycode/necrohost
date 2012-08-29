class UserWantsTheServerToBeSleepy < Spinach::FeatureSteps
  Given 'the application is configured to bypass sleeping' do
    sleeper = Mocha::Mock
    Necrohost::Server.dependencies[:sleep] = sleeper.stubs(:sleep => nil)
  end

  And 'I go to the url for sleeping for 5 seconds' do
    Timeout::timeout(1) do
      visit "/sleep/5"
    end
  end

  Then 'the result should mention how much I slept' do
    page.has_content?("5 seconds").must_equal true
  end
end
