require 'csv'

map = {}

CSV.open('urls.csv','r:SJIS').each do |jname,ename,url|
#  puts jname,ename,url
  map[jname.to_s.encode("EUC-JP")] = url if jname && url
  map[ename.to_s.encode("EUC-JP")] = url if ename && url
end

#puts map.inspect

txt = open('format.txt','r:EUC-JP').read

map.each_pair{ |k,url|
  txt.gsub!(k,"<a href=\"#{url}\">#{k}</a>")
}

puts txt

  
