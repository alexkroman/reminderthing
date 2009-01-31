namespace :remindme do

task :import => :environment do
  Block.delete_all
  File.open("#{RAILS_ROOT}/db/data/AllBlocksReport.txt", 'r').each do |line|
    fields = line.split(",").collect { |l| l.strip.gsub(/"/,'') }
    number = "#{fields[0]}#{fields[1]}#{fields[2]}"
    carrier = find_carrier(fields[9])
    Block.create(:number => number.to_i,
                 :carrier => carrier) unless carrier.blank?
    end
end

  def find_carrier(carrier)
    case carrier.downcase!
    when /cricket/
      'cricket'
    when /verizon/
      'verizon'
    when /alltell/
      'alltell'
    when /ameritech/
      'ameritech'
    when /at&t/
      'at&t'
    when /cingular/
      'at&t'
    when /sprint/
      'sprint'
    when /nextel/
      'nextel'
    when /qwest/
      'qwest'
    when /bellsouth/
      'bellsouthmobility'
    when /blueskyfrog/
      'blueskyfrog'
    when /boost/
      'boost'
    when /cellularsouth/
      'cellularsouth'
    when /kajeet/
      'kajeet'
    when /metropcs/
      'metopcs'
    when /powertel/
      'powertel'
    when /pcs/
      'pcswireless'
    when /southern/
      'southernlink'
    when /suncom/
      'suncom'
    when /t-mobile/
      't-mobile'
    when /telus/
      'telusmobility'
    when /virgin/
      'virgin'
    else
      puts "Not found #{carrier}"
      nil
    end
  end

end
