require 'csv'

map = {}

CSV.open(ARGV[0],'r:SJIS').each do |jname,ename,url|
#  puts jname,ename,url
  map[jname.to_s.encode("EUC-JP")] = url if jname && url
  map[ename.to_s.encode("EUC-JP")] = url if ename && url
end

#puts map.inspect

txt = open(ARGV[1],'r:EUC-JP').read

txt.gsub!(/\\(begin|end){thebibliography}({\d+})?$\n+/,"")
txt.gsub!(/--/,"-")
txt.gsub!(/^$\n/,"")

# add links to names
map.each_pair{ |k,url|
  txt.gsub!(k,"<a href=\"#{url}\">#{k}</a>")
}

records = txt.split(/^\\bibitem{.*}$\n/  # split item by \bibtiem{abc12def}
                    )[1..-1].map{ |item| # discard the first empty item
  # split each item by "\newblock " into authors, title, and other parts
  authors, title, rests = item.split(/\\newblock /).
  # remove { } and newline in each block 
  map{ |block| block.gsub(/[{}\n]/,"").gsub(/ +/," ") }
  # print it out
  puts <<ITEM
  <li>#{authors}<br>
  ``#{title}''<br>
  #{rests}
ITEM
}

