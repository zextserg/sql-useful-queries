SELECT url, SPLIT_PART(SPLIT_PART(url,'utm_source=',2),'&',1) as utm_source
FROM table1