#!/usr/bin/env bash

# Step1: Run bcftools isec to compare twist dilution series to expected variant calls

#--- 1. bcftools ---#
projdir="/g/data/gx8/projects/Mitchell_Accreditation/ctTSO_twist/"
name1="Twist0pc"
vcf1="/g/data/gx8/projects/Mitchell_Accreditation/ctTSO_twist/vcf_files/PTC_TwistVAF0pc_L2201383_MergedSmallVariants.vcf.gz"
lib="L2201383"

regions_bed="/g/data/gx8/projects/Mitchell_Accreditation/ctTSO_horizon/ctTSO_horizon/TST500C_manifest_merged_hg19.bed"
nameRef1="TwistReferenceSNVs" # include version
vcfRef1="/g/data/gx8/projects/Mitchell_Accreditation/ctTSO_twist/Twist_cfDNA_Pan-cancer_Reference_SNV_variant_sites_hg19_version_1a.vcf_sorted.vcf.gz"
nameRef2="TwistReferenceIndels" # include version
vcfRef2="/g/data/gx8/projects/Mitchell_Accreditation/ctTSO_twist/Twist_cfDNA_Pan-cancer_Reference_indel_variant_sites_hg19_version_1a.vcf_sorted.vcf.gz"
lab1="unfiltered" #ie "Dragen-3-9-3"
lab2="PassOnly"


outdir1="results/$name1-$lab1-$nameRef1"
outdir2="results/$name1-$lab1-$nameRef2"
outdir3="results/$name1-$lab2-$nameRef1"
outdir4="results/$name1-$lab2-$nameRef2"



bcftools isec $vcf1 $vcfRef1 -p $outdir1 -R $regions_bed
bcftools isec $vcf1 $vcfRef2 -p $outdir2 -R $regions_bed
bcftools isec $vcf1 $vcfRef1 -p $outdir3 -R $regions_bed -f .,PASS
bcftools isec $vcf1 $vcfRef2 -p $outdir4 -R $regions_bed -f .,PASS


Ref1all=$(bcftools view -H $vcfRef1 | wc -l)
Ref2all=$(bcftools view -H $vcfRef2 | wc -l)
Ref1covered=$(bcftools view -H $vcfRef1 -R $regions_bed | wc -l)
Ref2covered=$(bcftools view -H $vcfRef2 -R $regions_bed | wc -l)
totalvarpass=$(bcftools view -H -f .,PASS $vcf1 | wc -l)
snvTP=$(bcftools view -H $projdir$outdir3/0002.vcf | wc -l)
indelTP=$(bcftools view -H $projdir$outdir4/0002.vcf | wc -l)
snvFN=$(bcftools view -H $projdir$outdir3/0001.vcf | wc -l)
indelFN=$(bcftools view -H $projdir$outdir4/0001.vcf | wc -l)
snvTP_unfiltered=$(bcftools view -H $projdir$outdir1/0002.vcf | wc -l)
indelTP_unfiltered=$(bcftools view -H $projdir$outdir2/0002.vcf | wc -l)
snvFN_unfiltered=$(bcftools view -H $projdir$outdir1/0001.vcf | wc -l)
indelFN_unfiltered=$(bcftools view -H $projdir$outdir2/0001.vcf | wc -l)

# Print out metrics
echo -e "Library:\t $name1 $lib"
echo -e "RefSnvs:\t $Ref1all"
echo -e "RefIndels:\t $Ref2all"
echo -e "IncRefSnvs:\t $Ref1covered"
echo -e "IncRefIndels:\t $Ref2covered"
echo -e "TotalPassVariants:\t $totalvarpass"
echo -e "SnvTP:\t $snvTP"
echo -e "SnvFN:\t $snvFN"
echo -e "IndelTP:\t $indelTP"
echo -e "IndelFN:\t $indelFN"
echo -e "unfiltered SnvTP:\t $snvTP_unfiltered"
echo -e "unfiltered SnvFN:\t $snvFN_unfiltered"
echo -e "unfiltered IndelTP:\t $indelTP_unfiltered"
echo -e "unfiltered IndelFN:\t $indelFN_unfiltered"
