ActiveAdmin.register Product do
  permit_params :name, :description, :price, :picture

  form decorate: true do |f|
    f.inputs 'Information' do
      f.input :name
      f.input :description
      f.input :price
      f.input :picture
    end
    f.actions
  end
end
