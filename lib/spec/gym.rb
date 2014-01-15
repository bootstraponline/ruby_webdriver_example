describe 'gymnasium tests' do
  t 'verify homepage exists' do
    gym.goto
    gym.sign_in
    gym.user_name = 'example user' # type text into textfield

    # check that the text matches what we just entered
    raise unless gym.user_name_element.value == 'example user'
    # check that the element exists
    raise unless gym.user_name?

    gym.password = 'password'
    gym.submit_sign_in
  end
end