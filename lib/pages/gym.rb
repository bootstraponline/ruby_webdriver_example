module Pages
  class Gym
    def home
      @browser.get 'http://www.thegymnasium.com/'
      self
    end

    def about
      link('About').click
      self
    end

    def catalog
      link('Catalog').click
      self
    end

    def classrooms
      link('Classrooms').click
      self
    end

    def career_center
      link('Career Center').click
      self
    end

    def about
      link('About').click
      self
    end

    def faq
      link('FAQ').click
      self
    end

    def support
      link('Support').click
      self
    end

    def privacy_policy
      link('Privacy Policy').click
      self
    end

    def sign_in
      xpath('//*[@id="drop001"]').click
      self
    end

    def enter_invalid_sign_in_details
      id('user_name').clear
      id('user_name').send_keys 'some invalid username'
      css('#loginfrm > fieldset > div.col > #user_pass').send_keys 'password'
      self
    end

    def submit_sign_in
      css('#loginfrm > fieldset > div.btn-holder > input.btn').click
      self
    end

    def sign_up
      # gymnasium has multiple elements with the same ids
      # css classes also contain unnormalized spaces.
      xpath("//a[@id='drop002'][contains(normalize-space(@class),'dropdown-toggle btn btn-large')]").click
      self
    end

    def enter_invalid_sign_up_details
      css('#first_name').click
      css('#first_name').clear
      css('#first_name').send_keys 'firstName'
      css('#last_name').click
      css('#last_name').clear
      css('#last_name').send_keys 'lastName'
      css('#user_email').click
      css('#user_email').clear
      css('#user_email').send_keys 'email'
      css('#user_pass').click
      css('#user_pass').clear
      css('#user_pass').send_keys 'password'
      if not xpath("//form[@id='signupfrm']/fieldset/div[5]/div/select//option[8]").selected?
        xpath("//form[@id='signupfrm']/fieldset/div[5]/div/select//option[8]").click
      end
      self
    end

    def submit_sign_up
      input('Sign up').click
      self
    end
  end
end