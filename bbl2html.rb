# encoding: EUC-JP
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
txt.gsub!(/~/," ")


# add links to names
map.each_pair{ |k,url|
  txt.gsub!(k,"<a href=\"#{url}\">#{k}</a>")
}

def htmlprinter(authors,title,rests)
  puts <<ITEM
  <li>#{authors}<br>
  ``#{title}''<br>
  #{rests}
ITEM
end

class String
  def pick!(regexp)
    m=match(regexp) and begin
      self[m.begin(0)..m.end(0)-1]=''
      m
    end
  end
end

# pre-formatting for 業績リスト in 科研費実績報告書
def txtprinter(authors,title,rests)
  # remove italic tag
  rests.gsub!(/<\/?em>/,"")
  # remove names of editors 
  rests.gsub!(/^.*, editors?, /,"In ")
  # remove "In " from "In Proceedings of ...."
  rests.gsub!(/^In /,'')
  # pick page numbers up
  pages=rests.pick!(/ pp. (\d+)-(\d+),/)
  pages = "#{pages[1]}-#{pages[2]}"  if pages
  # pick volume and number up
  if volnum = rests.pick!(/ Vol. (\d+), No. (\d+),/)
    volnum = "#{volnum[1]}(#{volnum[2]})"
  elsif volnum = rests.match(/ Vol. (\d+) of (.*?),/)
    rests[volnum.begin(0)-1..volnum.end(0)-1] = " (#{volnum[2]}),"
    volnum = volnum[1] if volnum
  end
  # pick publication date
  ymd = rests.pick!(/(January|February|March|April|May|June|July|August|September|October|November|December) (\d{1,2}(-\d{1,2})? )?(\d{4})/)
  ymd = ymd[0] if ymd
  # remove trailing punctuations
  rests.gsub!(/, .$/,"")

  puts <<ITEM
著者名: #{authors.gsub(/, and /,', ').gsub(/.$/,'')}
論文標題: #{title.gsub(/.$/,'')}
雑誌名: #{rests}
査読の有無: 有無
巻: #{volnum}
発行年: #{ymd}
ページ: #{pages}


ITEM
end

records = txt.split(/^\\bibitem{.*}$\n/  # split item by \bibtiem{abc12def}
                    )[1..-1].map{ |item| # discard the first empty item
  # split each item by "\newblock " into authors, title, and other parts
  authors, title, rests = item.split(/\\newblock[ \n]/).
  # remove { } and newline in each block 
  map{ |block| block\
    .gsub(/\n/,"")\
    .gsub(/{\\em (.*?)}/, '<em>\1</em>')\
    .gsub(/[{}\n]/,"")\
    .gsub(/ +/," ") }
  # print it out
#  txtprinter(authors,title,rests)
  htmlprinter(authors,title,rests)
}

