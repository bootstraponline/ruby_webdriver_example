module Pages
  class Gym
    include PageObject
      page_url 'http://www.thegymnasium.com/'

      button :sign_in, xpath: '//*[@id="drop001"]'

      text_field :user_name, :id => 'user_name'
      text_field :password, :css => '#loginfrm > fieldset > div.col > #user_pass'

      button :submit_sign_in, css: '#loginfrm > fieldset > div.btn-holder > input.btn'
  end
end