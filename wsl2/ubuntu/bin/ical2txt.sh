#!/bin/sh

ICAL="$1"

DATE_START="$(grep -E '^DTSTART;TZID=' "${ICAL}" | awk -F ':' '{ print $NF }' | cut -c 1-13)"
DATE_START="$(date --date="${DATE_START}" "+%Y/%m/%d(%a) %H:%M")"

DATE_END="$(grep -E '^DTEND;TZID=' "${ICAL}" | awk -F ':' '{ print $NF }' | cut -c 1-13)"
DATE_END="$(date --date="${DATE_END}" "+%Y/%m/%d(%a) %H:%M")"

ORGANIZER_ADDR="$(grep -E '^ORGANIZER;CN=' "${ICAL}" | awk -F ':' '{ print $NF }' | tr -d '\r')"
ORGANIZER_NAME="$(grep -E '^ORGANIZER;CN=' "${ICAL}" | cut -d ';' -f 2 | cut -d ':' -f 1 | cut -d '=' -f 2 | tr -d '\r')"

ATTENDEE="$(grep -E -A 2 '^ATTENDEE' "${ICAL}" | grep -E -v '^ATTENDEE' | awk -F ':' '{ print $NF }' | grep -F '@' | tr -d '\r')"

ROOM="$(grep -E '^LOCATION' "${ICAL}" | awk -F ':' '{ print $NF }' | tr -d '\r')"

echo
echo "作成者: ${ORGANIZER_NAME} (${ORGANIZER_ADDR})"
echo "  日時: ${DATE_START} 〜 ${DATE_END}"
echo "  場所: ${ROOM}"
echo "出席者: ${ATTENDEE}"| nkf -w | sed -e 's/$/, /g' | tr -d '\r\n' | fold --space
