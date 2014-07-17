#!/usr/bin/awk -f

# ls -l --time-style="+%a, %d %h %Y %T %z" -i *-Googled.mp3 |./nas_podcast.awk >podcast.xml 

BEGIN {
  # directory = "podcasts/natures_numbers"
  # host = "192.168.0.101"
  title = "Googled"
  description = "Ken Auletta"

  "pwd" | getline d
  n = split(d,dd,"/")
  directory = dd[n-1] "/" dd[n]
  host = "andresaravena.duckdns.org:8081"

  date_cmd = "date '+%a, %d %h %Y %T %z'"
  date_cmd | getline d
  print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  print "<rss version=\"2.0\">"
  
  print "<channel>"

  print "<title>" title "</title>"
  print "<description>" description "</description>"
  print "<link>http://andresaravena.duckdns.org:8081/</link>"
  print "<language>en-us</language>"
  print "<copyright>?</copyright>"
  print "<image>"
  print "<url>http://" host "/" directory "/logo.png</url>"
  print "<width>140</width>"
  print "<height>175</height>"
  print "<link>http://andresaravena.duckdns.org:8081/</link>"
  print "<title>" title "</title>"
  print "</image>"
  print "<category>Podcasts</category>"
  print "<lastBuildDate>" d "</lastBuildDate>"
  print "<pubDate>" d "</pubDate>"
  print "<webMaster>andres.aravena@gmail.com</webMaster>"
}

/^total/ {next}

!/podcast\.xml/ {
  print "<item>"
  item_date = $7" "$8" "$9" "$10" "$11" "$12
  size = $6
  id = $1
  file = substr($0, index($0,$13)) # get the last n fields
  url = "http://" host "/" directory "/" file
  split(file,components,".")
  
  print "<title>" components[1]"</title>"
  print "<link>" url "</link>"
  print "<guid>" url "</guid>"
  print "<description>" line_date "</description>"
  print "<enclosure url=\"" url "\" length=\"" size "\" type=\"audio/mpeg\"/>"
  print "<pubDate>" item_date "</pubDate>"
  print "</item>"
}

END {
  print "</channel>"
  print "</rss>"
}

