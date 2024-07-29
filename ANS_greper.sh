#!/bin/bash

domain=$1
curl -o ext/$domain-ans_page.txt -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" "https://bgp.he.net/search?search%5Bsearch%5D=$domain&commit=Search"
grep -o 'AS[0-9]\+' ext/$domain-ans_page.txt > ext/$domain-asn_numbers.txt
sort -u ext/$domain-asn_numbers.txt > ext/$domain-sorted_ans.txt
while read -r asn; do
    # curl -o ext/$domain-$asn-result.txt -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" "https://bgp.he.net/$asn#_prefixes"
    curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" "https://bgp.he.net/$asn" -o ext/$domain-$asn-page.txt
    grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]+' ext/$domain-$asn-page.txt > ext/$domain-$asn-subnets.txt
    rm ext/$domain-$asn-page.txt
done < ext/$domain-asn_numbers.txt
rm ext/*-ans_page.txt  
rm ext/*-asn_numbers.txt  
rm ext/*-sorted_ans.txt
awk 'FNR==1 {if (NR!=1) print ""} {print}' ext/* > ext/subnet.txt 
sort -u ext/subnet.txt > ext/$domain.txt
mv ext/$domain.txt ext/../$domain.txt
exit 0
