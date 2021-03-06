require 'rails_helper'

RSpec.describe User, type: :model do
  let(:form_no_first_name) {User.new(last_name: 'Calvo', email:'ovi@gmail.com', password: '12345678')}
  let(:form_no_last_name)  {User.new(first_name: 'Ovi', email:'ovi@gmail.com', password: '12345678')}
  let(:form_no_email)  {User.new(first_name: 'Ovi', last_name: 'Calvo', password: '12345678')}
  let(:form_no_password)  {User.new(first_name: 'Ovi', last_name: 'Calvo', email: 'ovi@gmail.com')}

  let(:form)  {User.new(id: 50, first_name: 'Ovi', last_name: 'Calvo', email: 'ovi222@gmail.com', password: '12345678')}

  let(:form2)  {User.create(id: 51, first_name: 'Ovi', last_name: 'Calvo', email: 'ovi222@gmail.com', password: '12345678')}
  let(:measurement_for_form) {Measurement.create(gender: "male", chest: 30, measurable_type: "User", measurable_id: 51)}

  let(:product)  {Product.create(id: 30, title: "Vintage 1950s Jacket", url: "https://www.etsy.com/listing/268514567/vintage-1950s-jacket-mulberry-wool?ref=shop_home_active_6")}
  let(:measurement_for_product) {Measurement.create(gender: "male", chest: 31, measurable_type: "Product", measurable_id: 30)}

  describe 'validations' do
    context 'will raise an error' do
      it 'when the first_name field is empty' do
      	form_no_first_name.save
      	expect(form_no_first_name.errors[:first_name]).to include("can't be blank")
      end
      it 'when the last_name field is empty' do
      	form_no_last_name.save
      	expect(form_no_last_name.errors[:last_name]).to include("can't be blank")
      end
      it 'when the email field is empty' do
      	form_no_email.save
      	expect(form_no_email.errors[:email]).to include("can't be blank")
      end
      it 'when the password field is empty' do
      	form_no_password.save
  	expect(form_no_password.errors[:password]).to include("can't be blank")
      end
      it 'saves the user when the fields are not blank' do
      	expect{form.save}.to change{User.count}.by(1)
      end
    end
  end

  describe 'associations' do
    it 'should have one measurement' do
      t = User.reflect_on_association(:measurement)
      t.macro.should == :has_one
    end
  end

  describe 'instance method' do
    # test_array is an array containing the instantiation of product
    let(:test_array) { Array.new(1) { product } }

    it 'the first_name method words for the User object' do
      expect(form2.first_name).to eq("Ovi")
    end

    it 'the measurement.gender method works for the User object' do
      form2.measurement = measurement_for_form
      expect(form2.measurement).to be_kind_of(Measurement)
    end

    it 'should return array of matched products' do
      form2.measurement = measurement_for_form
      product.measurement = measurement_for_product
      expect(form2.match).to eq(test_array)
    end
  end

end
