#!/bin/bash
# Builds svg's for all workflows and creates an HTTP doc
# 2010 (c) Alex Ivkin
# v2.0
#
# run as $0 infile outfile
#
timestamp=`date`
echo "<html><head><title>ITIM Workflow documentation - $timestamp</title></head><body>">workflows_documentation.html
for i in *.xml ; do
	echo "Processing $i..."
	xsltproc -o "$i.dot" workflow2dot_graph.xslt "$i"
 	#20240821 - The original had output to SVG, but it didn't come out correctly for larger workflows
  	#           and I couldn't figure out where the bad data was coming from, so I switched it to PNG,
	#           which works like a champ.
	#dot -Tsvg -o "$i.svg" "$i.dot"
 	dot -Tpng -o "$i.png" "$i.dot"
	nodecount=$(grep node "$i.dot" | wc -l)
	widthlimit=$(($nodecount*100))
#	if [[ $nodecount -lt 6 ]]; then
#		if [[ $nodecount -lt 4 ]]; then
#			widthlimit=300
#		else
#			widthlimit=500
#		fi
#	else
#		widthlimit=1000
#	fi
	if [[ $widthlimit -gt 1000 ]]; then
		widthlimit=1000
	fi
	#${i:0:${#i}-24}
	name=$(echo $i | sed s/_[0-9]*\.xml//)
 	#20240821 - Another part of changing from SVG to PNG.
	#echo "<p align=center><object data=\"$i.svg\" width="$widthlimit" type="image/svg+xml"></p><p align=center><b>$name</b></p>">>workflows_documentation.html
 	echo "<p align=center><object data=\"$i.png\" width="$widthlimit" type="image/png"></p><p align=center><b>$name</b></p>">>workflows_documentation.html
done
echo "</body></html>">>workflows_documentation.html
