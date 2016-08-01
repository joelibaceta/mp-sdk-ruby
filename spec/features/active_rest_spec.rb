require_relative '../spec_helper'
require_relative '../../lib/mercadopago'
require 'pp'
require 'colorize'


describe MercadoPago do

  class Dummy < ActiveREST::Base 
    
    set_idempotency_algorithm 'SHA256'
    
    has_rest_method create: '/dummies', idempotency: true
    has_rest_method read:   '/dummy/:id'
    has_rest_method update: '/dummy/:id' 
    
    has_strong_attribute :id,             type: Integer,    primary_key: true
    has_strong_attribute :title,          type: String
    has_strong_attribute :desc,           type: String
    has_strong_attribute :price,          type: Float
    has_strong_attribute :quantity,       type: Integer
    has_strong_attribute :uuid,           type: String,     idempotency_parameter: true
    has_strong_attribute :registered_at,  type: Date
  end
  
  let (:make_a_dummy_instance) {
    Dummy.create({
      id:       1,
      title:    "dummy",
      desc:     "Lorem Ipsum",
      price:    10.5,
      quantity: 5,
      uuid:     "bad85eb9-0713-4da7-8d36-07a8e4b00eab"
    })
  }
  
  context 'test definition' do
    it 'get structure' do
      structure = Dummy.structure
      expect(structure).to eql({
        :id            => Integer,
        :title         => String, 
        :desc          => String, 
        :price         => Float, 
        :quantity      => Integer, 
        :uuid          => String,
        :registered_at => Date
      })
    end
  end
  
  context 'Test Variables' do
    
    it "set valid values" do
      dummy               = Dummy.new 
      dummy.title         = "I'm a Dummy"
      dummy.desc          = "Lorem Ipsum" 
      dummy.price         = 9.5
      dummy.quantity      = 10
      dummy.uuid          = "bad85eb9-0713-4da7-8d36-07a8e4b00eab"
      dummy.registered_at = "14/02/2015"
      
      expected_values = {
        "title"         =>  "I'm a Dummy", 
        "desc"          =>  "Lorem Ipsum", 
        "price"         =>  9.5, 
        "quantity"      =>  10, 
        "registered_at" =>  "2015-02-14T00:00:00-03:00",
        "uuid"          =>  "bad85eb9-0713-4da7-8d36-07a8e4b00eab"
      }
      
      expect(dummy.attributes).to eql(expected_values)
    end
    
    it "set valid values from hash" do
      
      dummy = Dummy.new({
        title: "I'm another Dummy",
        desc:  "lorem ipsum",
        price: 10.5,
        quantity: 5,
        uuid: '2d931510-d99f-494a-8c67-87feb05e1594'
      })
      
      expected_values = {
        "title"       =>  "I'm another Dummy",
        "desc"        =>  "lorem ipsum",
        "price"       =>  10.5,
        "quantity"    =>  5,
        "uuid"        =>  "2d931510-d99f-494a-8c67-87feb05e1594"
      }
      
      expect(dummy.attributes).to eql(expected_values)
      
    end
    
    it "set invalid values" do
      
      dummy = Dummy.new
      dummy.uuid = "bad85eb9-0713-4da7-8d36-07a8e4b00eab"
      
      begin; dummy.price = "price"
      rescue Exception => e  
        expect(e.message).to eql("Type Error: Can't Parse String to Float for price")
      end
      
      begin; dummy.quantity = "quantity"
      rescue Exception => e  
        expect(e.message).to eql("Type Error: Can't Parse String to Integer for quantity")
      end
      
      begin; dummy.uuid     = "uuid"
      rescue Exception => e 
        expect(e.message).to eql("Read Only Error: Can't set uuid is a ReadOnly attribute")
      end
      
    end
    
  end
  
  context 'Test Class Methods' do
    
    it "build object" do 
      dummy = Dummy.build_object(Dummy, {
        id: 5,
        title: "dummy",
        desc: "Lorem"
      })
      expect(dummy.class).to eql(Dummy)
      expect(dummy.title).to eql("dummy")
    end
    
    it "append" do
      dummy = Dummy.new
      Dummy.append(dummy)
      expect(Dummy.last.class).to eql(Dummy)
      Dummy.clear
    end
    
    it "create" do 
      
      make_a_dummy_instance
      
      expect(Dummy.last.class).to eql(Dummy)
      expect(Dummy.last.title).to eql("dummy")
      expect(Dummy.last.desc).to eql("Lorem Ipsum")
      expect(Dummy.last.price).to eql(10.5)
      expect(Dummy.last.quantity).to eql(5)
      expect(Dummy.last.uuid).to eql("bad85eb9-0713-4da7-8d36-07a8e4b00eab")
      
      Dummy.clear
    end
    
    xit "load" do
      Dummy.load({uuid: "bad85eb9-0713-4da7-8d36-07a8e4b00eab"})
      dummy = Dummy.find_by_uuid("bad85eb9-0713-4da7-8d36-07a8e4b00eab")
      expect(dummy.class).to eql(Dummy) 
    end
    
    it "find" do 
      make_a_dummy_instance 
      expect(Dummy.find(1).class).to eql(Dummy) 
    end
    
    it "find_by" do
      
      make_a_dummy_instance
      
      expect(Dummy.find_by_title("dummy").class).to eql(Dummy)
      expect(Dummy.find_by_desc("Lorem Ipsum").class).to eql(Dummy)
      expect(Dummy.find_by_price(10.5).class).to eql(Dummy)
      expect(Dummy.find_by_quantity(5).class).to eql(Dummy)
      expect(Dummy.find_by_uuid("bad85eb9-0713-4da7-8d36-07a8e4b00eab").class).to eql(Dummy)
      
      Dummy.clear
    end
    
    it "all" do
      
    end
    
    it "clear" do
      make_a_dummy_instance
      Dummy.clear
      expect(Dummy.last).to eql(nil)
    end
    
    it "syncronize" do
      # TODO: Build a syncronize method
    end
    
    it "load_from_binary_file" do
      
    end
    
     
  end
  
  context 'Test Instance Methods' do
 
    
    it "to_json" do
      
      json_expected_response=({
        id:       1,
        title:    "dummy",
        desc:     "Lorem Ipsum",
        price:    10.5,
        quantity: 5,
        uuid:     "bad85eb9-0713-4da7-8d36-07a8e4b00eab"
      }).to_json
      
      expect(make_a_dummy_instance.to_json).to eql(json_expected_response)
      
    end
    
    it "set_variable" do
      
    end
    
    it "fill_from_response" do
      dummy = make_a_dummy_instance.fill_from_response({
        title: "title_updated"
      })
      expect(dummy.title).to eql("title_updated")
    end
    
    it "try_to_parse_and_format_with" do
      
    end
    
    it "assign_value_to" do
      
    end
    
    it "local_save" do
      
    end
    
    it "save" do
      
    end
    
    it "update" do
      
    end
    
    it "remote_save" do
      
    end
    
    xit "destroy" do
      dummy = make_a_dummy_instance
      dummy.destroy  
      expect(Dummy.last).to eql(nil) 
    end
    
    xit "remote_destroy" do
      
    end
    
    xit "primary_keys_hash" do
      primary_key_hash_expected = "01c81d991bc1d962afef939b92e0c7d5292483f28cf5ffb6418051852304112d"
      expect(make_a_dummy_instance.primary_keys_hash).to eql(primary_key_hash_expected)
    end 
    
    xit "idempotency_fields" do
      expect(make_a_dummy_instance.idempotency_fields).to eql("bad85eb9-0713-4da7-8d36-07a8e4b00eab")
    end
    
    xit "binary_dump_in_file" do
      dummy = make_a_dummy_instance
      file  = Tempfile.new('foo') 
      dummy.binary_dump_in_file(file) 
      
      recovered_object = Marshal::load(file)
      expect(recovered_object.class).to eql(Dummy)
    end
    
  end
  
  
  
end