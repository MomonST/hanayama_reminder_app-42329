ActiveAdmin.register Flower do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :scientific_name, :bloom_start_month, :bloom_end_month, :description, :image_url
  
  form do |f|
    f.inputs do
      f.input :name
      f.input :scientific_name
      f.input :bloom_start_month
      f.input :bloom_end_month
      f.input :description
      f.input :image_url, as: :file
    end
    f.actions
  end
end
