require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
  it { should validate_length_of(:username).is_at_least(3).is_at_most(12) }

  describe "#validate_username_regex" do
  	# Creo usuarios con la ayuda de factoryGirl, el parametro de build, hace referencia al nombre
  	# del metodo a buscar en el factory.
  	let(:user){FactoryGirl.build(:user)}

  	it "should not allow username with numbers at the beginning" do
  		user.username = "99ronaldo"
  		# valid? => false
  		# errors => no este vacio
  		# errors.full_messages => El username debe iniciar con una letra
  		expect(user.valid?).to be_falsy # falsy es false o nil
  	end

  	it "should not contain special characters" do
  		user.username = "ronaldo*"
  		expect(user.valid?).to be_falsy
  	end
  end
end
 