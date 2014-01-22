describe 'gymnasium tests' do
  t 'verify homepage exists' do
    gym.goto
    gym.sign_in
    gym.user_name = 'example user' # type text into textfield

    gym.user_name_element.value.must_equal 'example user' # verify value
    gym.user_name?.must_equal true # verify existence

    gym.password = 'password'
    gym.submit_sign_in
  end
end