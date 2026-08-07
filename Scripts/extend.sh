#!/bin/bash

# extending homozygous regions to closest SNP
# NOTE: the chrom==$1 guard keeps the extension within a single chromosome.
#       Without it, the position of the first variant of a chromosome could be
#       overwritten using the last position of the previous chromosome.

maxsize=$3
awk -v maxsize="$maxsize" -F"\t" 'function abs(v) {return v < 0 ? -v : v} BEGIN{OFS="\t"} \
{if(state=="Yes" && $13=="No" && extend=="No" && chrom==$1) {$13="Yes"; extend="Yes"; if(abs(pos-$2)>maxsize*1000000) {$2=pos+maxsize*1000000}; $6="ext"} else {extend="No"} print $0} {state=$13; pos=$2; chrom=$1}' $1 \
| tac | awk -v maxsize="$maxsize" -F"\t" 'function abs(v) {return v < 0 ? -v : v} BEGIN{OFS="\t"} \
{if(state=="Yes" && $13=="No" && extend=="No" && chrom==$1) {$13="Yes"; extend="Yes"; if(abs(pos-$2)>maxsize*1000000) {$2=pos-maxsize*1000000}; $6="ext"} else {extend="No"} print $0} {state=$13; pos=$2; chrom=$1}' | tac > $2



