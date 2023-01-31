#!/bin/sh

ICAL="$1"

DATE_START="$(grep -E '^DTSTART;TZID=' "${ICAL}" | awk -F ':' '{ print $NF }' | cut -c 1-13 | sed 's/T/ /g')"
YMD_START="$(echo ${DATE_START} | cut -c 1-8)"
DATE_START="$(date --date="${DATE_START}" "+%Y/%m/%d(%a) %H:%M")"

DATE_END="$(grep -E '^DTEND;TZID=' "${ICAL}" | awk -F ':' '{ print $NF }' | cut -c 1-13 | sed 's/T/ /g')"
YMD_END="$(echo ${DATE_END} | cut -c 1-8)"

if [ "${YMD_START}" = "${YMD_END}" ]; then
    DATE_END="$(date --date="${DATE_END}" "+%Y/%m/%d(%a) %H:%M" | cut -d ' ' -f 2)"
else
    DATE_END="$(date --date="${DATE_END}" "+%Y/%m/%d(%a) %H:%M")"
fi

ORGANIZER_ADDR="$(grep -E '^ORGANIZER;CN=' "${ICAL}" | awk -F ':' '{ print $NF }' | tr -d '\r')"
ORGANIZER_NAME="$(grep -E '^ORGANIZER;CN=' "${ICAL}" | cut -d ';' -f 2 | cut -d ':' -f 1 | cut -d '=' -f 2 | tr -d '\r')"

ATTENDEE_REQ="$(grep -E -A 2 '^ATTENDEE;ROLE=REQ' "${ICAL}" | grep -E -v '^ATTENDEE' | awk -F ':' '{ print $NF }' | grep -F '@' | tr -d '\r')"
ATTENDEE_OPT="$(grep -E -A 2 '^ATTENDEE;ROLE=OPT' "${ICAL}" | grep -E -v '^ATTENDEE' | awk -F ':' '{ print $NF }' | grep -F '@' | tr -d '\r')"

ROOM="$(grep -E '^LOCATION' "${ICAL}" | awk -F ':' '{ print $NF }' | tr -d '\r')"

DESCRIPTION="$(cat "${ICAL}" | awk '/^DESCRIPTION;LANGUAGE=/,/^UID:/ {print $0}' | sed -r -e 's/\r//g' -e 's/DESCRIPTION;LANGUAGE=.*://' | grep -v -e '^UID:' -e 'RRULE:FREQ')"

echo
echo "    作成者: ${ORGANIZER_NAME} (${ORGANIZER_ADDR})"
echo "      日時: ${DATE_START} - ${DATE_END}"
echo "      場所: ${ROOM}"
echo "必須出席者:"
[ "${ATTENDEE_REQ}x" = "x" ] || echo "${ATTENDEE_REQ}" | while read line; do echo "      - ${line}"; done
echo "      - ${ORGANIZER_ADDR}"
echo "任意出席者:"
[ "${ATTENDEE_OPT}x" = "x" ] || echo "${ATTENDEE_OPT}" | while read line; do echo "      - ${line}"; done
echo
echo "${DESCRIPTION}"

#echo "出席者: ${ATTENDEE}, ${ORGANIZER_ADDR}"| \
#  nkf -w | \
#  sed -e 's/$/, /g' | \
#  tr -d '\n' | \
#  sed -e 's/, $//g'
