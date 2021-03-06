require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

require 'faster_csv'
namespace :products do

  desc "Создание мест хранения"
  task :setup_test_product_storages do
    csv_path = File.dirname(__FILE__) + '/products/test_places.csv'
    ActiveRecord::Base.transaction do
      FCSV.foreach(csv_path, :col_sep => ',', :headers => false) do |row|
        ProductStorage.create(name: row[0])
      end
    end
  end

  desc "Внесение тестовых товаров в склад"
  task :setup_test_products do
    csv_path = File.dirname(__FILE__) + '/products/test_data_products.csv'
    ActiveRecord::Base.transaction do
      FCSV.foreach(csv_path, :col_sep => ',', :headers => false) do |row|
        location = ProductStorage.where(name: row[2]).last
        if location.nil?
          location = ProductStorage.create(name: row[2])
        end
        group = ProductsGroup.where(name: row[1]).last
        if group.nil?
          group = ProductsGroup.create(name: row[1])
        end
        Product.create(name: row[0], group_id: group.id, location_id: location.id)
      end
    end
  end

end
