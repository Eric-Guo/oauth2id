namespace :sync_nc_uap do
  desc 'Sync department with NC UAP'
  task sync_departments: :environment do
    puts 'Upserts the departments'
    NcUap.upserts_departments
    puts 'Sync managed by departments with fatherorg'
    NcUap.sync_managed_by_department_with_fatherorg
  end

  desc 'Sync positions with NC UAP (NC called om_post)'
  task sync_positions: :environment do
    puts 'Upserts the positions'
    NcUap.upserts_positions
  end
end