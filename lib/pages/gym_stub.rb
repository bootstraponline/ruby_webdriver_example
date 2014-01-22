module Stub
  module Gym
    class << self
      def goto; end
      def sign_in; end
      def sign_in_element; end
      def sign_in?; end
      def user_name; end
      def user_name_element; end
      def user_name?; end
      def user_name= *txt; txt end
      def password; end
      def password_element; end
      def password?; end
      def password= *txt; txt end
      def submit_sign_in; end
      def submit_sign_in_element; end
      def submit_sign_in?; end
    end
  end
end

module Kernel
  def gym
    Stub::Gym
  end
end unless Kernel.respond_to? :gym