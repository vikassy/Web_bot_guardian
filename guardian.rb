require "mechanize"
all_links = Array.new 
search = 'hello'
`mkdir #{search}`
agent  = Mechanize.new
page = agent.get('http://www.guardian.co.uk/')
search_from = page.forms.first
search_from.q = search
page2 = agent.submit(search_from)
link = page2.links_with(dom_class: 'show-more')[1]
page3 = link.click
c = 1
for i in (1..20)
(page3/"h3.t2"/"a").each do |f|
	all_links << f.attributes["href"]
	puts "Got link #{c}"
	c = c+1
end
puts "Page#{c} links =>"
puts all_links
l = page3.link_with(dom_class: 'next-page')
page3 = l.click
end
puts 'Got all links !!'
a = 1
all_links.each do |f|
page = agent.get(f)
content = (page/"#article-body-blocks").text
File.open("#{search}/article#{a}.txt", 'w') {|f| f.write(content) }
puts "Wrote article#{a}"
a=a+1
end
`tar -zcvpf #{search}.tar #{search}`
puts "Compressed the folder #{search} to #{search}.tar"