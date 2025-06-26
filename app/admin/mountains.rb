ActiveAdmin.register Mountain do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  
  permit_params :name, :region, :difficulty_level, :elevation, :latitude, :longitude, :description, :image_url
  
  form do |f|
    f.inputs do
      f.input :name
      f.input :region
      f.input :difficulty_level
      f.input :elevation
      f.input :latitude
      f.input :longitude
      f.input :description
      f.input :image_url, as: :file
    end
    f.actions
  end
end
