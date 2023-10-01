#!/bin/bash

while IFS= read -r line; do
	case $line in
		"Title: "*) title=${line#*: } ;;
		"Link: "*) link=${line#*: } ;;
		"Description: "*) desc=${line#*: }
		desc=$(echo "$desc" | sed -e 's/—//' -e 's/mdash;//' -e 's/&/ /g')
		no_of_chars=$(echo "$desc" | wc -m)
		if [[ $no_of_chars -gt 100 ]]; then
			curl -s -d chat_id="@SlashdotFeed" -d text="<b>$title</b>"$'\n\n'"$desc"$'\n\n'"<a href=\"$(echo $link | awk -F '?' '{print $1}')\">🔗 read more</a> | @slashdotfeed" -d parse_mode="HTML" -d disable_web_page_preview="true" -X POST https://api.telegram.org/YOURTOKEN/sendMessage
		fi
		unset title link desc
		;;
	esac
done < <(rsstail -P -z -H -dl -u "https://rss.slashdot.org/Slashdot/slashdotMain" -n 1 -i 600) >/dev/null 2>&1 &
