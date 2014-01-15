describe 'gymnasium tests' do
  t 'verify homepage exists' do
    gym.goto
    gym.sign_in
    gym.user_name = 'example user'
    gym.password = 'password'
    gym.submit_sign_in
  end
end