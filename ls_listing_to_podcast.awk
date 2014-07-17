# Given a listing of files in an S3 bucket, get the relevant info and create a podcast.xml file from them.
# sample listing
# note: exclude podcast file itself!

# ls -l --time-style="+%a, %d %h %Y %T %z" -i
BEGIN {
  date_cmd = "date '+%a, %d %h %Y %T %z'"
  date_cmd | getline d
  print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  print "<rss version=\"2.0\">"
  
  print "<channel>"

  print "<title>My Radio Podcast</title>"
  print "<description>Slurped internet radio</description>"
  print "<link>http://programmingobsession.blogspot.com</link>"
  print "<language>en-us</language>"
  print "<copyright>Copyright 2013</copyright>"
  print "<lastBuildDate>" d "</lastBuildDate>"
  print "<pubDate>" d "</pubDate>"
  print "<webMaster>derrick.schneider@gmail.com</webMaster>"

  directory = "podcasts/radio"
  host = "192.168.0.101"
}

/^total/ {next}

!/podcast\.xml/ {
  print "<item>"
  line_date = $7" "$8" "$9" "$10
  date_cmd = "date -j -f '%d %b %T %Y' '" line_date "' '+%a, %d %h %Y %T %z'"
  date_cmd | getline item_date
  close(date_cmd)
  size = $6
  id = $1
  file = substr($0, index($0,$11)) # get the last n fields
  url = "http://" host "/" directory "/" file
  split(file,components,".")
  
  print "<title>" components[1]"</title>"
  print "<link>" url "</link>"
  print "<guid>" url "</guid>"
  print "<description>" line_date "</description>"
  print "<enclosure url=\"" url "\" length=\"" size "\" type=\"audio/mpeg\"/>"
  print "<category>Podcasts</category>"
  print "<pubDate>" item_date "</pubDate>"
  print "</item>"
}

END {
  print "</channel>"
  print "</rss>"
}
